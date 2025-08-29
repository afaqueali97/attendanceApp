import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:rename_me/utils/common_code.dart';

class FirebaseStorageService extends GetxService {
  static FirebaseStorageService get instance => Get.find<FirebaseStorageService>();

  final FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: "face-attendance-bf0c4");

  // Upload image to Firebase Storage and return the download URL
  Future<String> uploadImage(Uint8List imageBytes, String fileName) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      final Reference ref = _storage.ref().child('face_images/$fileName');

      // Upload the file to Firebase Storage
      final UploadTask uploadTask = ref.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Wait for the upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      CommonCode().showToast(message: 'Failed to upload image: $e');
      rethrow;
    }
  }

  // Delete image from Firebase Storage
  Future<void> deleteImage(String fileName) async {
    try {
      // Create a reference to the file to delete
      final Reference ref = _storage.ref().child('face_images/$fileName');

      // Delete the file
      await ref.delete();
    } catch (e) {
      CommonCode().showToast(message: 'Failed to delete image: $e');
      rethrow;
    }
  }

  // Get image from Firebase Storage
  Future<Uint8List> getImage(String fileName) async {
    try {
      // Create a reference to the file
      final Reference ref = _storage.ref().child('face_images/$fileName');

      // Get the download URL
      final String downloadUrl = await ref.getDownloadURL();

      // Download the file data
      final data = await ref.getData();

      return data!;
    } catch (e) {
      CommonCode().showToast(message: 'Failed to get image: $e');
      rethrow;
    }
  }
}