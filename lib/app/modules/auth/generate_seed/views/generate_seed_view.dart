import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/auth/generate_seed/widgets/GeneratedSeedList.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';

import '../controllers/generate_seed_controller.dart';

class GenerateSeedView extends GetView<GenerateSeedController> {
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
                child: Text('Your recovery phrase', style: TextStyle(fontSize: 20)),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text('Write it down and never show to anybody!', style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: GeneratedSeedList()
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: getControlComplexityPanel()
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

  Widget getControlComplexityPanel() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Use 24 words', style: TextStyle(fontSize: 16)),
                Text(
                  'Generates a 24-word seed phrase containing 256 bits of entropy instead of 128 in a 12-word variant.',
                  style: TextStyle(color: Colors.grey[300]),
                ),
              ],
            )
          )
        ),
        Expanded(
          flex: 0,
          child: Container(
            child: Text('[C]'),
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
                  child: Text('BACK')
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
                  child: Text('DONE')
                ),
                Icon(CupertinoIcons.check_mark)
              ]
            ),
            style: LightButtonStyle.PRIMARY,
            onTap: () {

            }
          ),
        )
      ]
    );
  }
}
