import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/keyboard/KeyboardController.dart';
import 'package:specter_mobile/utils.dart';

import '../controllers/enter_recovery_phrase_list_controller.dart';

class EnterRecoveryPhraseListView extends GetView<EnterRecoveryPhraseListController> {
  final KeyboardController keyboardController;
  EnterRecoveryPhraseListView({required this.keyboardController});

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

    //
    keyboardController.setSubmitProc(() {
      controller.submitProc(context);
    });

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
      FocusNode focusNode = FocusNode();
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          print('unfocus');
          controller.currentFocusIdx = null;
          keyboardController.setCurrentFocus(null);
          return;
        }
        print('Has focus: ' + idx.toString());

        controller.currentFocusIdx = idx;
        keyboardController.setCurrentFocus(controller.controllers[controller.currentFocusIdx]);
      });
      controller.focusNodes[idx] = focusNode;
    }
    if (!controller.controllers.containsKey(idx)) {
      controller.controllers[idx] = TextEditingController();
    }


    Widget inputWidget = TextField(
      autocorrect: false,
      autofocus: true,
      keyboardType: TextInputType.none,
      showCursor: true,
      readOnly: true,
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
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
            child:  inputWidget
          )
        ]
      )
    );
  }
}