import 'package:flutter/material.dart';

import '../utils.dart';

class CNotificationService {
  int currentIdx = 0;

  CNotificationService() {
  }

  void addNotify(BuildContext context, String title) {
    int idx = currentIdx;
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        bottom: idx * 55,
        left: 0,
        right: 0,
        child: getNotifyLabel(
          title: title // + ' #' + idx.toString()
        )
      );
    });
    currentIdx++;
    Overlay.of(context)!.insert(overlayEntry);

    Future.delayed(Duration(milliseconds: 1500), () {
      currentIdx--;
      overlayEntry.remove();
    });
  }

  Widget getNotifyLabel({required String title}) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
          top: false,
          child: Container(
              padding: EdgeInsets.all(15),
              child: Container(
                  decoration: BoxDecoration(
                    color: Utils.hexToColor('#233752'),
                    borderRadius: BorderRadius.all(Radius.circular(16))
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(title)
              )
          )
      )
    );
  }
}
