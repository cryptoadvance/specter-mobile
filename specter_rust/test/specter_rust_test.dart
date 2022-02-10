import 'package:flutter_test/flutter_test.dart';
import 'package:specter_rust/specter_rust.dart';

void main() {
  test('mnemonic_from_entropy', () {
    // 12-word mnemonic
    expect(
      SpecterRust.mnemonic_from_entropy('31313131313131313131313131313131'),
      'couple maze era give basic obtain shadow change couple maze era glide'
    );
    // 24-word mnemonic
    expect(
      SpecterRust.mnemonic_from_entropy('3131313131313131313131313131313131313131313131313131313131313131'),
      'couple maze era give basic obtain shadow change couple maze era give basic obtain shadow change couple maze era give basic obtain shadow course'
    );
    // invalid hex - odd number of chars
    expect(() => SpecterRust.mnemonic_from_entropy('3131313131313131313131313131313'), throwsException);
    // invalid hex - invalid char
    expect(() => SpecterRust.mnemonic_from_entropy('x3131313131313131313131313131313'), throwsException);
    // invalid entropy - not 16 or 32 bytes
    expect(() => SpecterRust.mnemonic_from_entropy('313131313131313131313131313131'), throwsException);
  });

  test('mnemonic_to_root_key', () {
    // without a password
    expect(
      SpecterRust.mnemonic_to_root_key('couple maze era give basic obtain shadow change couple maze era glide', ''),
      {'fingerprint': '312e05df', 'xprv': 'xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm' }
    );
    // with password
    expect(
      SpecterRust.mnemonic_to_root_key('couple maze era give basic obtain shadow change couple maze era glide', 'pa\$\$W0rd!'),
      {'fingerprint': '2a264346', 'xprv': 'xprv9s21ZrQH143K4RxC4zgqydAA9w8aynyzGDGBe4C9FwhPhrz1M8fTVEvXy9vC9MQAixdSg3JPmv7nMgFcD2fCdaj5Y42uB5RidivFhHUJKMi' }
    );
    // invalid mnemonic
    expect(() => SpecterRust.mnemonic_to_root_key('couple maze era give basic obtain shadow change couple maze era abandon', ''), throwsException);
    // valid mnemonic with 15 words - should it fail??? Should we support 15 and 18-word mnemonics?
    expect(() => SpecterRust.mnemonic_to_root_key('middle banner sunset more refuse icon add guess cruel nice replace clarify salad window way', ''), throwsException);
  });

  test('derive_xpub', () {
    // with h for hardened
    expect(
      SpecterRust.derive_xpub('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 'm/84h/0h/0h', 'bitcoin'),
      '[312e05df/84h/0h/0h]xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H'
    );
    // with ' for hardened
    expect(
      SpecterRust.derive_xpub('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', "m/84'/1'/0'", 'testnet'),
      "[312e05df/84'/1'/0']tpubDDn2rtW7sBWSjWbvweMpLwi8t3er1cYy4o99SJ1osrWULjvPG2XS9HQm55haCmxp5UhVtmFSdE8qhfyNgBZvqzMKj3CR8NF8yAwbTeji8jN"
    );
    // with tprv as root
    expect(
      SpecterRust.derive_xpub('tprv8ZgxMBicQKsPews2wvq5dsfyJHWXiaPkfXoMuLDPCLD8dL7DMG1GxeTxWXBowVs73iRMAbrQFSUouMA8KB9JNPrTwB9Q1idcMeG1T5BbVWQ', 'm/84h/0h/0h', 'bitcoin'),
      '[312e05df/84h/0h/0h]xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H'
    );
    // with non-hardened derivation
    expect(
      SpecterRust.derive_xpub('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 'm/0/1/2', 'bitcoin'),
      '[312e05df/0/1/2]xpub6CQXxMG5hw7Dj4LoEGmkKeGBaTKWxEMG3wn8otDVAWrxEwBsyBBEK5ZckeCRqbjJb7b8JC3Yknodi6HwNcAoeisrYH7ASRVDsaAPNpUgyPZ'
    );
    // with empty derivation
    expect(
      SpecterRust.derive_xpub('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 'm', 'testnet'),
      '[312e05df]tpubD6NzVbkrYhZ4YQtpqaVg3HL5sK2TsuafEqQ9BrFgcc1XTpMyyeps995pgg4E3kL71eY2dPC9sbs3cETeG9AMjzwYFqfHhh4mL2dxnNZwgSJ'
    );
    // invalid derivation - invalid char
    expect(() => SpecterRust.derive_xpub('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 'm/1f/2', 'testnet'), throwsException);
    // invalid derivation - trailing slash
    expect(() => SpecterRust.derive_xpub('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 'm/1/2/', 'testnet'), throwsException);
    // invalid derivation - missing m/
    expect(() => SpecterRust.derive_xpub('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', '1/2', 'testnet'), throwsException);
    // invalid network
    expect(() => SpecterRust.derive_xpub('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 'm/1', 'unknown'), throwsException);
    // invalid xprv
    expect(() => SpecterRust.derive_xpub('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZ', 'm/1', 'bitcoin'), throwsException);
  });

  test('get_descriptors', () {
    // segwit
    expect(
      SpecterRust.get_descriptors('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 'm/84h/0h/0h', 'segwit', 'bitcoin'),
      {
        'recv_descriptor': "wpkh([312e05df/84'/0'/0']xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H/0/*)#sdm5z7jr",
        'change_descriptor': "wpkh([312e05df/84'/0'/0']xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H/1/*)#pe74ltzm",
      }
    );
    // nested, testnet, non-standard path
    expect(
      SpecterRust.get_descriptors('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 'm/48h/1h/0h', 'nested', 'testnet'),
      {
        'recv_descriptor': "sh(wpkh([312e05df/48'/1'/0']tpubDD5NnAHJkEri3WeR9QP2McFoHeFte3Y9ytQAYKs2TwASMk5XutLLREGB8XvinTvUUU1wD2nvrzEwcXBzsQ1XkFdCKXEpqwLCVf2FHVpGNDb/0/*))#5ylsl677",
        'change_descriptor': "sh(wpkh([312e05df/48'/1'/0']tpubDD5NnAHJkEri3WeR9QP2McFoHeFte3Y9ytQAYKs2TwASMk5XutLLREGB8XvinTvUUU1wD2nvrzEwcXBzsQ1XkFdCKXEpqwLCVf2FHVpGNDb/1/*))#p93x89tp",
      }
    );
    // legacy
    expect(
      SpecterRust.get_descriptors('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 'm/44h/0h/0h', 'legacy', 'bitcoin'),
      {
        'recv_descriptor': "pkh([312e05df/44'/0'/0']xpub6CS6bnU3Z51mzCvMDgggeyCNQ8XT1dArAJwoZn51FaNTFQm9xDCTzFt7zqUPe61sqLMUEWCbFHdNA4cExrzDi5aMZJ7tEcCy4X8SJrovF3X/0/*)#tae43hru",
        'change_descriptor': "pkh([312e05df/44'/0'/0']xpub6CS6bnU3Z51mzCvMDgggeyCNQ8XT1dArAJwoZn51FaNTFQm9xDCTzFt7zqUPe61sqLMUEWCbFHdNA4cExrzDi5aMZJ7tEcCy4X8SJrovF3X/1/*)#6fu5vzny",
      }
    );
    // unknown type
    expect(() => SpecterRust.get_descriptors('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 'm/44h/0h/0h', 'raw', 'bitcoin'), throwsException);
  });

  test('get_default_descriptors', () {
    // mainnet
    expect(
      SpecterRust.get_default_descriptors('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 'bitcoin'),
      {
        'recv_descriptor': "wpkh([312e05df/84'/0'/0']xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H/0/*)#sdm5z7jr",
        'change_descriptor': "wpkh([312e05df/84'/0'/0']xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H/1/*)#pe74ltzm",
      }
    );
    // testnet (signet)
    expect(
      SpecterRust.get_default_descriptors('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 'signet'),
      {
        'recv_descriptor': "wpkh([312e05df/84'/1'/0']tpubDDn2rtW7sBWSjWbvweMpLwi8t3er1cYy4o99SJ1osrWULjvPG2XS9HQm55haCmxp5UhVtmFSdE8qhfyNgBZvqzMKj3CR8NF8yAwbTeji8jN/0/*)#lcggctks",
        'change_descriptor': "wpkh([312e05df/84'/1'/0']tpubDDn2rtW7sBWSjWbvweMpLwi8t3er1cYy4o99SJ1osrWULjvPG2XS9HQm55haCmxp5UhVtmFSdE8qhfyNgBZvqzMKj3CR8NF8yAwbTeji8jN/1/*)#wvdf97xg",
      }
    );
  });

  test('get_account_descriptors', () {
    // mainnet account 2
    expect(
      SpecterRust.get_account_descriptors('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 2, 'segwit', 'bitcoin'),
      {
        'recv_descriptor': "wpkh([312e05df/84'/0'/2']xpub6CXXH6KkmqEb1Dfr9Xwpo1B8RMShGbaSnYkbc8vMBHiPXRMCMGNJhFQF28ks7Xkp4PQBZ7TxLfu1kTwQBMgkxXdm3UdUpnunKhbkKvmYbjA/0/*)#n8ts2ytd",
        'change_descriptor': "wpkh([312e05df/84'/0'/2']xpub6CXXH6KkmqEb1Dfr9Xwpo1B8RMShGbaSnYkbc8vMBHiPXRMCMGNJhFQF28ks7Xkp4PQBZ7TxLfu1kTwQBMgkxXdm3UdUpnunKhbkKvmYbjA/1/*)#znw3h3m4",
      }
    );
    // testnet (signet) nested, account 3
    expect(
      SpecterRust.get_account_descriptors('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 3, 'nested', 'signet'),
      {
        'recv_descriptor': "sh(wpkh([312e05df/49'/1'/3']tpubDCwzf87ASQN62T68j8SR5LtRp4X2rK1r8U6yKBwvwA9fQmRbMmKx4RMmWcDhD2RTHSHxCXCacbKDiasqTzNGGvaHGkL6VZCKL9GjDnmbqez/0/*))#68l8lqpv",
        'change_descriptor': "sh(wpkh([312e05df/49'/1'/3']tpubDCwzf87ASQN62T68j8SR5LtRp4X2rK1r8U6yKBwvwA9fQmRbMmKx4RMmWcDhD2RTHSHxCXCacbKDiasqTzNGGvaHGkL6VZCKL9GjDnmbqez/1/*))#0x338l5n",
      }
    );
    // account at max index
    expect(
      SpecterRust.get_account_descriptors('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 2147483647, 'segwit', 'bitcoin'),
      {
        'recv_descriptor': "wpkh([312e05df/84'/0'/2147483647']xpub6CXXH6Ku7VmZ2wZ2DByEt8gDUxnt6wEbV74ydiaGhdKi6qMtatSyeLSQECpL5NrSDiATYwgCXQ6WEQUcdM1bg6rL8ZwCZX3LDJiQTcWRc3T/0/*)#p557e237",
        'change_descriptor': "wpkh([312e05df/84'/0'/2147483647']xpub6CXXH6Ku7VmZ2wZ2DByEt8gDUxnt6wEbV74ydiaGhdKi6qMtatSyeLSQECpL5NrSDiATYwgCXQ6WEQUcdM1bg6rL8ZwCZX3LDJiQTcWRc3T/1/*)#sq3lylpx",
      }
    );
    // negative account number
    expect( () => SpecterRust.get_account_descriptors('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', -3, 'nested', 'signet'), throwsException);
    // account larger than 0x80000000-1 ( 2147483647 )
    expect( () => SpecterRust.get_account_descriptors('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 2147483648, 'nested', 'signet'), throwsException);
  });

  test('derive_addresses', () {
    // mainnet addresses
    expect(
      SpecterRust.derive_addresses(
        "wpkh([312e05df/84'/0'/0']xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H/0/*)#sdm5z7jr",
        'bitcoin', 0, 10),
      [
        'bc1qx50sxylvwlpz32qjknld6twag2apqhvf5n3n2w',
        'bc1q3eyxm4q3m2nuycgfex9myc6x2rx4mxqc95rj4x',
        'bc1qujypaultffwyqp37pjkfelnm6ka5jseh2xt0d8',
        'bc1qwsefpmme345afvxwhny7tr7k33khgx3qw36zew',
        'bc1qavmyd0shjndwfv92ttf559dfks0pcws35yhsw6',
        'bc1qmkwpnr3psswd4qf8002tufdcytkf6zg8e7xq44',
        'bc1qxf4e8vhqxrdedn6l43rsgh3jrygufxatnsll5k',
        'bc1qtn0q7y6p4klplgpzfj3av8lnmw2rf0anls2wjh',
        'bc1quwua82dm46td2jhrnjwp8x45l02ey0ysk573f8',
        'bc1qz3eckwuufvgv40t3nftm9rkstkq8mwp5jzfhud',
      ]
    );
    // regtest - should it raise if xpubs are used?
    expect(
      SpecterRust.derive_addresses(
        "wpkh([312e05df/84'/0'/0']xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H/0/*)#sdm5z7jr",
        'regtest', 3, 5),
      ['bcrt1qwsefpmme345afvxwhny7tr7k33khgx3qx7cu45', 'bcrt1qavmyd0shjndwfv92ttf559dfks0pcws3ut4wzq']
    );
    // nested
    expect(
      SpecterRust.derive_addresses(
        "sh(wpkh([312e05df/49'/1'/3']tpubDCwzf87ASQN62T68j8SR5LtRp4X2rK1r8U6yKBwvwA9fQmRbMmKx4RMmWcDhD2RTHSHxCXCacbKDiasqTzNGGvaHGkL6VZCKL9GjDnmbqez/1/*))#0x338l5n",
        'regtest', 3, 5),
      ['2Mt1tSaRL4oPm3iTdL8YRLpqCqM22SVVuHr', '2N3SGwaDrTPyn21srqSRPXCEkEZMSmdZaBK']
    );
    // start > end - empty arr
    expect(
      SpecterRust.derive_addresses("sh(wpkh([312e05df/49'/1'/3']tpubDCwzf87ASQN62T68j8SR5LtRp4X2rK1r8U6yKBwvwA9fQmRbMmKx4RMmWcDhD2RTHSHxCXCacbKDiasqTzNGGvaHGkL6VZCKL9GjDnmbqez/1/*))#0x338l5n", 'regtest', 5, 3),
      []
    );
    // invalid index - negative
    expect(()=> SpecterRust.derive_addresses("sh(wpkh([312e05df/49'/1'/3']tpubDCwzf87ASQN62T68j8SR5LtRp4X2rK1r8U6yKBwvwA9fQmRbMmKx4RMmWcDhD2RTHSHxCXCacbKDiasqTzNGGvaHGkL6VZCKL9GjDnmbqez/1/*))#0x338l5n", 'regtest', -1, 3), throwsException);
    expect(()=> SpecterRust.derive_addresses("sh(wpkh([312e05df/49'/1'/3']tpubDCwzf87ASQN62T68j8SR5LtRp4X2rK1r8U6yKBwvwA9fQmRbMmKx4RMmWcDhD2RTHSHxCXCacbKDiasqTzNGGvaHGkL6VZCKL9GjDnmbqez/1/*))#0x338l5n", 'regtest', 0, 0x80000000), throwsException);
    // check it can derive 1000 addresses
    expect(
      SpecterRust.derive_addresses("sh(wpkh([312e05df/49'/1'/3']tpubDCwzf87ASQN62T68j8SR5LtRp4X2rK1r8U6yKBwvwA9fQmRbMmKx4RMmWcDhD2RTHSHxCXCacbKDiasqTzNGGvaHGkL6VZCKL9GjDnmbqez/1/*))#0x338l5n", 'regtest', 0, 1000).length,
      1000
    );
  });

  test('parse_descriptor', () {
    // TODO: more tests
    String root = 'xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm';
    var expected = {
      'recv_descriptor': "wsh(sortedmulti(1,[312e05df/84'/0'/0']xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H/0/*,[12345678/49'/1'/3']xpub6EpqBFyJW2qiEmgcYZqwEGCRuQh3y9fY72RWeAG7pNvKJWgnx7mkviWtfsF7VNQhWPx43zzNfkWhoF8RcnP2KKsXbNHrFNdzx8MFy83N5Sq/0/*))#0ahjda52",
      'change_descriptor': "wsh(sortedmulti(1,[312e05df/84'/0'/0']xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H/1/*,[12345678/49'/1'/3']xpub6EpqBFyJW2qiEmgcYZqwEGCRuQh3y9fY72RWeAG7pNvKJWgnx7mkviWtfsF7VNQhWPx43zzNfkWhoF8RcnP2KKsXbNHrFNdzx8MFy83N5Sq/1/*))#x4lq90gh",
      'keys': [
        "[312e05df/84'/0'/0']xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H/0/*",
        "[12345678/49'/1'/3']xpub6EpqBFyJW2qiEmgcYZqwEGCRuQh3y9fY72RWeAG7pNvKJWgnx7mkviWtfsF7VNQhWPx43zzNfkWhoF8RcnP2KKsXbNHrFNdzx8MFy83N5Sq/0/*",
      ],
      'mine': [true, false],
      'type': 'segwit',
      'policy': '1 of 2 multisig',
    };
    // test with /0/*
    expect(
      SpecterRust.parse_descriptor("wsh(sortedmulti(1,[312e05df/84h/0h/0h]xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H/0/*,[12345678/49'/1'/3']xpub6EpqBFyJW2qiEmgcYZqwEGCRuQh3y9fY72RWeAG7pNvKJWgnx7mkviWtfsF7VNQhWPx43zzNfkWhoF8RcnP2KKsXbNHrFNdzx8MFy83N5Sq/0/*))", root, 'bitcoin'),
      expected
    );
    // test with /{0,1}/*
    expect(
      SpecterRust.parse_descriptor("wsh(sortedmulti(1,[312e05df/84h/0h/0h]xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H/{0,1}/*,[12345678/49'/1'/3']xpub6EpqBFyJW2qiEmgcYZqwEGCRuQh3y9fY72RWeAG7pNvKJWgnx7mkviWtfsF7VNQhWPx43zzNfkWhoF8RcnP2KKsXbNHrFNdzx8MFy83N5Sq/{0,1}/*))", root, 'bitcoin'),
      expected
    );
    // test with /<0;1>/*
    expect(
      SpecterRust.parse_descriptor("wsh(sortedmulti(1,[312e05df/84h/0h/0h]xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H/<0;1>/*,[12345678/49'/1'/3']xpub6EpqBFyJW2qiEmgcYZqwEGCRuQh3y9fY72RWeAG7pNvKJWgnx7mkviWtfsF7VNQhWPx43zzNfkWhoF8RcnP2KKsXbNHrFNdzx8MFy83N5Sq/<0;1>/*))", root, 'bitcoin'),
      expected
    );
    // test without derivation at all - should add derivations automatically
    expect(
      SpecterRust.parse_descriptor("wsh(sortedmulti(1,[312e05df/84h/0h/0h]xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H,[12345678/49'/1'/3']xpub6EpqBFyJW2qiEmgcYZqwEGCRuQh3y9fY72RWeAG7pNvKJWgnx7mkviWtfsF7VNQhWPx43zzNfkWhoF8RcnP2KKsXbNHrFNdzx8MFy83N5Sq))", root, 'bitcoin'),
      expected
    );
  });

  test('parse_transaction', () {
    // TODO: more tests (malformed, multiwallet, custom sighashes)
    String root = 'xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm';
    String psbt = 'cHNidP8BAH0CAAAAAfDz5mfHe0eBUAbazbcr7we9vpo2+hxiiWxGnPMkwLj+AAAAAAD+////AoCWmAAAAAAAFgAUM0kk6vRugG6Gs1N6EvgVlQMNc6fNSV0FAAAAACIAIPS/xbC8hbQfm15NlCSFLrdSVY0nsQIaJQ5X9R3zbefg1gAAAAABAH0CAAAAAcGtDHVoTFXHMZZJSA8zJ362P1ZLvmPuyhqdb7k6bOWbAAAAAAD+////AgDh9QUAAAAAIgAgjG8duakkjuNk3IzbiMKr91QjvUUtT2/1Li4LXzxgBPlnEBAkAQAAABYAFKBfKSQYEBYs5aYwucljg4mW0OsuAAAAAAEBKwDh9QUAAAAAIgAgjG8duakkjuNk3IzbiMKr91QjvUUtT2/1Li4LXzxgBPkBBUdRIQJd2kbjIJNo6aA3muoxjqa3bietbgN7lqrbjMbPzScO9iEDqYT05aiCopyrT5gt8oIc8sM/JXv9nFbBVL5GR10uiptSriIGAl3aRuMgk2jpoDea6jGOprduJ61uA3uWqtuMxs/NJw72HLCvWO0wAACAAQAAgAAAAIACAACAAAAAAAAAAAAiBgOphPTlqIKinKtPmC3yghzywz8le/2cVsFUvkZHXS6KmxgxLgXfMAAAgAEAAIAAAACAAAAAAAAAAAAAAAEBR1EhAnV6ftmjyLLCxBLL3f1uGwzJDKTj+Lsu8TP7hdodCyVnIQMH1JWAelJ0hprNcX2+JnHw2b5yN4dA6nIwjesfkZ7m1FKuIgICdXp+2aPIssLEEsvd/W4bDMkMpOP4uy7xM/uF2h0LJWcYMS4F3zAAAIABAACAAAAAgAEAAAAAAAAAIgIDB9SVgHpSdIaazXF9viZx8Nm+cjeHQOpyMI3rH5Ge5tQcsK9Y7TAAAIABAACAAAAAgAIAAIABAAAAAAAAAAA=';
    // wallet used in this transaction
    var parsed_desc = SpecterRust.parse_descriptor('wsh(sortedmulti(1,[b0af58ed/48h/1h/0h/2h]tpubDED6SSLLgFCtDZNQv1BBCoe15uw4ebin4eN3MFNmdLtynBaXNEfVzdkVjqBL2E4kUzCYyYzc7GVNf8vv9Luefpwh2DWXbQVt8ZtCXmes2Zk/0/*,[312e05df/48h/1h/0h]tpubDD5NnAHJkEri3WeR9QP2McFoHeFte3Y9ytQAYKs2TwASMk5XutLLREGB8XvinTvUUU1wD2nvrzEwcXBzsQ1XkFdCKXEpqwLCVf2FHVpGNDb/0/*))', root, 'regtest');
    expect(parsed_desc['mine'], [false, true]);
    var wallet = {
      'recv_descriptor': parsed_desc['recv_descriptor'],
      'change_descriptor': parsed_desc['change_descriptor'],
    };
    var res = SpecterRust.parse_transaction(psbt, [wallet], 'regtest');
    expect(res, {
      'inputs': [
        {
          'address': 'bcrt1q33h3mwdfyj8wxexu3ndc3s4t7a2z8029948klafw9c9470rqqnusayrnw4',
          'value': 100000000,
          'wallets': [0],
        }
      ],
      'outputs': [
        {
          'address': 'bcrt1qxdyjf6h5d6qxap4n2dap97q4j5ps6ua8jkxz0z',
          'value': 10000000,
          'wallets': []
        },
        {
          'address': 'bcrt1q7jlutv9usk6plx67fk2zfpfwkaf9trf8kypp5fgw2l63mumdulsqvpnqt3',
          'value': 89999821,
          'wallets': [0]
        },
      ],
      'fee': 179,
    });
  });

  test('sign_transaction', () {
    // TODO: more tests (legacy, nested segwit, single-sig, miniscript)
    String root = 'xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm';
    String psbt = 'cHNidP8BAH0CAAAAAfDz5mfHe0eBUAbazbcr7we9vpo2+hxiiWxGnPMkwLj+AAAAAAD+////AoCWmAAAAAAAFgAUM0kk6vRugG6Gs1N6EvgVlQMNc6fNSV0FAAAAACIAIPS/xbC8hbQfm15NlCSFLrdSVY0nsQIaJQ5X9R3zbefg1gAAAAABAH0CAAAAAcGtDHVoTFXHMZZJSA8zJ362P1ZLvmPuyhqdb7k6bOWbAAAAAAD+////AgDh9QUAAAAAIgAgjG8duakkjuNk3IzbiMKr91QjvUUtT2/1Li4LXzxgBPlnEBAkAQAAABYAFKBfKSQYEBYs5aYwucljg4mW0OsuAAAAAAEBKwDh9QUAAAAAIgAgjG8duakkjuNk3IzbiMKr91QjvUUtT2/1Li4LXzxgBPkBBUdRIQJd2kbjIJNo6aA3muoxjqa3bietbgN7lqrbjMbPzScO9iEDqYT05aiCopyrT5gt8oIc8sM/JXv9nFbBVL5GR10uiptSriIGAl3aRuMgk2jpoDea6jGOprduJ61uA3uWqtuMxs/NJw72HLCvWO0wAACAAQAAgAAAAIACAACAAAAAAAAAAAAiBgOphPTlqIKinKtPmC3yghzywz8le/2cVsFUvkZHXS6KmxgxLgXfMAAAgAEAAIAAAACAAAAAAAAAAAAAAAEBR1EhAnV6ftmjyLLCxBLL3f1uGwzJDKTj+Lsu8TP7hdodCyVnIQMH1JWAelJ0hprNcX2+JnHw2b5yN4dA6nIwjesfkZ7m1FKuIgICdXp+2aPIssLEEsvd/W4bDMkMpOP4uy7xM/uF2h0LJWcYMS4F3zAAAIABAACAAAAAgAEAAAAAAAAAIgIDB9SVgHpSdIaazXF9viZx8Nm+cjeHQOpyMI3rH5Ge5tQcsK9Y7TAAAIABAACAAAAAgAIAAIABAAAAAAAAAAA=';
    String res = SpecterRust.sign_transaction(psbt, root);
    expect(res, 'cHNidP8BAH0CAAAAAfDz5mfHe0eBUAbazbcr7we9vpo2+hxiiWxGnPMkwLj+AAAAAAD+////AoCWmAAAAAAAFgAUM0kk6vRugG6Gs1N6EvgVlQMNc6fNSV0FAAAAACIAIPS/xbC8hbQfm15NlCSFLrdSVY0nsQIaJQ5X9R3zbefg1gAAAAABAH0CAAAAAcGtDHVoTFXHMZZJSA8zJ362P1ZLvmPuyhqdb7k6bOWbAAAAAAD+////AgDh9QUAAAAAIgAgjG8duakkjuNk3IzbiMKr91QjvUUtT2/1Li4LXzxgBPlnEBAkAQAAABYAFKBfKSQYEBYs5aYwucljg4mW0OsuAAAAAAEBKwDh9QUAAAAAIgAgjG8duakkjuNk3IzbiMKr91QjvUUtT2/1Li4LXzxgBPkiAgOphPTlqIKinKtPmC3yghzywz8le/2cVsFUvkZHXS6Km0cwRAIgS0xgodv7JGCxUYVvuG7DRknWP9W+sEp++g2bMS/Vg2MCIGkf0WfEoeCVaisbg2thcU/gr80x25Iewr9QdYjTphFwAQEFR1EhAl3aRuMgk2jpoDea6jGOprduJ61uA3uWqtuMxs/NJw72IQOphPTlqIKinKtPmC3yghzywz8le/2cVsFUvkZHXS6Km1KuIgYCXdpG4yCTaOmgN5rqMY6mt24nrW4De5aq24zGz80nDvYcsK9Y7TAAAIABAACAAAAAgAIAAIAAAAAAAAAAACIGA6mE9OWogqKcq0+YLfKCHPLDPyV7/ZxWwVS+RkddLoqbGDEuBd8wAACAAQAAgAAAAIAAAAAAAAAAAAAAAQFHUSECdXp+2aPIssLEEsvd/W4bDMkMpOP4uy7xM/uF2h0LJWchAwfUlYB6UnSGms1xfb4mcfDZvnI3h0DqcjCN6x+RnubUUq4iAgJ1en7Zo8iywsQSy939bhsMyQyk4/i7LvEz+4XaHQslZxgxLgXfMAAAgAEAAIAAAACAAQAAAAAAAAAiAgMH1JWAelJ0hprNcX2+JnHw2b5yN4dA6nIwjesfkZ7m1Bywr1jtMAAAgAEAAIAAAACAAgAAgAEAAAAAAAAAAA==');
  });

  test('greet', () {
    expect(SpecterRust.greet('Alice'), 'Hello Alice');
  });

  test('Trivial', () {
    expect(true, true);
  });
}
