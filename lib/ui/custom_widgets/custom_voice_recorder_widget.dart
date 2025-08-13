import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/custom_widget_controllers/custom_voice_recorder_controller.dart';
import '../../utils/app_colors.dart';
import 'custom_audio_player.dart';

/* Created By: Afaque Ali on 04-OCT-2024 */
class CustomVoiceRecorderWidget extends GetView<CustomVoiceRecorderController> {
  @override
  final CustomVoiceRecorderController controller;
  final bool readOnly;
  final bool onDownload;
  const CustomVoiceRecorderWidget(
      {super.key,
      required this.controller,
      this.readOnly = false,
      this.onDownload = false});

  @override
  Widget build(BuildContext context) {
    Get.put(controller);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Visibility(
          visible: controller.audioFileList.length<2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(controller.title,
                    style: const TextStyle(
                      color: kTextColor,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 0.07,
                      letterSpacing: 0.15,
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Column(
            children: [
              for (int i = 0; i < controller.audioFileList.length; i++)
                Obx(
                  () => controller.audioFileList[i].docPath.isEmpty
                      ? Visibility(
                          visible: controller.audioFileList.length<2,
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            width: Get.width,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: kGreyColor, width: 1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Obx(
                                  () => (!readOnly)
                                      ? Text(
                                          !controller.isRecording.value
                                              ? 'Tap to record a voice note'
                                              : 'Tap to stop recording',
                                          style: const TextStyle(
                                            color: Color(0xFF5A5A89),
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400,
                                            height: 0.07,
                                            letterSpacing: 0.15,
                                          ),
                                        )
                                      : Text(
                                          controller.isAudioLoading[i].value
                                              ? 'Downloading...'
                                              : 'Tap to download voice note',
                                          style: const TextStyle(
                                            color: Color(0xFF5A5A89),
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400,
                                            height: 0.07,
                                            letterSpacing: 0.15,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 5),
                                Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      if (!onDownload) {
                                        if (controller.audioFileList.length < 2) {
                                          controller
                                              .startRecord(controller.title);
                                        }
                                      } else {
                                        controller.downloadAudio(i);
                                      }
                                    },
                                    child: (!readOnly)
                                        ? Icon(
                                            !controller.isRecording.value
                                                ? Icons.keyboard_voice_outlined
                                                : Icons.stop,
                                            color: kPrimaryColor,
                                            size: 22,
                                          )
                                        : controller.isAudioLoading[i].value
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator())
                                            : const Icon(
                                                Icons.download,
                                                color: kPrimaryColor,
                                                size: 22,
                                              ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomAudioPlayer(
                                  audioFilePath:
                                      controller.audioFileList[i].docPath),
                            ),
                            const SizedBox(width: 5),
                            Obx(
                              () => Visibility(
                                visible: controller
                                        .audioFileList[i].docPath.isNotEmpty &&
                                    !readOnly,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.audioFileList.removeAt(i);
                                    controller.audioFileList.refresh();
                                    controller.isRecording(false);
                                  },
                                  child: const Icon(
                                    CupertinoIcons.delete,
                                    color: kRequiredRedColor,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                )
            ],
          ),
        ),
        Obx(() => Visibility(
            visible: controller.errorMessage.isNotEmpty,
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: kRequiredRedColor, fontSize: 12),
            ))),
        const SizedBox(height: 10),
      ],
    );
  }
}
