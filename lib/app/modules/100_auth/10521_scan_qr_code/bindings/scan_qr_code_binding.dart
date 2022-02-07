import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/slidingUpPanel/SlidingUpPanelController.dart';

import '../controllers/scan_qr_code_controller.dart';

class ScanQRCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanQRCodeController>(() => ScanQRCodeController());
    Get.create<SlidingUpPanelController>(() => SlidingUpPanelController());
  }
}
