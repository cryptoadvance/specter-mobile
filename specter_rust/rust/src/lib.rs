#![allow(unused_imports)]

use std::os::raw::{c_char};
use std::ffi::{CString, CStr};
use std::str::FromStr;

use std::collections::BTreeMap;
use bip39::Mnemonic;
use bitcoin::hashes::hex::FromHex;
use bitcoin::{
    secp256k1::{self, Message, Secp256k1},
    network::constants::Network,
    util::bip32::{
        ExtendedPrivKey, ExtendedPubKey, KeySource, DerivationPath, ChildNumber
    },
    util::{ bip143, ecdsa::PublicKey, address::Address },
    util::psbt::{self, PartiallySignedTransaction},
    base64,
    consensus::encode::{serialize, deserialize},
    blockdata::script::Script,
    blockdata::transaction::SigHashType
};
use miniscript::{
    DescriptorTrait, DescriptorPublicKey, TranslatePk2, ForEachKey,
    descriptor::DescriptorType,
    policy::Liftable,
    psbt::{extract, finalize},
};
use serde_json::{json, Value};
use serde::{Deserialize, Serialize};

mod bitcoin_demo;

#[path = "./../../rust_storage/src/specter_storage/mod.rs"]
pub mod specter_storage;

// ========================= MACROS ===========================

macro_rules! err {
    ($expression:expr) => {
        match $expression {
            Ok(a) => a,
            Err(e) => {
                return CString::new(json!({
                    "status": "error",
                    "message": format!("{}", e)
                }).to_string()).unwrap().into_raw();
            }
        }
    };
}

macro_rules! ok {
    ($x:expr) => {
        {
            CString::new(json!({
                "status": "success",
                "data": $x
            }).to_string()).unwrap().into_raw()
        }
    };
}

macro_rules! result {
    ($x:expr) => {
        {
            ok!(err!($x).to_string())
        }
    };
}

macro_rules! cstr {
    ($x:expr) => {
        {
            err!(unsafe { CStr::from_ptr($x) }.to_str())
        }
    };
}

// ========================= BITCOIN ===========================

#[no_mangle]
pub extern fn mnemonic_from_entropy(hex_entropy: *const c_char) -> *mut c_char {
    let hex_entropy = cstr!(hex_entropy);
    let entropy = err!(Vec::<u8>::from_hex(&hex_entropy));
    result!(Mnemonic::from_entropy(&entropy))
}

#[no_mangle]
pub extern fn mnemonic_to_root_key(mnemonic: *const c_char, password: *const c_char) -> *mut c_char {
    let mnemonic = cstr!(mnemonic);
    let password = cstr!(password);

    let mnemonic = err!(Mnemonic::parse(mnemonic));
    let seed = mnemonic.to_seed(password);

    // generate root bip-32 key from seed
    let root = err!(ExtendedPrivKey::new_master(Network::Bitcoin, &seed));

    let secp_ctx = Secp256k1::new();
    let fingerprint = root.fingerprint(&secp_ctx);
    ok!(json!({
        "fingerprint": fingerprint.to_string(),
        "xprv": root.to_string()
    }))
}

#[no_mangle]
pub extern fn derive_xpub(root: *const c_char, path: *const c_char, network: *const c_char) -> *mut c_char {
    let path = cstr!(path);
    let root = cstr!(root);
    let network = cstr!(network);

    let network = err!(network.parse::<Network>());
    let mut root = err!(ExtendedPrivKey::from_str(root));
    root.network = network;
    let derivation = err!(DerivationPath::from_str(path));

    // child private key
    let secp_ctx = Secp256k1::new();
    let fingerprint = root.fingerprint(&secp_ctx);
    let child = err!(root.derive_priv(&secp_ctx, &derivation));
    let xpub = ExtendedPubKey::from_private(&secp_ctx, &child);
    let key = format!("[{}{}]{}", fingerprint, &path[1..], xpub);
    ok!(key)
}

#[no_mangle]
pub extern fn get_descriptors(
    root: *const c_char, // xprv
    path: *const c_char, // derivation path like m/12h/34
    scripttype: *const c_char, // "segwit", "nested" or "legacy"
    network: *const c_char
) -> *mut c_char {

    let root = cstr!(root);
    let path = cstr!(path);
    let scripttype = cstr!(scripttype);
    let network = cstr!(network);

    let network = err!(network.parse::<Network>());
    let mut root = err!(ExtendedPrivKey::from_str(root));
    root.network = network;
    let derivation = err!(DerivationPath::from_str(path));

    let secp_ctx = Secp256k1::new();

    // child private key
    let fingerprint = root.fingerprint(&secp_ctx);
    let child = err!(root.derive_priv(&secp_ctx, &derivation));
    let xpub = ExtendedPubKey::from_private(&secp_ctx, &child);

    let key = format!("[{}{}]{}", fingerprint, &path[1..], xpub);

    let desc = match scripttype {
        "segwit" => format!("wpkh({}/0/*)", key),
        "nested" => format!("sh(wpkh({}/0/*))", key),
        "legacy" => format!("pkh({}/0/*)", key),
        "taproot" => format!("tr({}/0/*)", key),
        _ => err!(Err("Invalid script type"))
    };
    let recv_desc = err!(miniscript::Descriptor::<DescriptorPublicKey>::from_str(&desc));
    let change_desc = err!(miniscript::Descriptor::<DescriptorPublicKey>::from_str(&desc.replace("/0/*", "/1/*")));
    ok!(json!({
        "recv_descriptor": recv_desc.to_string(),
        "change_descriptor": change_desc.to_string(),
    }))
}

#[no_mangle]
pub extern fn derive_addresses(descriptor: *const c_char, network: *const c_char, start: u32, end: u32) -> *mut c_char {
    let descriptor = cstr!(descriptor);
    let network = cstr!(network);
    let descriptor = err!(miniscript::Descriptor::<DescriptorPublicKey>::from_str(descriptor));
    let network = err!(network.parse::<Network>());

    let secp_ctx = Secp256k1::new();
    let mut addr = Vec::new();
    for idx in start..end{
        let a = err!(err!(descriptor.derive(idx)
            .translate_pk2(|xpk| xpk.derive_public_key(&secp_ctx)))
            .address(network)).to_string();
        addr.push(a);
    }
    ok!(json!(addr))
}

/* parse descriptor, return a dict:
{ recv_descriptor, change_descriptor, type (segwit / nested / legacy), policy, keys:[key], mine:[bool] }
*/
#[no_mangle]
pub extern fn parse_descriptor(descriptor: *const c_char, root: *const c_char, network: *const c_char) -> *mut c_char {
    let descriptor = cstr!(descriptor);
    // TODO: fix for other branch indexes
    let arr: Vec<&str> = descriptor.split("#").collect();
    // {0,1} is used in Specter, <0;1> might be used in Core in the future
    let mut descriptor = arr[0].replace("/{0,1}/","/0/").replace("/<0;1>/", "/0/");
    // check if descriptor has any wildcards. If not - add default wildcards to all extended keys
    let tmp_desc = err!(miniscript::Descriptor::<DescriptorPublicKey>::from_str(&descriptor));
    if !tmp_desc.is_deriveable() {
        descriptor = tmp_desc.to_string().split("#").collect::<Vec<&str>>()[0].to_string();
        tmp_desc.for_each_key(|k| {
            match k.as_key() {
                DescriptorPublicKey::SinglePub(_) => { true },
                DescriptorPublicKey::XPub(_) => {
                    let kstr = k.as_key().to_string();
                    descriptor = descriptor.replace(&kstr, &format!("{}/0/*", &kstr));
                    true
                },
            }
        });
    }
    let change_desc = descriptor.replace("/0/*", "/1/*");
    let network = cstr!(network);
    let root = cstr!(root);
    let change_desc = err!(miniscript::Descriptor::<DescriptorPublicKey>::from_str(&change_desc));
    let descriptor = err!(miniscript::Descriptor::<DescriptorPublicKey>::from_str(&descriptor));
    let network = err!(network.parse::<Network>());
    let mut root = err!(ExtendedPrivKey::from_str(root));
    if network != Network::Bitcoin {
        // equality check requires networks to be the same
        // so regtest and signet must become testnet for eq to hold
        root.network = Network::Testnet;
    }

    let mut keys = Vec::<String>::new();
    descriptor.for_each_key(|k| {
        keys.push(k.as_key().to_string()); 
        true
    });
    let script_type = match descriptor.desc_type() {
        DescriptorType::ShWpkh | DescriptorType::ShWsh | DescriptorType::ShWshSortedMulti => "nested",
        DescriptorType::Wpkh | DescriptorType::Wsh | DescriptorType::WshSortedMulti => "segwit",
        _ => "legacy",
    };
    let policy = match descriptor.desc_type() {
        DescriptorType::Wpkh | DescriptorType::ShWpkh | DescriptorType::Pkh => "single key".to_string(),
        DescriptorType::ShWshSortedMulti | DescriptorType::WshSortedMulti | DescriptorType::ShSortedMulti => {
            let pol = descriptor.lift().unwrap();
            let m = pol.minimum_n_keys();
            format!("{} of {} multisig", m, keys.len())
        },
        _ => {
            let pol = descriptor.lift().unwrap();
            let mut s = pol.to_string();
            for (i, k) in keys.iter().enumerate() {
                // all keys should be pk(k) instead of pkh(k)?
                // and replaced with aliases
                s = s.replace(&format!("pkh({})", k), &format!("pk(key_{})", i));
            }
            s
        },
    };

    let secp_ctx = Secp256k1::new();
    let fingerprint = root.fingerprint(&secp_ctx);

    // checks the key is mine
    let mine : Vec<bool> = keys.iter().map(|k| {
        let k = DescriptorPublicKey::from_str(k).unwrap();
        // only xpub can be mine ?
        match k {
            DescriptorPublicKey::SinglePub(_p) => false,
            DescriptorPublicKey::XPub(xpub) => {
                match xpub.origin {
                    // TODO: check [fgp/der]pubkey if it is just pubkey
                    // check fingerprint and derivation
                    Some((fgp, derivation)) => {
                        if fgp != fingerprint {
                            return false; 
                        }
                        let child = root.derive_priv(&secp_ctx, &derivation).unwrap();
                        xpub.xkey == ExtendedPubKey::from_private(&secp_ctx, &child)
                    },
                    // check xpub itself
                    None => xpub.xkey == ExtendedPubKey::from_private(&secp_ctx, &root),
                }
            },
        }
    }).collect();

    ok!(json!({
        "recv_descriptor": descriptor.to_string(),
        "change_descriptor": change_desc.to_string(),
        "type": script_type,
        "policy": policy,
        "keys": keys,
        "mine": mine,
    }))
}


#[derive(Debug, Serialize, Deserialize)]
struct WJSON {
    pub recv_descriptor: String,
    pub change_descriptor: String,
}

enum Scope {
    Inp(psbt::Input),
    Out(psbt::Output, Script),
}

struct Wallet {
    recv_descriptor: miniscript::Descriptor::<DescriptorPublicKey>,
    change_descriptor: miniscript::Descriptor::<DescriptorPublicKey>,
}

impl Wallet {
    fn check_script<C: secp256k1::Verification>(&self, secp_ctx: &Secp256k1<C>, bip32_derivation: &BTreeMap<PublicKey, KeySource>, script_pubkey: &Script) -> bool{
        for (_pubkey, derivation) in bip32_derivation.iter() {
            // TODO: fix for generic descriptors
            let der = derivation.1.clone();
            let last_idx : u32 = der[der.len()-1].into();
            let change_idx : u32 = der[der.len()-2].into();
            let mut desc = &self.recv_descriptor;
            if change_idx == 1 {
                desc = &self.change_descriptor;
            };
            let desc = desc.derive(last_idx).translate_pk2(|xpk| xpk.derive_public_key(&secp_ctx)).unwrap();
            return &desc.script_pubkey() == script_pubkey;
        }
        false
    }

    fn owns<C: secp256k1::Verification>(&self, secp_ctx: &Secp256k1<C>, scope: &Scope) -> bool{
        match scope {
            Scope::Inp(inp) => {
                let sc = inp.witness_utxo.as_ref().unwrap().script_pubkey.clone();
                return self.check_script(secp_ctx, &inp.bip32_derivation, &sc);
            }
            Scope::Out(out, sc) => {
                return self.check_script(secp_ctx, &out.bip32_derivation, &sc);
            }
        }
    }
}

#[no_mangle]
pub extern fn parse_transaction(psbt: *const c_char, wallets: *const c_char, network: *const c_char) -> *mut c_char{
    let wallets = cstr!(wallets);
    let network = cstr!(network);
    let psbt = cstr!(psbt);
    let network = err!(network.parse::<Network>());
    let wallets : Vec<WJSON> = err!(serde_json::from_str(wallets));
    let wallets : Vec<Wallet> = wallets.iter().map(|w| {
        Wallet {
            recv_descriptor: miniscript::Descriptor::<DescriptorPublicKey>::from_str(&w.recv_descriptor).unwrap(),
            change_descriptor: miniscript::Descriptor::<DescriptorPublicKey>::from_str(&w.change_descriptor).unwrap(),
        }
    }).collect();
    let raw = err!(base64::decode(psbt));
    let psbt:PartiallySignedTransaction = err!(deserialize(&raw));
    // parse inputs and outputs
    let secp_ctx = Secp256k1::new();
    let mut fee = 0;
    let ins : Vec<Value> = psbt.inputs.iter().map(|inp| {
        let utxo = inp.witness_utxo.clone().unwrap();
        fee += utxo.value;
        json!({
            "value": utxo.value,
            "address": Address::from_script(&utxo.script_pubkey, network).unwrap(),
            "wallets": wallets.iter().enumerate().map(|(i, w)| {
                if w.owns(&secp_ctx, &Scope::Inp(inp.clone())){
                    i as i32
                } else {
                    -1
                }
            }).filter(|i| i>=&0).collect::<Vec<i32>>(),
        })
    }).collect();
    let outs : Vec<Value> = psbt.outputs.iter().enumerate().map(|(i, out)| {
        let utxo = psbt.global.unsigned_tx.output[i].clone();
        fee -= utxo.value;
        json!({
            "value": utxo.value,
            "address": Address::from_script(&utxo.script_pubkey, network).unwrap(),
            "wallets": wallets.iter().enumerate().map(|(i, w)| {
                if w.owns(&secp_ctx, &Scope::Out(out.clone(), utxo.script_pubkey.clone())) {
                    i as i32
                } else {
                    -1
                }
            }).filter(|i| i>=&0).collect::<Vec<i32>>(),
        })
    }).collect();
    ok!(json!({
        "inputs": ins,
        "outputs": outs,
        "fee": fee,
    }))
}

#[no_mangle]
pub extern fn sign_transaction(psbt: *const c_char, root: *const c_char) -> *mut c_char{
    // TODO: fix to work with legacy transactions
    let psbt = cstr!(psbt);
    let root = cstr!(root);
    let raw = err!(base64::decode(psbt));
    let mut psbt:PartiallySignedTransaction = err!(deserialize(&raw));
    let root = err!(ExtendedPrivKey::from_str(root));
    let secp_ctx = Secp256k1::new();
    let fingerprint = root.fingerprint(&secp_ctx);

    // sign all inputs
    for (i, inp) in psbt.inputs.iter_mut().enumerate() {
        // find matching derivations
        for (pubkey, derivation) in inp.bip32_derivation.iter() {
            // check fingerprint
            if fingerprint == derivation.0 {
                // derive private key
                let pk = root.derive_priv(&secp_ctx, &derivation.1)
                             .unwrap()
                             .private_key;

                // Calculate and sign the transaction hash
                // p2pkh script is a special case for segwit single-sig
                // In other cases we can use witness_script from psbt input, or redeem script / scriptpubkey for legacy
                // Can be refactored and moved to the beginning of per-input loop
                let sc = match &inp.witness_script {
                    Some(sc) => sc.clone(),
                    None => {
                        Script::new_p2pkh(&pk.public_key(&secp_ctx).pubkey_hash())
                    }
                };
                let value = match &inp.witness_utxo {
                    Some(utxo) => utxo.value,
                    _ => panic!("utxo is missing")
                };
                // hash to sign
                let h = bip143::SigHashCache::new(&psbt.global.unsigned_tx).signature_hash(
                    i, &sc, value, SigHashType::All
                ).as_hash();
                let sig = secp_ctx.sign(
                    &Message::from_slice(&h).unwrap(),
                    &pk.key,
                );
                let mut final_signature = Vec::with_capacity(75);
                final_signature.extend_from_slice(&sig.serialize_der());
                final_signature.push(SigHashType::All.as_u32() as u8);

                inp.partial_sigs.insert(pubkey.clone(), final_signature);
            }
        }
    }
    let signed = base64::encode(&serialize(&psbt));
    ok!(signed)
}

// ========================= OTHER ===========================

#[no_mangle]
pub extern fn rust_greeting(to: *const c_char) -> *mut c_char {
    let c_str = unsafe { CStr::from_ptr(to) };
    let recipient = match c_str.to_str() {
        Err(_) => "there",
        Ok(string) => string,
    };

    CString::new("Hello ".to_owned() + recipient).unwrap().into_raw()
}

#[no_mangle]
pub extern fn rust_cstr_free(s: *mut c_char) {
    unsafe {
        if s.is_null() { return }
        CString::from_raw(s)
    };
}

#[no_mangle]
pub extern fn run_bitcoin_demo() -> *mut c_char {
    let log = bitcoin_demo::run().unwrap();
    CString::new(log).unwrap().into_raw()
}

#[cfg(test)]
mod tests {
    use std::ffi::{CString, CStr};

    #[test]
    fn rust_greeting() {
        let name = CString::new("Alice").unwrap();
        let res = super::rust_greeting(name.as_ptr());
        let res_cstr = unsafe { CStr::from_ptr(res) };
        assert_eq!(res_cstr.to_str().unwrap(), "Hello Alice");
        super::rust_cstr_free(res);
    }
}