import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/pincode_input_controller.dart';

class PinCodeKeyboard extends StatelessWidget {
  final bool viewBiometricAuthButton;
  final Function openBiometricAuth, onComplete;

  PinCodeKeyboard({
    required this.viewBiometricAuthButton,
    required this.openBiometricAuth,
    required this.onComplete
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            getTopButtons(context, constraints.maxWidth),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: getBottomButtons(context, constraints.maxWidth),
            )
          ]
        );
      })
    );
  }

  Widget getTopButtons(BuildContext context, double width) {
    List<Widget> rows = [];
    double buttonWidth = width / 3;
    for (var i = 0; i < 3; i++) {
      List<Widget> columns = [];
      for (var s = 0; s < 3; s++) {
        columns.add(Container(
          width: buttonWidth,
          padding: EdgeInsets.only(left: columns.isEmpty?0:5, right: (s == 2)?0:5),
          child: getButton(context, i * 3 + s),
        ));
      }
      rows.add(Container(
        margin: EdgeInsets.only(top: rows.isEmpty?0:5),
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

  Widget getBottomButtons(BuildContext context, double width) {
    double buttonWidth = width / 3;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: buttonWidth,
          child: getBiometricAuthButton(context)
        ),
        Container(
          width: buttonWidth,
          padding: EdgeInsets.only(left: 5, right: 5),
          child: getButton(context, 9),
        ),
        Container(
          width: buttonWidth,
          child: getCleanButton(context)
        )
      ]
    );
  }

  Widget getButton(BuildContext context, int idx) {
    final PinCodeInputController controller = Get.find<PinCodeInputController>();

    var code = controller.codes[idx];
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: Container(
        color: Colors.transparent,
        child: TextButton(
          onPressed: () {
            if (!controller.addCode(code)) {
              onComplete();
            }
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(50, 30),
            alignment: Alignment.centerLeft,
            backgroundColor: Colors.transparent
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(code.toString(), style: TextStyle(fontSize: 26, color: Theme.of(context).accentColor)),
            )
          )
        )
      )
    );
  }
  
  Widget getBiometricAuthButton(BuildContext context) {
    if (!viewBiometricAuthButton) {
      return Container();
    }

    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
            color: Colors.transparent,
            child: TextButton(
                onPressed: () {
                  openBiometricAuth();
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(50, 30),
                    alignment: Alignment.centerLeft,
                    backgroundColor: Colors.transparent
                ),
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              child: SvgPicture.asset('assets/icons/face_id.svg', color: Theme.of(context).accentColor)
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: SvgPicture.asset('assets/icons/fingerprint.svg', color: Theme.of(context).accentColor)
                          )
                        ]
                      )
                    )
                )
            )
        )
    );
  }

  Widget getCleanButton(BuildContext context) {
    final PinCodeInputController controller = Get.find<PinCodeInputController>();

    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
            color: Colors.transparent,
            child: TextButton(
                onPressed: () {
                  controller.clean();
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(50, 30),
                    alignment: Alignment.centerLeft,
                    backgroundColor: Colors.transparent
                ),
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                        child: SvgPicture.asset('assets/icons/delete.svg', color: Theme.of(context).accentColor, width: 30)
                    )
                )
            )
        )
    );
  }
}