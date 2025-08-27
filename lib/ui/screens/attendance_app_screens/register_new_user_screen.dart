import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rename_me/controllers/attendance_app_screen_controllers/register_new_user_screen_controller.dart';
import 'package:rename_me/ui/custom_widgets/custom_scaffold.dart';
import 'package:camera/camera.dart';
import 'package:rename_me/ui/custom_widgets/general_button.dart';
import 'package:rename_me/utils/app_colors.dart';

class RegisterNewUserScreen extends GetView<RegisterNewUserScreenController> {
  const RegisterNewUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      key: const Key("registerUserWidget"),
      className: runtimeType.toString(),
      screenName: 'Register User',
      onWillPop: controller.onBackPressed,
      onBackButtonPressed: controller.onBackPressed,
      scaffoldKey: controller.scaffoldKey,
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return SizedBox(
      width: Get.width,
      height: Get.height-150,
      child: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // Camera Preview
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  // padding: const EdgeInsets.only(top: 40),
                  width: Get.width,
                  height: Get.height-300,
                  child: CameraPreview(controller.cameraController),
                ),
              ),
            ),

            if (controller.faceDetected.value)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: kBlackColor,
                      borderRadius: BorderRadius.circular(50),
                      // borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50))
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    "✅ Face Detected",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kWhiteColor, fontSize: 16),
                  ),
                ),
              ),

            // Capture Button
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    if (controller.capturedFace.value != null)
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: kWhiteColor, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.memory(
                          controller.capturedFace.value!,
                          fit: BoxFit.cover,
                        ),
                      ),

                    // Capture Button
                    // In your captureFace() method, add visual feedback:
                    Obx(() => ElevatedButton(
                      onPressed: controller.isProcessing.value ||
                          controller.isTakePictureInProgress // Add this condition
                          ? null
                          : controller.captureFace,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: controller.isTakePictureInProgress // Visual feedback
                            ? kGreyColor
                            : kBlackColor,
                      ),
                      child: controller.isProcessing.value
                          ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(kWhiteColor),
                      )
                          : const Icon(Icons.camera_alt, size: 36,color: kWhiteColor,),
                    ),),
                  ],
                ),
              ),
            ),

            // Registration Form
            if (controller.capturedFace.value != null)
              Container(
                height: Get.height-200,
                width: Get.width,
                color: kPrimaryColor,
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Register User",
                      style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kWhiteColor,
                        hintText: "Enter user's name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GeneralButton(
                          onPressed: controller.cancelRegistration,
                          text: "Cancel",
                          color: kRequiredRedColor,
                          height: 50,
                          width: 100,
                        ),
                        const SizedBox(width: 20),
                        GeneralButton(
                          onPressed: controller.saveUser,
                          text: "Save",
                          color: kBlueColor,
                          height: 50,
                          width: 100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }
}