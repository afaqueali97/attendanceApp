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

import '../../services/firebase_services/firestore_service.dart';

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
  bool _isCaptureInProgress = false;
  bool isTakePictureInProgress = false; // NEW: Track takePicture state

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
    _faceDetectionTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!_isDetecting.value &&
          isCameraInitialized.value &&
          !_isCaptureInProgress &&
          !isTakePictureInProgress) { // NEW: Check takePicture state
        _processCameraFrame();
      }
    });
  }

  Future<void> _processCameraFrame() async {
    if (_isDetecting.value || isTakePictureInProgress) return; // NEW: Check takePicture state
    _isDetecting.value = true;

    try {
      // Use tryTakePicture instead of takePicture to avoid conflicts
      final frame = await _safeTakePicture();
      if (frame == null) return;

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

  // NEW: Safe method to take pictures without conflicts
  Future<XFile?> _safeTakePicture() async {
    if (isTakePictureInProgress) return null;

    isTakePictureInProgress = true;
    try {
      return await cameraController.takePicture();
    } catch (e) {
      debugPrint("Safe takePicture error: $e");
      return null;
    } finally {
      isTakePictureInProgress = false;
    }
  }

  Future<void> captureFace() async {
    if (!faceDetected.value) {
      CommonCode().showToast(message: "No face detected");
      return;
    }

    if (_isCaptureInProgress || isTakePictureInProgress) {
      CommonCode().showToast(message: "Capture already in progress");
      return;
    }

    _isCaptureInProgress = true;
    isProcessing.value = true;

    try {
      // Stop face detection during capture
      _faceDetectionTimer?.cancel();

      // Use safe method to take picture
      final frame = await _safeTakePicture();
      if (frame == null) {
        throw Exception("Failed to capture image");
      }

      final bytes = await frame.readAsBytes();
      final processedImage = await _processCapturedImage(bytes);
      capturedFace.value = processedImage;

      // Delete the temporary file
      await File(frame.path).delete();
    } catch (e) {
      debugPrint('Capture face exception: ${e.toString()}');
      CommonCode().showToast(message: "Error capturing face: ${e.toString()}");
    } finally {
      isProcessing.value = false;
      _isCaptureInProgress = false;

      // Restart face detection with delay to ensure camera is ready
      Future.delayed(const Duration(milliseconds: 500), () {
        _startFaceDetection();
      });
    }
  }

  Future<Uint8List> _processCapturedImage(Uint8List imageBytes) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) return imageBytes;

      var processedImage = img.copyRotate(image, 270);
      processedImage = img.flipHorizontal(processedImage);
      return Uint8List.fromList(img.encodeJpg(processedImage, quality: 80));
    } catch (e) {
      debugPrint("Image processing error: $e");
      return imageBytes; // Return original if processing fails
    }
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

      // Check if user already exists
      if (box.containsKey(nameController.text)) {
        CommonCode().showToast(message: "User already exists");
        return;
      }

      await box.put(nameController.text, capturedFace.value);

      //adding
      await FirestoreService.instance.addUser(name: nameController.text,imageBytes:  capturedFace.value!,);

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