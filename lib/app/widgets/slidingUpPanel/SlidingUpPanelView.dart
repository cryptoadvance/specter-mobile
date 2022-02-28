import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'SlidingUpPanelController.dart';

class SlidingUpPanelView extends GetView<SlidingUpPanelController> {
  final Widget body;
  final SlidingUpPanelController _controller;

  SlidingUpPanelView({required SlidingUpPanelController controller, required this.body}): _controller = controller;

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      onPanelSlide: (pos) {
        if (pos > 0) {
          _controller.slidingUpPanelIsOpen.value = true;
        }
      },
      onPanelOpened: () {
        _controller.slidingUpPanelIsOpen.value = true;
      },
      onPanelClosed: () {
        _controller.slidingUpPanelIsOpen.value = false;
        _controller.child.value = Container();
      },
      body: getBody(),
      panel: getSlideMenu(),
      minHeight: 0,
      backdropEnabled: true,
      color: Colors.transparent,
      controller: _controller.slidingUpPanelController,
    );
  }

  Widget getBody() {
    return Stack(
        children: [
          body,
          Obx(() => Container(
              child: _controller.slidingUpPanelIsOpen.value?BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  )
              ):null
          ))
        ]
    );
  }

  Widget getSlideMenu() {
    return Obx(() => _controller.child.value);
  }
}