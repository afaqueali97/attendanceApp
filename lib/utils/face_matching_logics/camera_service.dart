// import 'package:camera/camera.dart';
//
// class CameraService {
//   late CameraController controller;
//
//   // Set up and start the camera stream
//   /// Initializes the camera and starts image stream for face detection.
//   Future<void> initializeCamera() async {
//     final cameras = await availableCameras();
//     final camera = cameras.firstWhere((cam) => cam.lensDirection == CameraLensDirection.back);
//
//     cameraController = CameraController(camera, ResolutionPreset.medium, enableAudio: false);
//     await cameraController.initialize();
//     cameraController.startImageStream(_processCameraImage);
//     isCameraInitialized.value = true;
//   }
//
//   Stream<CameraImage> getImageStream() {
//     return controller.startImageStream((image) {});
//   }
//
//   void dispose() {
//     controller.dispose();
//   }
// }