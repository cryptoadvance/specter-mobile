import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/wallets/keys/widgets/AccountItem.dart';
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
        Expanded(child: getScrollArea()),
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

  Widget getScrollArea() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 100.0,
          backgroundColor: Colors.grey[900]!.withOpacity(0.85),
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
      child: Text('Offline', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))
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
