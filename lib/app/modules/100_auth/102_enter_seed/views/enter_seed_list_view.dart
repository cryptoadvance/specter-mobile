import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/100_auth/102_enter_seed/controllers/enter_seed_list_controller.dart';
import 'package:specter_mobile/utils.dart';

class EnterSeedListView extends GetView<EnterSeedListController> {
  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    for (var i = 0; i < controller.seedSize / 2; i++) {
      rows.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(5),
            child: getSeedInput(context, i + 1, false)
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: getSeedInput(context, (i + 12 + 1), (i + 12 + 1) == controller.seedSize)
          )
        ]
      ));
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: rows
        ),
      ),
    );
  }

  Widget getSeedInput(BuildContext context, int idx, bool isLast) {
    if (!controller.focusNodes.containsKey(idx)) {
      controller.focusNodes[idx] = FocusNode();
    }
    if (!controller.controllers.containsKey(idx)) {
      controller.controllers[idx] = TextEditingController();
    }

    Widget inputWidget = TextField(
      autocorrect: false,
      autofocus: true,
      controller: controller.controllers[idx],
      focusNode: controller.focusNodes[idx],
      onSubmitted: (value) {
        var nextIdx = idx + 1;
        if (!controller.focusNodes.containsKey(nextIdx)) {
          return;
        }
        FocusScope.of(context).requestFocus(controller.focusNodes[nextIdx]);
      },
      textInputAction: isLast?TextInputAction.done:TextInputAction.next,
      decoration: InputDecoration(
          border: InputBorder.none
      )
    );

    return Container(
      constraints: BoxConstraints(
        minWidth: 120
      ),
      decoration: BoxDecoration(
        color: Utils.hexToColor('#202A40'),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 5,
            child: Text(idx.toString())
          ),
          Container(
            width: 100,
            height: 50,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: inputWidget
          )
        ]
      )
    );
  }
}