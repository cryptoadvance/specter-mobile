import 'package:get/get.dart';

import 'package:specter_mobile/app/modules/auth/generate_seed/bindings/generate_seed_binding.dart';
import 'package:specter_mobile/app/modules/auth/generate_seed/views/generate_seed_view.dart';
import 'package:specter_mobile/app/modules/auth/recovery_select/bindings/recovery_select_binding.dart';
import 'package:specter_mobile/app/modules/auth/recovery_select/views/recovery_select_view.dart';
import 'package:specter_mobile/app/modules/auth/verification/bindings/verification_binding.dart';
import 'package:specter_mobile/app/modules/auth/verification/views/verification_view.dart';
import 'package:specter_mobile/app/modules/wallets/keys/bindings/keys_binding.dart';
import 'package:specter_mobile/app/modules/wallets/keys/views/keys_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.VERIFICATION;

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
  ];
}
