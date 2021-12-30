import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils.dart';

class BottomSlideMenuItem {
  final String icon;
  final String title;

  BottomSlideMenuItem({
    required this.icon,
    required this.title
  });
}

class BottomSlideMenu extends StatelessWidget {
  final List<BottomSlideMenuItem> menuItems;

  BottomSlideMenu({required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Utils.hexToColor('#233752'),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
            )
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: getContent()
    );
  }

  Widget getContent() {
    List<Widget> rows = [];

    rows.add(Container(
      decoration: BoxDecoration(
        color: Utils.hexToColor('#C0CAD7'),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      width: 35,
      height: 4
    ));

    rows.add(Container(
      margin: EdgeInsets.only(top: 15, bottom: 10),
      child: Text('Options', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))
    ));

    menuItems.forEach((menuItem) {
      rows.add(Container(
          margin: EdgeInsets.only(top: 15),
          child: getMenuItem(menuItem)
      ));
    });

    return Column(
      children: rows
    );
  }

  Widget getMenuItem(BottomSlideMenuItem menuItem) {
    return InkWell(
      onTap: () {
        print('open menu');
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Container(
              width: 30,
              child: Center(
                child: SvgPicture.asset(menuItem.icon)
              )
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(menuItem.title)
            )
          ]
        )
      )
    );
  }
}