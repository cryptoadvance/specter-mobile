import 'package:flutter/material.dart';

import '../../utils.dart';

class LightButton extends StatelessWidget {
  final Widget child;
  LightButton({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      child: Container(
        color: Utils.hexToColor('#D5E6FB'),
        child: TextButton(
          onPressed: () {
            // Respond to button press
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            minimumSize: Size(50, 30),
            alignment: Alignment.centerLeft
          ),
          child: child
        )
      )
    );
  }
}