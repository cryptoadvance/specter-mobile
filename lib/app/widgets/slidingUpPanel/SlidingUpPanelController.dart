import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUpPanelController extends GetxController {
  PanelController slidingUpPanelController = PanelController();

  Rx<bool> slidingUpPanelIsOpen = false.obs;

  final Rx<Widget> child = Container().obs;

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

  void open(Widget child) {
    this.child.value = Container(
      child: child
    );
    slidingUpPanelController.open();
  }
}