import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/auth/generate_seed/views/generate_seed_view.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';

import '../controllers/recovery_select_controller.dart';

class RecoverySelectView extends GetView<RecoverySelectController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text('recovery_select_labels_top_title', style: TextStyle(fontSize: 20)),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text('recovery_select_labels_middle_help'.tr)
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 30),
              child: LightButton(
                child: Text('recovery_select_buttons_generate_new_seed'.tr, textAlign: TextAlign.center),
                isInline: false,
                onTap: () {
                  Get.to(GenerateSeedView(), arguments: {
                  });
                }
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10),
              child: LightButton(
                child: Text('recovery_select_buttons_recovery_phrase'.tr, textAlign: TextAlign.center),
                isInline: false,
                style: LightButtonStyle.WHITE_OUTLINE,
                onTap: () {

                }
              ),
            )
          ],
        )
      ),
    );
  }
}
