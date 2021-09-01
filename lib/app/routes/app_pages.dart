import 'package:get/get.dart';

import 'package:specter_mobile/app/modules/home/bindings/home_binding.dart';
import 'package:specter_mobile/app/modules/home/views/home_view.dart';
import 'package:specter_mobile/app/modules/verification/bindings/verification_binding.dart';
import 'package:specter_mobile/app/modules/verification/views/verification_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.TEST,
      page: () => VerificationView(),
      binding: VerificationBinding(),
    ),
  ];
}
