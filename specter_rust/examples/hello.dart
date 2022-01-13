import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import '../lib/specter_rust.dart';

void main() {
  print(SpecterRust.greet("Rust"));

  // 16 bytes in hex makes 12 word recovery phrase
  var entropy = "31313131313131313131313131313131";
  var mnemonic = SpecterRust.mnemonic_from_entropy(entropy);
  print(mnemonic);

  try{
    // invalid number of bytes should throw
    print(SpecterRust.mnemonic_from_entropy("313131313131313131313131313131"));    
  } catch (e) {
    print("Error: $e");
  }

  // root key and fingerprint
  var root = SpecterRust.mnemonic_to_root_key(mnemonic, "", "bitcoin");
  var xprv = root["xprv"];
  print(root);

  // xpub at some path
  var xpub = SpecterRust.derive_xpub(xprv, "m/84h/0h/0h");
  print(xpub);

  // default single-sig descriptor for bitcoin network
  var desc = SpecterRust.default_descriptors(xprv, "bitcoin");
  print(desc);

  // first 10 addresses
  var recv_desc = desc["recv_descriptor"];
  var addresses = SpecterRust.derive_addresses(recv_desc, "bitcoin", 0, 10);
  print(addresses);
}