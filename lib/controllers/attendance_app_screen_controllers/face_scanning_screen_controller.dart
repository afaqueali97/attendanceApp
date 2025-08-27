import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:hive/hive.dart';
import 'package:rename_me/utils/common_code.dart';
import 'package:image/image.dart' as img;

class FaceScanningScreenController extends GetxController {
  late CameraController cameraController;
  late FaceDetector faceDetector;
  RxBool isCameraInitialized = false.obs;
  RxBool isDetecting = false.obs;
  RxBool faceFound = false.obs;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Rx<Rect?> detectedFaceRect = Rx<Rect?>(null);
  Rx<Uint8List?> capturedFace = Rx<Uint8List?>(null);
  TextEditingController nameController = TextEditingController();

  Uint8List? currentFrameBytes;
  InputImage? currentInputImage;
  RxBool holdCurrentFaceImage = false.obs;

  RxBool markingAttendance = false.obs;
  RxString nameOfPersonWhoseAttendanceIsMarked = "".obs;
  final attendanceBox = Hive.box<String>('attendance_db');

  // final _faceMatchCache = <String, DateTime>{}; //Caching Face Matching Results:


  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
    _initializeFaceDetector();
  }

  void _initializeFaceDetector() {
    final options = FaceDetectorOptions(
        enableClassification: true, enableTracking: true);
    faceDetector = FaceDetector(options: options);
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
            (cam) => cam.lensDirection == CameraLensDirection.front);

    cameraController =
        CameraController(camera, ResolutionPreset.medium, enableAudio: false);
    await cameraController.initialize();
    cameraController.startImageStream(_processCameraImage);
    isCameraInitialized.value = true;
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (isDetecting.value || markingAttendance.value) return;
    isDetecting.value = true;

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
    Size(image.width.toDouble(), image.height.toDouble());
    final camera = cameraController.description;
    final imageRotation = InputImageRotationValue.fromRawValue(
        camera.sensorOrientation) ??
        InputImageRotation.rotation0deg;
    final inputImageFormat = InputImageFormatValue.fromRawValue(
        image.format.raw) ??
        InputImageFormat.nv21;

    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    final inputImage =
    InputImage.fromBytes(bytes: bytes, metadata: inputImageData);

    try {
      // Only process every 30th frame to reduce load (adjust as needed)
      if (DateTime.now().millisecondsSinceEpoch % 30 != 0) {
        return;
      }

      final List<Face> faces = await faceDetector.processImage(inputImage);
      faceFound.value = faces.isNotEmpty;
      if (faces.isNotEmpty && holdCurrentFaceImage.isFalse) {
        final face = faces.first;
        final faceSize = face.boundingBox.width * face.boundingBox.height;
        final minFaceSize = image.width * image.height * 0.1; // 10% of frame
        if (faceSize > minFaceSize) {
          holdCurrentFaceImage.value = true;
          currentInputImage = inputImage;
          detectedFaceRect.value = face.boundingBox;
          final jpegBytes = await _convertYUV420ToJpeg(image);
          if (jpegBytes != null) {
            capturedFace.value = jpegBytes;
            currentFrameBytes = jpegBytes;
            //todo uncomment this for marking attendance automatically
            await matchFaceWithStoredData(jpegBytes);
          }
        }
      }
    } catch (e) {
      CommonCode().showToast(message: "❌ Face detection failed: $e");
      print("❌ Face detection failed: $e");
    } finally {
      // making it false after the image has done working
      // holdCurrentFaceImage.value = false;
      isDetecting.value = false;
      // if(markingAttendance.value = false){
      //   isDetecting.value = false;
      // }
    }
  }

  Future<Uint8List?> _convertYUV420ToJpeg(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      img.Image imgImage = img.Image(width, height);

      final Plane yPlane = image.planes[0];
      final Plane uPlane = image.planes[1];
      final Plane vPlane = image.planes[2];

      final int uvRowStride = uPlane.bytesPerRow;
      final int uvPixelStride = uPlane.bytesPerPixel!;

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final int uvIndex =
              uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);
          final int index = y * width + x;

          final int yp = yPlane.bytes[index];
          final int up = uPlane.bytes[uvIndex];
          final int vp = vPlane.bytes[uvIndex];

          int r = (yp + (1.370705 * (vp - 128))).round();
          int g = (yp - (0.337633 * (up - 128)) - (0.698001 * (vp - 128)))
              .round();
          int b = (yp + (1.732446 * (up - 128))).round();

          r = r.clamp(0, 255);
          g = g.clamp(0, 255);
          b = b.clamp(0, 255);

          imgImage.setPixelRgba(x, y, r, g, b);
        }
      }

      // Fix the rotation by rotating 90 degrees clockwise
      imgImage = img.copyRotate(imgImage, 270);

      return Uint8List.fromList(img.encodeJpg(imgImage));
    } catch (e) {
      debugPrint("❌ YUV->JPEG conversion failed: $e");
      return null;
    }
  }

  Future<void> registerFace(String name) async {
    if (capturedFace.value == null) {
      CommonCode().showToast(message: "Error , No face to register");
      return;
    }

    final box = Hive.box('face_db');
    box.put(name, capturedFace.value);

    CommonCode().showToast(
        message: "✅ Registered , $name's face has been saved.");
  }

  Future<void> matchFaceWithStoredData(Uint8List currentImage) async {
    if (markingAttendance.isTrue) return;
    markingAttendance.value = true;

    debugPrint('======== Starting face matching process ========');

    try {
      final box = Hive.box('face_db');
      if (box.isEmpty) {
        // CommonCode().showToast(message: "No registered users found");
        return;
      }

      // Resize current image to reduce processing time
      final resizedImage = await _resizeImage(currentImage, maxWidth: 300);
      final currentImageBase64 = base64Encode(resizedImage); // this is using resized imaged to match face data

      // Convert current image to base64
      // final currentImageBase64 = base64Encode(currentImage); // this is using current image instead of resized(could be heavy on mobile)
      debugPrint('-------------------------------------Current image size: ${currentImage.length} bytes');

      final captured = regula.MatchFacesImage()
        ..bitmap = currentImageBase64
        ..imageType = regula.ImageType.PRINTED;

      bool matchFound = false;
      String matchedUserName = '';

      // Get all stored users
      final storedUsers = box.toMap();

      for (final entry in storedUsers.entries) {
        final userName = entry.key;
        final storedImageBytes = entry.value as Uint8List?;

        if (storedImageBytes == null || storedImageBytes.isEmpty) continue;

        debugPrint('-----------------------------------------Checking against user: $userName');
        debugPrint('-----------------------------------------Stored image size: ${storedImageBytes.length} bytes');

        final stored = regula.MatchFacesImage()
          ..bitmap = base64Encode(storedImageBytes)
          ..imageType = regula.ImageType.PRINTED;

        final request = regula.MatchFacesRequest()..images = [captured, stored];

        try {
          debugPrint('-----------------------------------------Sending face matching request...');
          final result = await regula.FaceSDK.matchFaces(jsonEncode(request));
          debugPrint('-----------------------------------------Received face matching response');

          final response = regula.MatchFacesResponse.fromJson(json.decode(result));

          if (response == null || response.results == null) {
            debugPrint('-----------------------------------------No results in response');
            continue;
          }

          debugPrint('Processing similarity threshold...');
          final split = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
            jsonEncode(response.results),
            0.70, // Lowered threshold for testing
          );

          final threshold = regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(split));

          if (threshold?.matchedFaces.isNotEmpty ?? false) {
            final similarity = threshold!.matchedFaces.first!.similarity! * 100;
            debugPrint('-----------------------------------------Similarity with $userName: $similarity%');

            if (similarity > 70.0) { // Reduced threshold for testing
              matchFound = true;
              matchedUserName = userName;
              // _faceMatchCache[matchedUserName] = DateTime.now(); //for caching matched faces to improve accuracy
              debugPrint('-----------------------------------------MATCH FOUND: $userName ($similarity%)');
              break;
            }
          }
        } catch (e) {
          debugPrint('-----------------------------------------Error matching with $userName: $e');
        }
      }

      if (matchFound) {
        await markAttendance(matchedUserName);
      } else {
        CommonCode().showToast(message: "No matching user found");
        debugPrint('-----------------------------------------No matching user found');
      }
    } catch (e) {
      debugPrint('-----------------------------------------Error in matchFaceWithStoredData: $e');
      CommonCode().showToast(message: "Face matching error");
    } finally {
      holdCurrentFaceImage.value = false;
      markingAttendance.value = false;
      isDetecting.value = false;
      debugPrint('-----------------------------------------======== Face matching process completed ========');
    }
  }

  Future<void> markAttendance(String name) async {
    try {
      debugPrint('Attempting to mark attendance for $name');

      final now = DateTime.now();
      final todayKey = "$name-${now.year}-${now.month}-${now.day}";

      // final attendanceBox = Hive.box<String>('attendance_db');

      if (attendanceBox.containsKey(todayKey)) {
        CommonCode().showToast(message: "${name.toUpperCase()}'s Attendance already marked today");
        Get.back();
        debugPrint('Attendance already marked for $name today');
        return;
      }

      // Store attendance
      await attendanceBox.put(todayKey, now.toIso8601String());
      debugPrint('Attendance successfully marked for $name');

      // Show success dialog
      final box = Hive.box('face_db');
      final storedImageBytes = box.get(name);

      if (storedImageBytes != null) {
        Get.dialog(
          AlertDialog(
            title: const Text("Attendance Marked!"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Welcome back, $name!"),
                const SizedBox(height: 20),
                Image.memory(
                  storedImageBytes,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          barrierDismissible: false,
        );

        Timer(const Duration(seconds: 3), () {
          if (Get.isDialogOpen!) Get.back();
        });
      }

      CommonCode().showToast(message: "Attendance marked for $name");
    } catch (e) {
      debugPrint('Error marking attendance: $e');
      CommonCode().showToast(message: "Error marking attendance");
    }finally{
      print("---------------------------------------inside finally");
      debugPrintStoredUsers();
      debugPrintAttendanceRecords();
    }
  }

  // Add this to your controller to help debug
  Future<void> debugPrintStoredUsers() async {
    final box = Hive.box('face_db');
    debugPrint('======= Stored Users =======');
    debugPrint('Total users: ${box.length}');

    for (final key in box.keys) {
      final value = box.get(key);
      debugPrint('User: $key, Image size: ${value?.length ?? 0} bytes');
    }
  }

  Future<void> debugPrintAttendanceRecords() async {
    // final box = Hive.box<String>('attendance_db');
    debugPrint('======= Attendance Records =======');
    debugPrint('================================Total records: ${attendanceBox.length}');

    for (final key in attendanceBox.keys) {
      final value = attendanceBox.get(key);
      debugPrint('Key: $key, Date: $value');
    }
  }


  // Add this helper method to your controller, added to reduce matching time
  Future<Uint8List> _resizeImage(Uint8List imageBytes, {int maxWidth = 300}) async {
    final originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) return imageBytes;

    final ratio = originalImage.width / maxWidth;
    final height = (originalImage.height / ratio).round();

    final resizedImage = img.copyResize(
      originalImage,
      width: maxWidth,
      height: height,
    );

    return Uint8List.fromList(img.encodeJpg(resizedImage));
  }

  @override
  void onClose() {
    cameraController.dispose();
    faceDetector.close();
    super.onClose();
  }

  void onBackPressed() => Get.back();
}
