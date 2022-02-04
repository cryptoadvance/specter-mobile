import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnterRecoveryPhraseListController extends GetxController {
  Map<int, FocusNode> focusNodes = HashMap();
  Map<int, TextEditingController> controllers = HashMap();

  final int seedSize = 24;
  int? currentFocusIdx = 1;

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
    focusNodes.forEach((key, focusNode) {
      focusNode.dispose();
    });
    focusNodes.clear();
    controllers.clear();
  }

  List<String> getSeedList() {
    List<String> list = [];
    bool haveData = false;
    controllers.forEach((key, ctx) {
      String val = ctx.text.trim();
      if (val.isNotEmpty) {
        haveData = true;
      }
      list.add(val);
    });
    if (!haveData) {
      return [];
    }
    return list;
  }

  void submitProc(BuildContext context) {
    var nextIdx = (currentFocusIdx ?? 0) + 1;
    if (!focusNodes.containsKey(nextIdx)) {
      return;
    }
    FocusScope.of(context).requestFocus(focusNodes[nextIdx]);
  }
}