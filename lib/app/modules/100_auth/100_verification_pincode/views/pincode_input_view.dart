import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils.dart';

import '../controllers/pincode_input_controller.dart';

class PinCodeInputView extends GetView<PinCodeInputController> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Obx(() => getContent(context, constraints.maxWidth));
    });
  }

  Widget getContent(BuildContext context, double width) {
    final PinCodeInputController controller = Get.find<PinCodeInputController>();

    List<Widget> rows = [];
    int passwordLen = controller.pinCodeLength();
    //double buttonWidth = width / passwordLen;
    List<int> pinCode = controller.pinCode;
    print('build');
    for (int i = 0; i < passwordLen; i++) {
      bool isActive = (controller.getCurrentInputIndex() == i);
      rows.add(Container(
        //width: buttonWidth,
        padding: EdgeInsets.only(left: 4, right: 4),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: isActive?Utils.hexToColor('#263044'):Utils.hexToColor('#0A121B'),
            borderRadius: BorderRadius.all(Radius.circular(27))
          ),
          child: Text(
            pinCode[i].toString(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, color: Theme.of(context).accentColor)
          )
        )
      ));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: rows
    );
  }
}