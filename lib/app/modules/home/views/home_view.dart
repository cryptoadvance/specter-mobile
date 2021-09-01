import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/verification/views/verification_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('buttons_login'.tr),
            ElevatedButton(
                onPressed: () => Get.to(VerificationView(), arguments: {
                }), // Passing data by using "arguments"
                child: Text('Go to page One'))
          ],
        ),
      ),
    );
  }
}
