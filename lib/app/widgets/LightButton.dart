import 'package:flutter/material.dart';

import '../../utils.dart';

enum LightButtonStyle {
  PRIMARY,
  WHITE_OUTLINE,
  SECONDARY
}

class LightButton extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final bool isInline, isDisabled;
  final LightButtonStyle style;

  LightButton({
    required this.child,
    this.isInline = true,
    this.isDisabled = false,
    this.style = LightButtonStyle.PRIMARY,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    switch (style) {
      case LightButtonStyle.PRIMARY: {
        bgColor = Utils.hexToColor('#4A90E2');
        break;
      }
      case LightButtonStyle.WHITE_OUTLINE:
        bgColor = Colors.white;
        break;
      case LightButtonStyle.SECONDARY:
        bgColor = Utils.hexToColor('#202A40');
        break;
    }

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 250),
        opacity: isDisabled?0.2:1.0,
        child: Container(
          color: bgColor,
          child: TextButton(
            onPressed: () {
              if (isDisabled) {
                return;
              }
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
        ),
      )
    );
  }
}