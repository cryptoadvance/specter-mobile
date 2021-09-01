import 'package:flutter/material.dart';

import '../../../../utils.dart';

class PinCodeInput extends StatelessWidget {
  final int passwordLen = 6;
  final int currentItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return getContent(context, constraints.maxWidth);
    });
  }

  Widget getContent(BuildContext context, double width) {
    List<Widget> rows = [];
    double buttonWidth = width / passwordLen;
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
          child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, color: Theme.of(context).accentColor))
        ),
      ));
    }
    return Row(
      children: rows
    );
  }
}