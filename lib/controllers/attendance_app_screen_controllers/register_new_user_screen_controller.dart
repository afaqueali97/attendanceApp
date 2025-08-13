import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart' as img;
import 'package:rename_me/utils/common_code.dart';

class RegisterNewUserScreenController extends GetxController {
  late CameraController cameraController;
  late FaceDetector faceDetector;
  final RxBool isCameraInitialized = false.obs;
  final RxBool isProcessing = false.obs;
  final RxBool faceDetected = false.obs;
  final Rx<Uint8List?> capturedFace = Rx<Uint8List?>(null);
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Face detection variables
  final RxBool _isDetecting = false.obs;
  Timer? _faceDetectionTimer;
  bool _isCaptureInProgress = false; // Add this flag

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
    _initializeFaceDetector();
  }

  void _initializeFaceDetector() {
    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
      enableContours: false,
      enableClassification: false,
      enableTracking: true,
    );
    faceDetector = FaceDetector(options: options);
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
            (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await cameraController.initialize();
      isCameraInitialized.value = true;
      _startFaceDetection();
    } catch (e) {
      CommonCode().showToast(message: "Camera initialization failed: $e");
      debugPrint("Camera initialization error: $e");
    }
  }

  void _startFaceDetection() {
    _faceDetectionTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!_isDetecting.value && isCameraInitialized.value && !_isCaptureInProgress) {
        _processCameraFrame();
      }
    });
  }

  Future<void> _processCameraFrame() async {
    if (_isDetecting.value) return;
    _isDetecting.value = true;

    try {
      final frame = await cameraController.takePicture();
      final bytes = await frame.readAsBytes();
      final inputImage = InputImage.fromFilePath(frame.path);

      final faces = await faceDetector.processImage(inputImage);
      faceDetected.value = faces.isNotEmpty;

      // Delete the temporary file
      await File(frame.path).delete();
    } catch (e) {
      debugPrint("Face detection error: $e");
    } finally {
      _isDetecting.value = false;
    }
  }

  Future<void> captureFace() async {
    if (!faceDetected.value) {
      CommonCode().showToast(message: "No face detected");
      return;
    }

    if (_isCaptureInProgress) {
      CommonCode().showToast(message: "Capture already in progress");
      return;
    }

    _isCaptureInProgress = true;
    isProcessing.value = true;

    try {
      // Stop face detection during capture
      _faceDetectionTimer?.cancel();

      final frame = await cameraController.takePicture();
      final bytes = await frame.readAsBytes();

      // Process and optimize the image
      final processedImage = await _processCapturedImage(bytes);
      capturedFace.value = processedImage;

      // Delete the temporary file
      await File(frame.path).delete();
    } catch (e) {
      CommonCode().showToast(message: "Error capturing face: $e");
      debugPrint("Face capture error: $e");
    } finally {
      isProcessing.value = false;
      _isCaptureInProgress = false;

      // Restart face detection
      _startFaceDetection();
    }
  }

  Future<Uint8List> _processCapturedImage(Uint8List imageBytes) async {
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    var processedImage = img.copyRotate(image, 270);
    processedImage = img.flipHorizontal(processedImage);
    return Uint8List.fromList(img.encodeJpg(processedImage, quality: 80));
  }

  Future<void> saveUser() async {
    if (nameController.text.isEmpty) {
      CommonCode().showToast(message: "Please enter a name");
      return;
    }

    if (capturedFace.value == null) {
      CommonCode().showToast(message: "No face captured");
      return;
    }

    isProcessing.value = true;

    try {
      final box = Hive.box('face_db');
      await box.put(nameController.text, capturedFace.value);

      CommonCode().showToast(
        message: "${nameController.text} registered successfully",
      );
      resetRegistration();
    } catch (e) {
      CommonCode().showToast(message: "Registration failed: $e");
    } finally {
      isProcessing.value = false;
    }
  }

  void cancelRegistration() {
    resetRegistration();
  }

  void resetRegistration() {
    capturedFace.value = null;
    nameController.clear();
  }

  @override
  void onClose() {
    _faceDetectionTimer?.cancel();
    cameraController.dispose();
    faceDetector.close();
    nameController.dispose();
    super.onClose();
  }

  void onBackPressed() => Get.back();
}