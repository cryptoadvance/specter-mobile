import 'package:flutter/material.dart';

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
      padding: EdgeInsets.only(
        bottom: (view == LightTabView.TABS)?15:0
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: (view == LightTabView.TABS)?(
            BorderSide(width: 1.0, color: Colors.white.withOpacity(0.5))
          ):(
            BorderSide.none
          )
        )
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
    return InkWell(
      onTap: () {
        onSelect(item.key);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          decoration: BoxDecoration(
            color: isActive?Colors.white.withOpacity(0.95):Colors.transparent
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(item.title, style: TextStyle(color: isActive?Colors.grey[700]:Colors.white))
        )
      )
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

    return InkWell(
      onTap: () {
        onSelect(item.key);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: isFirst?radius:Radius.zero,
          bottomLeft: isFirst?radius:Radius.zero,
          topRight: isLast?radius:Radius.zero,
          bottomRight: isLast?radius:Radius.zero
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isActive?Colors.white.withOpacity(0.95):Colors.white.withOpacity(0.25)
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(item.title, style: TextStyle(color: isActive?Colors.grey[700]:Colors.white))
        )
      )
    );
  }
}