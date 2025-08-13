import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_colors.dart';


/* Created by Afaque Ali on 21/12/2023 */

class BCameraPicker extends StatefulWidget {
  final List<CameraDescription> cameras;
  final bool isFrontCameraShow;
  final bool isFlashShow;
  const BCameraPicker({
    Key? key,
    required this.cameras,
    this.isFrontCameraShow = false,
    this.isFlashShow = false,
  }) : super(key: key);

  @override
  State<BCameraPicker> createState() => _BCameraPickerState();
}

class _BCameraPickerState extends State<BCameraPicker> {
  late CameraController cameraController;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    cameraController = CameraController(
      widget.cameras[0],
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.getMaxZoomLevel().then((value) {
          cameraController.setZoomLevel(value /0.5);
        });
        cameraController.setFlashMode(FlashMode.off);
        cameraController.setExposureMode(ExposureMode.auto);
        cameraController.setExposurePoint(const Offset(0.5, 0.5));
        cameraController.setFocusMode(FocusMode.auto);
        cameraController.buildPreview();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (cameraController.value.isInitialized) {
      var camera = cameraController.value;
      final deviceRatio = size.width / size.height;
      const aspectRatio = 7.2 / 16.38;
      var scale = camera.aspectRatio / deviceRatio;
      if (scale < 1) scale = 1 / scale;
      return Scaffold(
        body: Stack(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () {
                cameraController.setFocusMode(FocusMode.auto);
                cameraController.setFocusPoint(const Offset(0.5, 0.5));
                cameraController.buildPreview();
              },
              child: Transform.scale(
                scale: scale * aspectRatio / camera.aspectRatio * 1,
                child: CameraPreview(cameraController),
              ),
            ),
             Positioned(
                top: 30,
                left: 20,
               child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new, size: 30, color: kWhiteColor)),
             ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isFrontCameraShow)
                    CameraButton(
                        onPressed: () {},
                        icon: Icons.flip_camera_android_outlined),
                  const SizedBox(width: 10),
                  CameraButton(
                    onPressed: () {
                      cameraController.takePicture().then((value) {
                        Get.back(result: value);
                      });
                    },
                    icon: Icons.camera_alt_outlined,
                  ),
                  const SizedBox(width: 10),
                  if (widget.isFlashShow)
                    CameraButton(
                        onPressed: () {
                          if (cameraController.value.flashMode ==
                              FlashMode.off) {
                            cameraController.setFlashMode(FlashMode.torch);
                            setState(() {});
                          } else {
                            cameraController.setFlashMode(FlashMode.off);
                            setState(() {});
                          }
                        },
                        icon: cameraController.value.flashMode == FlashMode.off
                            ? Icons.flash_off
                            : Icons.flash_on)
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class CameraButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  const CameraButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: 75,
      child: GestureDetector(
        onTap: onPressed,
        child: Card(
          elevation: 5,
          shadowColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.camera_alt_outlined,
              size: 30, color: kPrimaryColor),
        ),
      ),
    );
  }
}
