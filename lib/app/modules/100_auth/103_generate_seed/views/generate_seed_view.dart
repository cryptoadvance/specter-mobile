import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';
import 'package:specter_mobile/services/cryptoService/CGenerateSeedService.dart';

import '../controllers/generate_seed_controller.dart';
import '../widgets/GeneratedSeed24WordList.dart';

import '../../../../../utils.dart';

class GenerateSeedView extends GetView<GenerateSeedController> {
  @override
  final GenerateSeedController controller = Get.find<GenerateSeedController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() => Container(
                        child: Text(controller.needTakePhoto.value?(
                            'Use a camera photo'
                        ):'generate_seed_labels_top_title'.tr, style: TextStyle(fontSize: 24)),
                      )),
                      Expanded(
                        child: Container(
                          child: Obx(() => getGenerationArea(context))
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: getControlComplexityPanel(context, controller)
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 30),
                          child: getControlEntropyGenerationPanel(context, controller)
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 40),
                          child: Obx(() => getBottomButtonsPanel(context))
                      )
                    ]
                )
            )
        )
    );
  }

  Widget getGenerationArea(BuildContext context) {
    if (controller.needTakePhoto.value) {
      return Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Text('Take a picture with the phone camera that will be used as a data source to generate the recovery phrase'.tr, style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Utils.hexToColor('#F7BF60')
              )),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(top: 40, bottom: 40),
                  child: getNeedPhotoArea(context)
              )
            )
          ]
      );
    }

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 40),
          child: Text('generate_seed_labels_recovery_warning'.tr, style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Utils.hexToColor('#F7BF60')
          )),
        ),
        Container(
            constraints: BoxConstraints(
                maxHeight: 300
            ),
            margin: EdgeInsets.only(top: 40),
            child: SingleChildScrollView(
                key: UniqueKey(),
                scrollDirection: Axis.vertical,
                child: Obx(() => GeneratedSeed24WordList(
                    mnemonicWords: controller.lastGenerateSeedEvent!.value.mnemonicKey.split(' ')
                ))
            )
        )
      ]
    );
  }

  Widget getNeedPhotoArea(BuildContext context) {
    if (controller.capturingVideo.value) {
      CameraController? cameraController = controller.getCameraController();
      return Container(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    child: (cameraController != null)?Container(
                      color: Colors.green,
                      child: CameraPreview(cameraController)
                    ):null
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(controller.lastGenerateEntropyExternalEvent.value.getHexView()),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: LightButton(
                    style: LightButtonStyle.PRIMARY,
                    isDisabled: false,
                    onTap: () {
                      controller.stopTakePhotoAction(context);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                  'Stop'.tr,
                                  style: TextStyle(color: Theme.of(context).accentColor)
                              )
                          )
                        ]
                    )
                ),
              )
            ]
          )
        )
      );
    }

    return Container(
      constraints: BoxConstraints(
        minHeight: 100
      ),
      child: Center(
        child: LightButton(
            style: LightButtonStyle.PRIMARY,
            isDisabled: false,
            onTap: () {
              controller.takePhotoAction(context);
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/take_photo.svg'),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                          'Take a picture'.tr,
                          style: TextStyle(color: Theme.of(context).accentColor)
                      )
                  )
                ]
            )
        ),
      ),
    );
  }

  Widget getControlComplexityPanel(BuildContext context, GenerateSeedController controller) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Container(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text('generate_seed_labels_complexity_suggest'.tr, style: TextStyle(fontSize: 16)),
                          Text('generate_seed_labels_complexity_description'.tr, style: TextStyle(color: Colors.grey[300]))
                      ]
                  )
              )
          ),
          Expanded(
              flex: 0,
              child: Container(
                  child: Obx(() => Switch(
                    value: (controller.seed_complexity.value == SEED_COMPLEXITY.WORDS_24),
                    onChanged: (bool val) {
                        controller.setComplexityState(val?SEED_COMPLEXITY.WORDS_24:SEED_COMPLEXITY.SIMPLE);
                    },
                    activeTrackColor: Colors.blueGrey,
                    activeColor: Colors.white
                  )
                )
              )
          )
        ]
    );
  }

  Widget getControlEntropyGenerationPanel(BuildContext context, GenerateSeedController controller) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Container(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('generate_seed_labels_entropy_suggest'.tr, style: TextStyle(fontSize: 16)),
                        Text('generate_seed_labels_entropy_description'.tr, style: TextStyle(color: Colors.grey[300]))
                      ]
                  )
              )
          ),
          Expanded(
              flex: 0,
              child: Container(
                  child: Obx(() => Switch(
                      value: (controller.entropy_source.value == ENTROPY_SOURCE.CAMERA),
                      onChanged: (bool val) {
                        controller.setEntropySource(context, val?ENTROPY_SOURCE.CAMERA:ENTROPY_SOURCE.NONE);
                      },
                      activeTrackColor: Colors.blueGrey,
                      activeColor: Colors.white
                  )
                )
              )
          )
        ]
    );
  }

  Widget getBottomButtonsPanel(BuildContext context) {
    bool isCompleted =  (controller.lastGenerateSeedEvent!.value.completePercent == 100) && !controller.needTakePhoto.value;

    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              child: LightButton(
                  style: LightButtonStyle.SECONDARY,
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                      children: [
                        Icon(CupertinoIcons.back),
                        Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text('generate_seed_buttons_prev_page'.tr)
                        )
                      ]
                  )
              )
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: LightButton(
                style: LightButtonStyle.PRIMARY,
                isDisabled: !isCompleted,
                onTap: () {
                  controller.doneAction(context);
                },
                child: Row(
                    children: [
                      Icon(CupertinoIcons.check_mark, color: Theme.of(context).accentColor),
                      Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            'generate_seed_buttons_next_page'.tr,
                            style: TextStyle(color: Theme.of(context).accentColor)
                          )
                      )
                    ]
                )
            )
          )
        ]
    );
  }
}
