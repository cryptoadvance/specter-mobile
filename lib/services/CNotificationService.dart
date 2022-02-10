import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';

import '../utils.dart';

class CNotificationService {
  int currentIdx = 0;

  CNotificationService();

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

  OverlayEntry? overlayEntryMessage;
  Future<bool> addMessage(BuildContext context, String title, String msg, {String? actionTitle}) async {
    Completer<bool> completer = Completer();

    //
    if (overlayEntryMessage != null) {
      overlayEntryMessage!.remove();
      overlayEntryMessage = null;
    }
    overlayEntryMessage = OverlayEntry(builder: (context) {
      return Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: getMessageLabel(
            title: title,
            msg: msg,
            actionTitle: actionTitle,
            closeDialog: () {
              overlayEntryMessage!.remove();
              overlayEntryMessage = null;

              //
              completer.complete(true);
            }
          )
      );
    });
    Overlay.of(context)!.insert(overlayEntryMessage!);

    //
    return completer.future;
  }

  OverlayEntry? overlayEntryDialog;
  Completer<dynamic>? dialogCompleter;
  Future<dynamic> addDialog(BuildContext context, {required Widget child}) async {
    dialogCompleter = Completer();

    //
    if (overlayEntryDialog != null) {
      overlayEntryDialog!.remove();
      overlayEntryDialog = null;
    }
    overlayEntryDialog = OverlayEntry(builder: (context) {
      return Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: getDialogLabel(
            child: child,
            closeDialog: () {
              overlayEntryDialog!.remove();
              overlayEntryDialog = null;

              //
              dialogCompleter!.complete();
            }
          )
      );
    });
    Overlay.of(context)!.insert(overlayEntryDialog!);

    //
    return dialogCompleter!.future;
  }

  void closeDialog() {
    if (overlayEntryDialog != null) {
      overlayEntryDialog!.remove();
      overlayEntryDialog = null;

      //
      dialogCompleter!.complete();
    }
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

  Widget getMessageLabel({required String title, required String msg, String? actionTitle, required Function closeDialog}) {
    var actionButton;
    if (actionTitle != null) {
      actionButton = LightButton(
          isInline: true,
          onTap: () {
            closeDialog();
          },
          child: Container(
              width: double.infinity,
              child: Text(actionTitle, textAlign: TextAlign.center, style: TextStyle(color: Colors.white))
          )
      );
    }

    var msgDialog = Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      decoration: BoxDecoration(
        color: Utils.hexToColor('#233752'),
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(msg)
          ),
          Container(
            child: (actionButton != null)?(
              Container(
                  margin: EdgeInsets.only(top: 30),
                child: actionButton
              )
            ):null
          )
        ]
      )
    );

    const double logoSize = 150;

    var logoPanel = Container(
        width: double.infinity,
        height: logoSize,
        child: Image.asset('assets/stickers/ghost_alert-x512.png')
    );

    return Material(
      color: Colors.transparent,
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SafeArea(
              child: Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: logoSize / 2 + 15, bottom: 70),
                        child: msgDialog,
                      ),
                      Positioned(
                        child: logoPanel
                      )
                    ]
                  )
              )
          )
      )
    );
  }

  Widget getDialogLabel({required Widget child, required Function closeDialog}) {
    var msgDialog = Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            color: Utils.hexToColor('#233752'),
            borderRadius: BorderRadius.all(Radius.circular(30))
        ),
        child: child
    );

    return Material(
        color: Colors.transparent,
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      closeDialog();
                    },
                    child: Container(
                        color: Colors.transparent
                    )
                  )
                ),
                SafeArea(
                    child: Center(
                        child: msgDialog
                    )
                )
              ]
            )
        )
    );
  }
}
