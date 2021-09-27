import 'package:get/get.dart';

import 'package:specter_mobile/app/modules/000_hello/bindings/hello_binding.dart';
import 'package:specter_mobile/app/modules/000_hello/views/hello_view.dart';

import 'package:specter_mobile/app/modules/100_auth/100_verification/bindings/verification_binding.dart';
import 'package:specter_mobile/app/modules/100_auth/100_verification/views/verification_view.dart';

import 'package:specter_mobile/app/modules/100_auth/101_recovery_select/bindings/recovery_select_binding.dart';
import 'package:specter_mobile/app/modules/100_auth/101_recovery_select/views/recovery_select_view.dart';

import 'package:specter_mobile/app/modules/100_auth/102_generate_seed/bindings/generate_seed_binding.dart';
import 'package:specter_mobile/app/modules/100_auth/102_generate_seed/views/generate_seed_view.dart';

import 'package:specter_mobile/app/modules/200_wallets/keys/bindings/keys_binding.dart';
import 'package:specter_mobile/app/modules/200_wallets/keys/views/keys_view.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfo/bindings/wallet_info_binding.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfo/views/wallet_info_view.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfoAddress/bindings/wallet_info_address_binding.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfoAddress/views/wallet_info_address_view.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfoTransaction/bindings/wallet_info_transactions_binding.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfoTransaction/views/wallet_info_transactions_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HELLO;

  static final routes = [
    GetPage(
      name: _Paths.VERIFICATION,
      page: () => VerificationView(),
      binding: VerificationBinding(),
    ),
    GetPage(
      name: _Paths.RECOVERY_SELECT,
      page: () => RecoverySelectView(),
      binding: RecoverySelectBinding(),
    ),
    GetPage(
      name: _Paths.GENERATE_SEED,
      page: () => GenerateSeedView(),
      binding: GenerateSeedBinding(),
    ),
    GetPage(
      name: _Paths.KEYS,
      page: () => KeysView(),
      binding: KeysBinding(),
    ),
    GetPage(
      name: _Paths.WALLET_INFO,
      page: () => WalletInfoView(),
      binding: WalletInfoBinding(),
    ),
    GetPage(
      name: _Paths.WALLET_INFO_ADDRESS,
      page: () => WalletInfoAddressView(),
      binding: WalletInfoAddressBinding(),
    ),
    GetPage(
      name: _Paths.WALLET_INFO_TRANSACTIONS,
      page: () => WalletInfoTransactionView(),
      binding: WalletInfoTransactionBinding(),
    ),
    GetPage(
      name: _Paths.HELLO,
      page: () => HelloView(),
      binding: HelloBinding(),
    ),
  ];
}
