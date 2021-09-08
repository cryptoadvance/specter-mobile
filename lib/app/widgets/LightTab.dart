import 'package:flutter/material.dart';

class LightTabNode {
  String title;
  String key;

  LightTabNode(this.title, {required this.key});
}

class LightTab extends StatelessWidget {
  final List<LightTabNode> tabs;
  final String tabKey;
  final Function(String key) onSelect;

  LightTab({required this.tabs, required this.tabKey, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    tabs.forEach((LightTabNode item) {
      rows.add(LightTabItem(
          item: item,
          isActive: (item.key == tabKey),
          onSelect: onSelect
      ));
    });

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.white),
        )
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows
      )
    );
  }
}

class LightTabItem extends StatelessWidget {
  final LightTabNode item;
  final bool isActive;
  final Function(String key) onSelect;

  LightTabItem({required this.item, required this.isActive, required this.onSelect});

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
        ),
      ),
    );
  }
}