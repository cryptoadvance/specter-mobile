import 'package:flutter/material.dart';

class GeneratedSeedSimpleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var values = [
      'A', 'B', 'C', 'D',  'A', 'B', 'C', 'D'
    ];

    List<Widget> rows = [];
    var idx = 0;
    values.forEach((el) {
      rows.add(Container(
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text((idx + 1).toString(), style: TextStyle(fontSize: 16)),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(el, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                )
              ]
          )
      ));
      idx++;
    });
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rows
    );
  }
}