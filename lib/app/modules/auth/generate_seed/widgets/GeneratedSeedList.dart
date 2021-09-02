import 'package:flutter/material.dart';

class GeneratedSeedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var values = [
      'A', 'B', 'C', 'D'
    ];

    List<Widget> rows = [];
    var idx = 0;
    values.forEach((el) {
      rows.add(Container(
        child: Row(
          children: [
            Text((idx + 1).toString(), style: TextStyle(fontSize: 18)),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(el, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            )
          ]
        )
      ));
      idx++;
    });
    return Column(
      children: rows
    );
  }
}