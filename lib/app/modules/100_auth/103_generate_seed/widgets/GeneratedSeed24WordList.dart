import 'package:flutter/material.dart';

class GeneratedSeed24WordList extends StatelessWidget {
  final List<String> mnemonicWords;
  GeneratedSeed24WordList({required this.mnemonicWords});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return getContent(constraints.maxWidth);
    });
  }

  Widget getContent(double maxWidth) {
    int inColumnLength = 12;
    int columnsCount = (mnemonicWords.length / inColumnLength).ceil();

    var idx = 0;
    List<Widget> columns = [];
    for (int columnIdx = 0; columnIdx < columnsCount; columnIdx++) {
        List<Widget> rows = [];
        for (var i = 0; i < inColumnLength; i++) {
            if (idx >= mnemonicWords.length) {
              break;
            }
            var el = mnemonicWords[idx];
            rows.add(Container(
                constraints: BoxConstraints(
                    minWidth: 150
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          minWidth: 28
                        ),
                        child: Text((idx + 1).toString(), textAlign: TextAlign.right, style: TextStyle(fontSize: 18))
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(el, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                      )
                    ]
                )
            ));
            idx++;
        }
        columns.add(Container(
            margin: EdgeInsets.only(left: (columns.isEmpty)?0:20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rows
            )
        ));
    }
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: columns
    );
  }
}