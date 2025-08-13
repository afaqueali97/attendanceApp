// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;

/// Converts [CameraImage] in YUV420 format to JPEG encoded [Uint8List]
Future<Uint8List?> convertYUV420ToJpeg(CameraImage cameraImage) async {
  try {
    final int width = cameraImage.width;
    final int height = cameraImage.height;
    final img.Image imgImage = img.Image( width, height);

    final Plane yPlane = cameraImage.planes[0];
    final Plane uPlane = cameraImage.planes[1];
    final Plane vPlane = cameraImage.planes[2];

    final int uvRowStride = uPlane.bytesPerRow;
    final int uvPixelStride = uPlane.bytesPerPixel!;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex = uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);
        final int index = y * width + x;

        final int yp = yPlane.bytes[index];
        final int up = uPlane.bytes[uvIndex];
        final int vp = vPlane.bytes[uvIndex];

        int r = (yp + (1.370705 * (vp - 128))).round();
        int g = (yp - (0.337633 * (up - 128)) - (0.698001 * (vp - 128))).round();
        int b = (yp + (1.732446 * (up - 128))).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        imgImage.setPixelRgba(x, y, r, g, b);
      }
    }

    return Uint8List.fromList(img.encodeJpg(imgImage));
  } catch (e) {
    debugPrint("❌ Conversion error: $e");
    return null;
  }
}
