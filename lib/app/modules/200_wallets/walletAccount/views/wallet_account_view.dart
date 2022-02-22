import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletAccount/widgets/AccountsList.dart';
import 'package:specter_mobile/app/widgets/BottomMenu.dart';
import 'package:specter_mobile/app/widgets/BottomSlideMenu.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';
import 'package:specter_mobile/app/widgets/TopSide.dart';
import 'package:specter_mobile/app/widgets/slidingUpPanel/SlidingUpPanelController.dart';
import 'package:specter_mobile/app/widgets/slidingUpPanel/SlidingUpPanelView.dart';

import '../controllers/wallet_account_controller.dart';

class WalletAccountView extends GetView<WalletAccountController> {
  final SlidingUpPanelController _slidingUpPanelController = Get.find<SlidingUpPanelController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanelView(
            controller: _slidingUpPanelController,
            body: getBody()
        )
    );
  }

  Widget getSlideMenu() {
    return BottomSlideMenu(
        menuItems: [
          BottomSlideMenuItem(
              icon: './assets/icons/menu_pencil.svg',
              title: 'Rename'
          ),
          BottomSlideMenuItem(
              icon: './assets/icons/menu_qr_code.svg',
              title: 'Show QR code'
          ),
          BottomSlideMenuItem(
              icon: './assets/icons/menu_public_key.svg',
              title: 'Public key'
          ),
          BottomSlideMenuItem(
              icon: './assets/icons/menu_json.svg',
              title: 'Export to JSON'
          ),
          BottomSlideMenuItem(
              icon: './assets/icons/menu_pdf.svg',
              title: 'Export to PDF'
          ),
          BottomSlideMenuItem(
              icon: './assets/icons/menu_delete.svg',
              title: 'Delete wallet'
          )
        ]
    );
  }

  Widget getBody() {
    return SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopSide(
                  title: controller.walletItem!.name,
                  titleType: TOP_SIDE_TITLE_TYPE.WALLET,
                  menuType: TOP_SIDE_MENU_TYPE.OPTIONS,
                  openMenu: () {
                    _slidingUpPanelController.open(getSlideMenu());
                  }
              ),
              Expanded(
                  child: getContent()
              )
            ]
        )
    );
  }

  Widget getContent() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: getTopPanel()
          ),
          SafeArea(
              top: false,
              child: BottomMenu(slidingUpPanelController: _slidingUpPanelController)
          )
        ]
    );
  }

  Widget getTopPanel() {
    return Stack(
        children: [
          getScrollArea(),
          Positioned(
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                bottom: false,
                child: Container(
                    padding: EdgeInsets.all(20),
                    child: getActionsPanel()
                ),
              )
          )
        ]
    );
  }

  Widget getScrollArea() {
    return CustomScrollView(
        slivers: <Widget>[
          AccountsList(
            walletItem: controller.walletItem!
          )
        ]
    );
  }

  Widget getActionsPanel() {
    return Container();
    /*return LightButton(
        isInline: true,
        style: LightButtonStyle.PRIMARY,
        onTap: () {
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.plus, color: Colors.white),
              Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text('ADD ACCOUNT', style: TextStyle(color: Colors.white))
              )
            ]
        )
    );*/
  }
}
