import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';

import '../controllers/add_wallet_controller.dart';

class AddWalletSelectView extends GetView<AddWalletSelectController> {
  final bool displayExternalActions = Get.arguments['displayExternalActions'] ?? false;

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
                constraints: BoxConstraints(
                  maxWidth: 200
                ),
                child: Image.asset('assets/stickers/ghost_thinks-x512.png')
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text('add_wallet_labels_top_title'.tr, style: TextStyle(fontSize: 20))
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text('add_wallet_labels_middle_help'.tr)
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 50),
                child: LightButton(
                  isInline: false,
                  onTap: () {
                    Get.toNamed(Routes.CREATE_NEW_WALLET, arguments: {
                      'displayExternalActions': displayExternalActions
                    });
                  },
                  child: Text(
                    'add_wallet_buttons_create_wallet'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).accentColor)
                  )
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 24),
                child: LightButton(
                  isInline: false,
                  style: LightButtonStyle.SECONDARY,
                  onTap: () {
                    Get.toNamed(Routes.IMPORT_EXISTING_WALLET);
                  },
                  child: Text('add_wallet_buttons_import_wallet'.tr, textAlign: TextAlign.center)
                )
              )
            ]
          )
        )
      )
    );
  }
}
