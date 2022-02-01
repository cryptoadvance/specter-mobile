import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';

import 'KeyboardController.dart';

class KeyboardView extends GetView<KeyboardController> {
  final KeyboardController _controller;
  KeyboardView({required KeyboardController controller}): _controller = controller;

  @override
  Widget build(BuildContext context) {
    return LightButton(onTap: () {
      _controller.test(context);
    }, child: Text('X', style: TextStyle(color: Colors.white)));
  }
}