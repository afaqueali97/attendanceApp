// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
// import 'package:image/image.dart' as img;
//
// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:google_mlkit_commons/google_mlkit_commons.dart';
//
// class ImageConverter {
//   Future<Uint8List?> convertYUV420ToJpeg(CameraImage image) async {
//     try {
//       final int width = image.width;
//       final int height = image.height;
//       final img.Image imgImage = img.Image(width, height);
//
//       final Plane yPlane = image.planes[0];
//       final Plane uPlane = image.planes[1];
//       final Plane vPlane = image.planes[2];
//
//       final int uvRowStride = uPlane.bytesPerRow;
//       final int uvPixelStride = uPlane.bytesPerPixel!;
//
//       for (int y = 0; y < height; y++) {
//         for (int x = 0; x < width; x++) {
//           final int uvIndex = uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);
//           final int index = y * width + x;
//
//           final int yp = yPlane.bytes[index];
//           final int up = uPlane.bytes[uvIndex];
//           final int vp = vPlane.bytes[uvIndex];
//
//           int r = (yp + (1.370705 * (vp - 128))).round();
//           int g = (yp - (0.337633 * (up - 128)) - (0.698001 * (vp - 128))).round();
//           int b = (yp + (1.732446 * (up - 128))).round();
//
//           r = r.clamp(0, 255);
//           g = g.clamp(0, 255);
//           b = b.clamp(0, 255);
//
//           imgImage.setPixelRgba(x, y, r, g, b);
//         }
//       }
//
//       return Uint8List.fromList(img.encodeJpg(imgImage));
//     } catch (e) {
//       debugPrint("❌ YUV->JPEG conversion failed: $e");
//       return null;
//     }
//   }
//
//   InputImage buildInputImage(CameraImage image, CameraDescription description) {
//     // construct InputImage from raw CameraImage
//     final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
//     // final camera = cameraController.description;
//     final imageRotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation) ?? InputImageRotation.rotation0deg;
//     final inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;
//
//     final inputImageData = InputImageMetadata(
//       size: imageSize,
//       rotation: imageRotation,
//       format: inputImageFormat,
//       bytesPerRow: image.planes[0].bytesPerRow,
//     );
//
//     final inputImage = InputImage.fromBytes(bytes: bytes, metadata: inputImageData);
//
//     return inputImage;
//   }
// }
