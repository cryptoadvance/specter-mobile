import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KeyboardController extends GetxController  {
  TextEditingController? currentTextEditingController;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void test(BuildContext context) {
    if (currentTextEditingController == null) {
      return;
    }

    String txt = currentTextEditingController!.text;
    txt = 'test1';

    currentTextEditingController!.text = txt;
    currentTextEditingController!.selection = TextSelection.fromPosition(TextPosition(offset: currentTextEditingController!.text.length));
  }

  void setCurrentFocus(TextEditingController? textEditingController) {
    currentTextEditingController = textEditingController;
  }
}