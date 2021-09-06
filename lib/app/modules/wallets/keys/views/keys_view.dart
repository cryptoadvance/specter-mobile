import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/wallets/keys/widgets/WalletsList.dart';
import 'package:specter_mobile/app/widgets/BottomMenu.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';

import '../controllers/keys_controller.dart';

class KeysView extends GetView<KeysController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: getTopPanel()
          ),
          SafeArea(
            top: false,
            child: BottomMenu()
          )
        ]
      )
    );
  }

  Widget getTopPanel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          bottom: false,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Text('Offline', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))
          ),
        ),
        Expanded(
          child: Container(
            child: WalletsList(),
          ),
        ),
        SafeArea(
          top: false,
          bottom: false,
          child: Container(
            padding: EdgeInsets.all(20),
            child: getActionsPanel()
          ),
        )
      ]
    );
  }

  Widget getActionsPanel() {
    return LightButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.plus),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: Text('ADD WALLET')
            )
          ]
        ),
        isInline: true,
        style: LightButtonStyle.PRIMARY,
        onTap: () {
          Get.to(KeysView(), arguments: {
          });
        }
    );
  }
}
