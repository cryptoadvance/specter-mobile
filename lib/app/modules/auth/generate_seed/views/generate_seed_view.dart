import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/auth/generate_seed/widgets/GeneratedSeed24WordList.dart';
import 'package:specter_mobile/app/modules/auth/generate_seed/widgets/GeneratedSeedSimpleList.dart';
import 'package:specter_mobile/app/modules/wallets/keys/views/keys_view.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';

import '../controllers/generate_seed_controller.dart';

class GenerateSeedView extends GetView<GenerateSeedController> {
  final GenerateSeedController controller = Get.put(GenerateSeedController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text('generate_seed_labels_top_title'.tr, style: TextStyle(fontSize: 20)),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text('generate_seed_labels_recovery_warning'.tr, style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white
                        )),
                      ),
                      Container(
                          constraints: BoxConstraints(
                              maxHeight: 300
                          ),
                          margin: EdgeInsets.only(top: 20),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Obx(() => (controller.seed_complexity == SEED_COMPLEXITY.SIMPLE) ? (
                                  GeneratedSeedSimpleList()
                              ):(
                                  GeneratedSeed24WordList()
                              ))
                          )
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          child: getControlComplexityPanel(controller)
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          child: getBottomButtonsPanel()
                      )
                    ]
                )
            )
        )
    );
  }

  Widget getControlComplexityPanel(GenerateSeedController controller) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Container(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text('generate_seed_labels_complexity_suggest'.tr, style: TextStyle(fontSize: 16)),
                          Text('generate_seed_labels_complexity_description'.tr, style: TextStyle(color: Colors.grey[300]))
                      ]
                  )
              )
          ),
          Expanded(
              flex: 0,
              child: Container(
                  child: Obx(() => Switch(
                    value: (controller.seed_complexity == SEED_COMPLEXITY.WORDS_24),
                    onChanged: (bool val) {
                        controller.setComplexityState(val?SEED_COMPLEXITY.WORDS_24:SEED_COMPLEXITY.SIMPLE);
                    },
                    activeTrackColor: Colors.blueGrey,
                    activeColor: Colors.white
                  )
                )
              )
          )
        ]
    );
  }

  Widget getBottomButtonsPanel() {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              child: LightButton(
                  child: Row(
                      children: [
                        Icon(CupertinoIcons.back),
                        Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text('generate_seed_buttons_prev_page'.tr)
                        )
                      ]
                  ),
                  style: LightButtonStyle.WHITE_OUTLINE,
                  onTap: () {
                    Get.back();
                  }
              )
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: LightButton(
                child: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Text('generate_seed_buttons_next_page'.tr)
                      ),
                      Icon(CupertinoIcons.check_mark)
                    ]
                ),
                style: LightButtonStyle.PRIMARY,
                onTap: () {
                  Get.to(KeysView(), arguments: {
                  });
                }
            ),
          )
        ]
    );
  }
}
