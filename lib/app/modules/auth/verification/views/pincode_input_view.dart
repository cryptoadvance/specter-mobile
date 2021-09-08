import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/auth/verification/controllers/pincode_input_controller.dart';

import '../../../../../utils.dart';

class PinCodeInputView extends GetView<PinCodeInputController> {
  final int currentItemIndex = 0;

  final PinCodeInputController controller = Get.find<PinCodeInputController>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Obx(() => getContent(context, constraints.maxWidth));
    });
  }

  Widget getContent(BuildContext context, double width) {
    List<Widget> rows = [];
    int passwordLen = controller.pinCodeLength();
    double buttonWidth = width / passwordLen;
    List<int> pinCode = controller.pinCode;
    print('build');
    for (int i = 0; i < passwordLen; i++) {
      bool isActive = (currentItemIndex == i);
      rows.add(Container(
        width: buttonWidth,
        padding: EdgeInsets.only(left: 4, right: 4),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: isActive?Colors.white:Utils.hexToColor('#7B8794')
            ),
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          child: Text(
            pinCode[i].toString(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, color: Theme.of(context).accentColor)
          )
        ),
      ));
    }
    return Row(
      children: rows
    );
  }
}