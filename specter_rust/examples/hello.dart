import '../lib/specter_rust.dart';

void main() {
  print(SpecterRust.greet('Rust'));

  // First we need to generate entropy and convert it to hex.
  // 16 random bytes make 12-word mnemonic, 32 bytes makes 24-byte mnemonic.
  // Entropy should be generated from a secure random source.
  // Here 16 bytes are converted to hex and sent to rust to get back mnemonic:
  String entropy = '31313131313131313131313131313131';
  String mnemonic = SpecterRust.mnemonic_from_entropy(entropy);
  print(mnemonic);

  // If we pass invalid number of bytes or invalid hex string it will throw an exception
  try{
    // invalid number of bytes should throw
    print(SpecterRust.mnemonic_from_entropy('313131313131313131313131313131'));    
  } catch (e) {
    print('Error: $e');
  }

  // To derive root key from mnemonic we need to also pass bip39-password (empty string by default).
  // The function returns a dict {'fingerprint': '4-bytes-in-hex', 'xprv': 'root private key string'}
  var root = SpecterRust.mnemonic_to_root_key(mnemonic, '');
  String xprv = root['xprv']; // this is our key
  String fgp = root['fingerprint'];
  print(root);
  print('Fingerprint: $fgp');

  // Derive master public key at some path for current network:
  // Network can be 'bitcoin', 'testnet', 'regtest' and 'signet'. We assume main bitcoin network here
  var xpub = SpecterRust.derive_xpub(xprv, "m/84'/0'/0'", 'bitcoin');
  print(xpub);

  // Construct default wallet descriptor.
  // By default it constructs a single-sig segwit descriptor with path depending on the network.
  // Returns a dict {'recv_descriptor': string, 'change_descriptor': string}
  // Recv descriptor is used to derive receiving addresses of the wallet, change descriptor is used for internal change addresses.
  // Address view in the app should display receiving addresses by default
  // (not sure if we need change addresses anywhere except verification of the transactions)
  var desc = SpecterRust.get_default_descriptors(xprv, 'bitcoin');
  print(desc);

  // Derive first 10 addresses of the wallet for bitcoin network
  var recv_desc = desc['recv_descriptor'];
  var addresses = SpecterRust.derive_addresses(recv_desc, 'bitcoin', 0, 10);
  print(addresses);

  // get descriptor for account 3, type - nested segwit.
  var nested_desc_acc_2 = SpecterRust.get_account_descriptors(xprv, 3, 'nested', 'bitcoin');
  print(nested_desc_acc_2);

}