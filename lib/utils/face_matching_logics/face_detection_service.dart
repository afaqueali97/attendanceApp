import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionService {
  final FaceDetector _detector = FaceDetector(
    options: FaceDetectorOptions(enableClassification: true, enableTracking: true),
  );

  Future<List<Face>> detectFaces(InputImage image) {
    return _detector.processImage(image);
  }

  void dispose() {
    _detector.close();
  }
}