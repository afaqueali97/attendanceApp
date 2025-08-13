import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/attendance_app_screen_controllers/face_scanning_screen_controller.dart';
import '../../../utils/common_code.dart';
import '../../custom_widgets/custom_scaffold.dart';
import 'package:camera/camera.dart';

class FaceScanningScreen extends GetView<FaceScanningScreenController> {
  const FaceScanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      key: const Key("scanResultWidget"),
      className: runtimeType.toString(),
      screenName: 'Scan Face',
      onWillPop: controller.onBackPressed,
      onBackButtonPressed: controller.onBackPressed,
      scaffoldKey: controller.scaffoldKey,
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Center(
        child: Obx(
              () {
            if (!controller.isCameraInitialized.value) {
              return const CircularProgressIndicator();
            }
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                CameraPreview(controller.cameraController),
                controller.nameOfPersonWhoseAttendanceIsMarked.isNotEmpty?
                Positioned(
                  bottom: 150,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(() => Text("✅ Marked Attendance of ${controller.nameOfPersonWhoseAttendanceIsMarked}",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    )),
                  ),
                )
                    :SizedBox()
                ,
                Positioned(
                  bottom: 90,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(() => Text(
                      controller.faceFound.value
                          ? "✅ Face Detected"
                          : "❌ No Face",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    )),
                  ),
                ),
/*
                Positioned(
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (controller.detectedFaceRect.value != null &&
                                controller.currentInputImage != null &&
                                controller.currentFrameBytes != null) {
                              Get.defaultDialog(
                                title: "Enter Name",
                                content: TextField(
                                  controller: controller.nameController,
                                  decoration: InputDecoration(hintText: "e.g., Afaque Ali"),
                                ),
                                confirm: ElevatedButton(
                                  child: Text("Save"),
                                  onPressed: () {
                                    controller.holdCurrentFaceImage.value = true;
                                    print('-------------------save button pressed');
                                    Get.back();
                                    controller.registerFace(
                                      controller.nameController.text,
                                      // File.fromRawPath(controller.currentFrameBytes!),
                                      // controller.detectedFaceRect.value!,
                                    );
                                  },
                                ),
                              );
                            } else {
                              CommonCode().showToast(message: "⚠️ No Face , Make sure your face is clearly visible in camera.");
                            }
                          },
                          child: Text("Register Face"),
                        ),*/
/*
                        SizedBox(width: 10,),
                        ElevatedButton(
                          onPressed: () async {
                            // XFile file = await controller.cameraController.takePicture();
                            // Uint8List imageBytes = await file.readAsBytes();

                            if (controller.detectedFaceRect.value != null &&
                                controller.currentInputImage != null &&
                                controller.currentFrameBytes != null) {
                              if(controller.markingAttendance.isTrue) {
                                CommonCode().showToast(message: "⚠️ Making of attendance already in progress.");
                                return;
                              }else{
                                await controller.matchFaceWithStoredData(controller.currentFrameBytes!);
                              }
                              // await controller.matchFaceWithStoredData(imageBytes);
                            } else {
                              CommonCode().showToast(message: "⚠️ No Face , Make sure your face is clearly visible in camera.");
                            }
                          },
                          child: Text("Mark Attendance"),
                        ),*//*

                      ],
                    ),
                  ),
                ),
*/
              ],
            );
          },
        ),
      ),
    );
  }
}
