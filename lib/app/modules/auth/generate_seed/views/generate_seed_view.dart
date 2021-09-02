import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/generate_seed_controller.dart';

class GenerateSeedView extends GetView<GenerateSeedController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'GenerateSeedView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
