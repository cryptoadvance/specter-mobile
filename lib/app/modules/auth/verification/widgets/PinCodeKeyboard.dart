import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/auth/verification/controllers/pincode_input_controller.dart';

class PinCodeKeyboard extends StatelessWidget {
  final PinCodeInputController controller = Get.find<PinCodeInputController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            getTopButtons(constraints.maxWidth),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: getBottomButtons(constraints.maxWidth),
            )
          ],
        );
      }),
    );
  }

  Widget getTopButtons(double width) {
    List<Widget> rows = [];
    double buttonWidth = width / 3;
    for (var i = 0; i < 3; i++) {
      List<Widget> columns = [];
      for (var s = 0; s < 3; s++) {
        columns.add(Container(
          width: buttonWidth,
          padding: EdgeInsets.only(left: columns.isEmpty?0:5, right: (s == 2)?0:5),
          child: getButton(i * 3 + s),
        ));
      }
      rows.add(Container(
        margin: EdgeInsets.only(top: rows.isEmpty?0:10),
        child: Row(
          children: columns
        ),
      ));
    }
    return Container(
      child: Column(
        children: rows,
      )
    );
  }

  Widget getBottomButtons(double width) {
    double buttonWidth = width / 3;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: buttonWidth,
          child: getBiometricAuthButton()
        ),
        Container(
          width: buttonWidth,
          padding: EdgeInsets.only(left: 5, right: 5),
          child: getButton(9),
        ),
        Container(
          width: buttonWidth,
          child: getCleanButton()
        )
      ]
    );
  }

  Widget getButton(int idx) {
    var code = controller.codes[idx];
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: Container(
        color: Colors.white,
        child: TextButton(
          onPressed: () {
            controller.addCode(code);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(50, 30),
            alignment: Alignment.centerLeft
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Center(
              child: Text(code.toString(), style: TextStyle(fontSize: 26, color: Colors.grey[800])),
            )
          )
        )
      )
    );
  }
  
  Widget getBiometricAuthButton() {
    return InkWell(
      onTap: () {
        print('auth');
      },
      child: Container(
        height: 60,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: SvgPicture.asset('assets/icons/face_id.svg', color: Colors.grey[900]),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: SvgPicture.asset('assets/icons/fingerprint.svg', color: Colors.grey[900]),
              )
            ],
          ),
        ),
      )
    );
  }

  Widget getCleanButton() {
    return InkWell(
      onTap: () {
        controller.clean();
      },
      child: Container(
        height: 60,
        child: Center(
          child: SvgPicture.asset('assets/icons/delete.svg', color: Colors.grey[900], width: 30)
        )
      )
    );
  }
}