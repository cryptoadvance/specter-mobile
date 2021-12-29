import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/200_wallets/keys/widgets/AccountItem.dart';
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
        SliverAppBar(
          pinned: false,
          expandedHeight: 150.0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsetsDirectional.only(start: 20, bottom: 20),
            title: getTopStatePanel()
          )
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(top: (index == 0)?15:0, left: 15, right: 15, bottom: 15),
              child: AccountItem()
            );
          }, childCount: 2
        ))
      ]
    );
  }

  Widget getTopStatePanel() {
    return Container(
      width: double.infinity,
      height: 95,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 20,
            child: Text('Offline', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 75
                  ),
                  child: Image.asset('assets/stickers/ghost_normal_3d-x512.png')
                )
              ]
            )
          ),
          Positioned(
            left: 40,
            bottom: 0,
            child: Container(
              constraints: BoxConstraints(
                 maxWidth: 30
              ),
              child: Image.asset('assets/stickers/bitcoin-1.png')
            )
          ),
          Positioned(
            right: 60,
            bottom: 30,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 30
              ),
              child: Image.asset('assets/stickers/bitcoin-2.png')
            )
          ),
          Positioned(
            right: 30,
            bottom: 0,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 30
              ),
              child: Image.asset('assets/stickers/bitcoin-3.png')
            )
          )
        ]
      )
    );
  }

  Widget getActionsPanel() {
    return LightButton(
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
              child: Text('ADD WALLET', style: TextStyle(color: Colors.white))
            )
          ]
        )
    );
  }
}
