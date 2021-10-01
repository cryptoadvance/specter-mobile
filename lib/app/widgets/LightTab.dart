import 'package:flutter/material.dart';

import '../../utils.dart';

enum LightTabView {
  TABS,
  TOGGLE
}

class LightTabNode {
  String title;
  String key;

  LightTabNode(this.title, {required this.key});
}

class LightTab extends StatelessWidget {
  final LightTabView view;
  final List<LightTabNode> tabs;
  final String tabKey;
  final Function(String key) onSelect;

  LightTab({
    this.view = LightTabView.TABS,
    required this.tabs,
    required this.tabKey,
    required this.onSelect
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    tabs.forEach((LightTabNode item) {
      if (this.view == LightTabView.TABS) {
        rows.add(LightTabItemTabView(
          item: item,
          isActive: (item.key == tabKey),
          onSelect: onSelect
        ));
      } else {
        rows.add(Expanded(
          child: LightTabItemToggleView(
            item: item,
            isActive: (item.key == tabKey),
            isFirst: rows.isEmpty,
            isLast: rows.length == tabs.length - 1,
            onSelect: onSelect
          )
        ));
      }
    });

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        (view == LightTabView.TOGGLE)?10:0
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular((view == LightTabView.TOGGLE)?25:0)),
        color: (view == LightTabView.TOGGLE)?Utils.hexToColor('#0A121B'):Colors.transparent
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows
      )
    );
  }
}

class LightTabItemTabView extends StatelessWidget {
  final LightTabNode item;
  final bool isActive;
  final Function(String key) onSelect;

  LightTabItemTabView({
    required this.item,
    required this.isActive,
    required this.onSelect
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onSelect(item.key);
        },
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsets.only(right: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                bottom: isActive?BorderSide(width: 3.0, color: Utils.hexToColor('#4A90E2')):BorderSide.none
              )
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
            child: Text(item.title, style: TextStyle(color: isActive?Utils.hexToColor('#4A90E2'):Colors.white))
          ),
        )
      ),
    );
  }
}

class LightTabItemToggleView extends StatelessWidget {
  final LightTabNode item;
  final bool isActive, isFirst, isLast;
  final Function(String key) onSelect;

  LightTabItemToggleView({
    required this.item,
    required this.isActive,
    required this.isFirst,
    required this.isLast,
    required this.onSelect
  });

  @override
  Widget build(BuildContext context) {
    Radius radius = Radius.circular(5);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onSelect(item.key);
        },
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            child: Container(
              decoration: BoxDecoration(
                color: isActive?Utils.hexToColor('#202A40'):Colors.transparent
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Text(item.title, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).accentColor))
            )
          ),
        )
      ),
    );
  }
}