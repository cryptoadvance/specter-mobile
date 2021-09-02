import 'package:flutter/material.dart';

import '../../utils.dart';

enum LightButtonStyle {
  PRIMARY,
  WHITE_OUTLINE
}

class LightButton extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final bool isInline;
  final LightButtonStyle style;

  LightButton({
    required this.child,
    this.isInline = true,
    this.style = LightButtonStyle.PRIMARY,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    switch (style) {
      case LightButtonStyle.PRIMARY: {
        bgColor = Utils.hexToColor('#D5E6FB');
        break;
      }
      case LightButtonStyle.WHITE_OUTLINE:
        bgColor = Colors.white;
        break;
    }

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      child: Container(
        color: bgColor,
        child: TextButton(
          onPressed: () {
            onTap();
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            minimumSize: Size(50, 30),
            alignment: Alignment.centerLeft
          ),
          child: Container(
            width: (!isInline)?double.infinity:null,
            child: child,
          )
        )
      )
    );
  }
}