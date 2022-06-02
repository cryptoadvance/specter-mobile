import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/hello_controller.dart';

class HelloView extends GetView<HelloController> {
  @override
  final HelloController controller = Get.put(HelloController());

  @override
  Widget build(BuildContext context) {
    preloadAssets(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: 128
            ),
            child: Image.asset('assets/stickers/ghost_char-x512.png')
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 110),
            child: Obx(() => AnimatedOpacity(
                opacity: controller.labelOpacity.value,
                duration: Duration(milliseconds: 1000),
                child: Text('Specter wallet', textAlign: TextAlign.center, style: TextStyle(fontSize: 32))
            ))
          )
        ]
      )
    );
  }

  void preloadAssets(BuildContext context) {
    Future.wait([
      precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/icons/chevron_right.svg'), null),
      precacheImage(AssetImage('assets/stickers/key-x512.png'), context)
    ]);
  }
}
