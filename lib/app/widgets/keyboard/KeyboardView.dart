import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';

import 'KeyboardController.dart';

class KeyboardView extends GetView<KeyboardController> {
  final KeyboardController _controller;
  KeyboardView({required KeyboardController controller}): _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xff202B40),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        )
      ),
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return getContent(context, constraints.maxWidth);
      })
    );
  }

  Widget getContent(BuildContext context, double width) {
    double topButtonWidth = width / _controller.keyboardOptions!.keys[0].keys.length;

    List<Widget> rows = [];
    _controller.keyboardOptions!.keys.forEach((KeyboardLine keyboardLine) {
      rows.add(Container(
          child: getKeyboardLine(context, keyboardLine, width, topButtonWidth)
      ));
    });

    return Container(
      child: Column(
          children: rows
      )
    );
  }

  Widget getKeyboardLine(BuildContext context, KeyboardLine keyboardLine, double width, double topButtonWidth) {
    double buttonWidth = width / keyboardLine.keys.length;
    if (keyboardLine.useTopButtonWidth) {
      buttonWidth = topButtonWidth;
    }

    List<Widget> cls = [];
    for (int i = 0; i < keyboardLine.keys.length; i++) {
      String ch = keyboardLine.keys[i];
      cls.add(Container(
        width: buttonWidth,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: getKeyboardKey(ch)
      ));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: cls
    );
  }

  Widget getKeyboardKey(String ch) {
    bool isDisabled = _controller.keyboardOptions!.isDisabled(ch);

    Widget? keyIcon;
    if (ch.length == 1) {
      keyIcon = Text(ch, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
    } else {
      switch(ch) {
        case 'SHIFT': {
          keyIcon = SvgPicture.asset('assets/icons/keyboard/shift.svg', color: Colors.white, width: 20);
          break;
        }
        case 'BACKSPACE': {
          keyIcon = SvgPicture.asset('assets/icons/keyboard/backspace.svg', color: Colors.white, width: 25);
          break;
        }
        case '123': {
          keyIcon = Text('123', style: TextStyle(fontSize: 14));
          break;
        }
        case 'SPACE': {
          keyIcon = Text('space', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
          break;
        }
        case 'ENTER': {
          keyIcon = Text('enter', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
          break;
        }
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Material(
        color: isDisabled?Color(0xff293643):Color(0xFF2C3A55),
        child: InkWell(
          splashColor: isDisabled?Colors.transparent:null,
          hoverColor: isDisabled?Colors.transparent:null,
          highlightColor: isDisabled?Colors.transparent:null,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          onTap: () {
            if (isDisabled) {
              return;
            }
            _controller.pressKey(ch);
          },
          child: Center(
            child: Opacity(
              opacity: isDisabled?0.3:1.0,
              child: Container(
                child: keyIcon
              )
            )
          )
        )
      )
    );
  }
}