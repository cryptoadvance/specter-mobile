import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/demo_controller.dart';

class DemoView extends GetView<DemoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DemoView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'DemoView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
