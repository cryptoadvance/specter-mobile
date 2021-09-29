import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:specter_mobile/utils.dart';

class EnterSeedList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EnterSeedListState();
  }

}

class EnterSeedListState extends State<EnterSeedList> {
  int seedSize = 24;

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    for (var i = 0; i < seedSize / 2; i++) {
      rows.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(5),
            child: getSeedInput(i + 1, false)
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: getSeedInput((i + 12 + 1), (i + 12 + 1) == seedSize)
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

  Map<int, FocusNode> focusNodes = HashMap();
  Map<int, TextEditingController> controllers = HashMap();

  Widget getSeedInput(int idx, bool isLast) {
    if (!focusNodes.containsKey(idx)) {
      focusNodes[idx] = FocusNode();
    }
    if (!controllers.containsKey(idx)) {
      controllers[idx] = TextEditingController();
    }

    Widget inputWidget = TextField(
      autocorrect: false,
      autofocus: true,
      controller: controllers[idx],
      focusNode: focusNodes[idx],
      onSubmitted: (value) {
        var nextIdx = idx + 1;
        if (!focusNodes.containsKey(nextIdx)) {
          return;
        }
        FocusScope.of(context).requestFocus(focusNodes[nextIdx]);
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