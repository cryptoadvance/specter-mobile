import 'package:flutter/material.dart';

import '../../utils.dart';

class BottomSlideMenu extends StatelessWidget {
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
      height: 4,
    ));

    rows.add(Container(
      margin: EdgeInsets.only(top: 15),
      child: Text('Options', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))
    ));

    return Column(
      children: rows
    );
  }
}