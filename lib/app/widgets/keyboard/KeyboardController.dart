import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/services.dart' show rootBundle;

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
  Rx<bool> isDisabled = true.obs;

  Function? _submitProc;
  final RxList<String> _words = <String>[].obs;
  final RxList<String> helps = <String>[].obs;

  Map<String, bool> possibleChars = HashMap();

  @override
  void onInit() {
    super.onInit();
    loadWords();

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
    _words.value = [];
    super.onClose();
  }

  void loadWords() async {
    String data = await rootBundle.loadString('assets/bip-0039/english.txt');
    _words.value = data.split('\n');
    calcHelps();
  }

  void pressKey(BuildContext context, String ch) {
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
        if (txt.isNotEmpty) {
          txt = txt.substring(0, txt.length - 1);
        }
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
        _submitProc!();
        break;
      }
    }

    currentTextEditingController!.text = txt;
    currentTextEditingController!.selection = TextSelection.fromPosition(TextPosition(offset: currentTextEditingController!.text.length));

    //
    calcHelps();
  }

  void setValue(String ch) {
    if (currentTextEditingController == null) {
      return;
    }


    currentTextEditingController!.text = ch;
    currentTextEditingController!.selection = TextSelection.fromPosition(TextPosition(offset: currentTextEditingController!.text.length));
    _submitProc!();
  }

  void setCurrentFocus(TextEditingController? textEditingController) {
    currentTextEditingController = textEditingController;
    isDisabled.value = (textEditingController == null);

    //
    calcHelps();
  }

  void setSubmitProc(submitProc) {
    _submitProc = submitProc;
  }

  void calcHelps() {
    helps.value = getHelps();
  }

  List<String> getHelps() {
    if (currentTextEditingController == null) {
      return [];
    }

    int helpsMaxLen = 3;
    String txt = currentTextEditingController!.text;
    List<String> helpsRet = [];
    List<String> possibleWords = [];
    for(int i = 0; i < _words.length; i++) {
      String word = _words[i];
      if (word.indexOf(txt) == 0) {
        if (helpsRet.length < helpsMaxLen) {
          helpsRet.add(word);
        }
        
        possibleWords.add(word.substring(txt.length));
      }
    }

    possibleChars.clear();
    possibleWords.forEach((String word) {
      for (int i = 0; i < word.length; i++) {
        String ch = word[i];
        possibleChars[ch] = true;
      }
    });

    return helpsRet;
  }
}