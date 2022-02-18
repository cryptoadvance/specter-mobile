import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';

import '../../../../../utils.dart';
import '../controllers/create_new_wallet_controller.dart';

class CreateNewWalletView extends GetView<CreateNewWalletController> {
  final bool displayExternalActions = Get.arguments['displayExternalActions'] ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              controller.viewTap(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: getTopSide()
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: getNameInputSide()
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: getTypesSide(context)
                  )
                ]
              )
            ),
          )
        ),
      )
    );
  }

  Widget getTopSide() {
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: getBackButton()
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                child: Text('Name your\nwallet', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
                            )
                          ]
                      )
                  )
              )
            ]
        )
    );
  }

  Widget getBackButton() {
    return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Get.back();
        },
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 10),
            child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Utils.hexToColor('#202A40'),
                    shape: BoxShape.circle
                ),
                child: Icon(CupertinoIcons.left_chevron, size: 24)
            )
        )
    );
  }

  Widget getNameInputSide() {
    return TextField(
        autocorrect: false,
        autofocus: true,
        controller: controller.nameInputController,
        onSubmitted: (value) {
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            hintText: 'My Wallet'
        )
    );
  }

  Widget getTypesSide(BuildContext context) {
    if (!displayExternalActions) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: LightButton(
                isInline: false,
                onTap: () {
                  controller.createWallet(context);
                },
                child: Text(
                    'Create Wallet'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).accentColor)
                )
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text('Create Native Seqwit wallet.')
          )
        ]
      );
    }

    return Column(
      children: [
        Container(
          child: Text('Type of the wallet', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
        ),
        Container(
          margin: EdgeInsets.only(top: 40),
          child: Text('RECOMMENDED', style: TextStyle(color: Theme.of(context).accentColor))
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: LightButton(
              isInline: false,
              onTap: () {
                controller.createWallet(context);
              },
              child: Text(
                  'Native Seqwit'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).accentColor)
              )
          )
        ),
        Container(
           margin: EdgeInsets.only(top: 50),
           child: Text('OTHER', style: TextStyle(color: Theme.of(context).accentColor))
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: LightButton(
            isInline: false,
            onTap: () {
              controller.createWallet(context);
            },
            child: Text(
              'Nested Seqwit'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).accentColor)
            )
          )
        ),
        Container(
          margin: EdgeInsets.only(top: 50),
          child: Text('Segwit uses bech32-encoded addresses (bc1), Nested Segwit makes it compatible with legacy software. Don\'t use legacy.')
        )
      ]
    );
  }
}
