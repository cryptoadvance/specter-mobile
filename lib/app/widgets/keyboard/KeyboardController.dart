import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KeyboardLine {
  final List<String> keys;
  final bool useTopButtonWidth;

  KeyboardLine({
    required this.keys,
    this.useTopButtonWidth = false
  });
}

class KeyboardOptions {
  final List<KeyboardLine> keys;
  final List<String> keysDisabled;

  KeyboardOptions({
    required this.keys,
    this.keysDisabled = const []
  });

  bool isDisabled(String ch) {
    return keysDisabled.contains(ch);
  }
}

class KeyboardController extends GetxController  {
  TextEditingController? currentTextEditingController;

  KeyboardOptions? keyboardOptions;

  @override
  void onInit() {
    super.onInit();

    keyboardOptions = KeyboardOptions(
      keys: [
        KeyboardLine(keys: ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'], useTopButtonWidth: true),
        KeyboardLine(keys: ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'], useTopButtonWidth: true),
        KeyboardLine(keys: ['SHIFT', 'z', 'x', 'c', 'v', 'b', 'n', 'm', 'BACKSPACE']),
        KeyboardLine(keys: ['123', 'SPACE', 'ENTER'])
      ],
      keysDisabled: ['SHIFT', '123', 'SPACE']
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void pressKey(String ch) {
    if (currentTextEditingController == null) {
      return;
    }

    String txt = currentTextEditingController!.text;

    if (ch.length == 1) {
      txt += ch;
    }

    switch(ch) {
      case 'SHIFT': {
        break;
      }
      case 'BACKSPACE': {
        txt = txt.substring(0, txt.length - 1);
        break;
      }
      case '123': {
        break;
      }
      case 'SPACE': {
        txt += ' ';
        break;
      }
      case 'ENTER': {
        break;
      }
    }

    currentTextEditingController!.text = txt;
    currentTextEditingController!.selection = TextSelection.fromPosition(TextPosition(offset: currentTextEditingController!.text.length));
  }

  void setCurrentFocus(TextEditingController? textEditingController) {
    currentTextEditingController = textEditingController;
  }
}