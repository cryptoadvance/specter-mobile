use std::str::FromStr;

use bip39::Mnemonic;
use bitcoin::{
    secp256k1::{Message, Secp256k1},
    network::constants::Network,
    util::bip32::{
        ExtendedPrivKey, ExtendedPubKey, DerivationPath
    },
    util::bip143,
    util::psbt::PartiallySignedTransaction,
    base64,
    consensus::encode::{serialize, deserialize},
    blockdata::script::Script,
    blockdata::transaction::SigHashType
};
use miniscript::{
    DescriptorTrait, DescriptorPublicKey, TranslatePk2,
    psbt::{extract, finalize}
};
use bitcoin::hashes::hex::ToHex;
use std::fmt::Write as FmtWrite;

pub fn run() -> Result<String, std::fmt::Error> {
    let mut s = String::new();

    writeln!(&mut s, "Running bitcoin demo...")?;

    // Bitcoin regtest. Mainnet is Network::Bitcoin
    let net = Network::Regtest;
    // bip-39 recovery phrase
    let mnemonic = Mnemonic::parse(
        "carbon exile split receive diet either hunt lava math amount hover sheriff"
    ).unwrap();
    // mnemonic to seed with empty password
    let seed = mnemonic.to_seed("");
    // context for libsecp256k1
    let secp_ctx = Secp256k1::new();

    // generate root bip-32 key from seed
    let root = ExtendedPrivKey::new_master(net, &seed).unwrap();
    // fingerprint of the root for Core-like key representation
    // 4 first bytes of hash160(sec-pubkey)
    let fingerprint = root.fingerprint(&secp_ctx);

    // default path for bip-84 (native segwit)
    let path = "m/84h/1h/0h";
    let derivation = DerivationPath::from_str(path).unwrap();
    // child private key
    let child = root.derive_priv(&secp_ctx, &derivation).unwrap();
    // corresponding public key
    let xpub = ExtendedPubKey::from_private(&secp_ctx, &child);
    // Core-like xpub string [fingerprint/derivation]xpub
    let key = format!("[{}{}]{}", fingerprint, &path[1..], xpub);
    writeln!(&mut s, "Child public key at path {}:\n{}\n", path, key)?;

    // Core recv range descriptor wpkh(xpub/0/*)
    let desc = miniscript::Descriptor::<DescriptorPublicKey>::from_str(
        &format!("wpkh({}/0/*)", key)
    ).unwrap();
    writeln!(&mut s, "Receiving descriptor:\n{}\n", desc)?;
    // First 5 addresses corresponding to this descriptor
    writeln!(&mut s, "First 5 addresses:")?;
    for idx in 0..5 {
        let addr = desc.derive(idx)
            .translate_pk2(|xpk| xpk.derive_public_key(&secp_ctx)).unwrap()
            .address(net).unwrap();
        writeln!(&mut s, "{}", addr)?;
    }

    writeln!(&mut s, "")?;
    // Transaction signing
    let b64psbt = "cHNidP8BAHICAAAAAd8V9dM+cq5O2ZEQy4h4JWgVmat6v2WslAGyeR24AIJVAQAAAAD9////AnK9agAAAAAAFgAU0wICXbWyOFTyJWDMa2Xi9EDRVS3Axi0AAAAAABepFESE916yXwmgo3en89d0APg5Y3H4hwAAAAAAAQBxAgAAAAHNn9+mQdYz22Yvv9lDWF70ikNlocKcYQ6p6qaXhnlzIAAAAAAA/v///wL0wt4iAQAAABYAFIAUoRggqHw8rI0983dKLl3svJ5UgJaYAAAAAAAWABQo7Ad4T5KvYMrqXEfoAHm8n3Vh9AAAAAABAR+AlpgAAAAAABYAFCjsB3hPkq9gyupcR+gAebyfdWH0IgYDgeHshAILosyB/jBLXGZFWjXh0ydf0ZBN7A6vF9ShYLwYFVcuZVQAAIABAACAAAAAgAAAAAAAAAAAACICA0VKNSTVMgQmrmbW0byWWq24aDvmQIR5ujFpH7rYH5fCGBVXLmVUAACAAQAAgAAAAIABAAAAAAAAAAAA";
    let raw = base64::decode(b64psbt).unwrap();
    let mut psbt:PartiallySignedTransaction = deserialize(&raw).unwrap();
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
                let sc = Script::new_p2pkh(
                    &pk.public_key(&secp_ctx).pubkey_hash()
                );
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
    writeln!(&mut s, "Signed PSBT transaction:\n{}\n", signed)?;

    finalize(&mut psbt, &secp_ctx).unwrap();
    let rawtx = extract(&psbt, &secp_ctx).unwrap();
    writeln!(&mut s, "Raw transaction to broadcast:\n{}", serialize(&rawtx).to_hex())?;

    Ok(s)
}
