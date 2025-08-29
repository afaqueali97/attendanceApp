import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rename_me/models/attendance_module/user_attendance_model.dart';
import 'package:image/image.dart' as img;
import 'package:rename_me/utils/common_code.dart';
import '../../services/firebase_services/firebase_storage_service.dart';
import '../../services/firebase_services/firestore_service.dart';

class ViewRegisteredUsersScreenController extends GetxController{

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final box = Hive.box('face_db');
  final FirestoreService firestoreService = Get.find<FirestoreService>();
  final FirebaseStorageService storageService = Get.find<FirebaseStorageService>();
  RxList<UserAttendanceModel> userAttendanceModel = RxList();
  RxList<MapEntry<dynamic, dynamic>> users = <MapEntry<dynamic, dynamic>>[].obs;
  RxBool isSyncing = false.obs;
  RxMap<String, Uint8List> cloudImages = <String, Uint8List>{}.obs; // Cache for cloud images

  @override
  void onInit() {
    super.onInit();
    loadStoredUsers();
    // Sync with Firestore on init
    syncWithFirestore();
  }

  Future<void> loadStoredUsers() async {
    final box = Hive.box('face_db');
    final allUsers = box.toMap().entries.cast<MapEntry<dynamic, dynamic>>().toList();

    // Fix rotation for all images
    for (var i = 0; i < allUsers.length; i++) {
      final user = allUsers[i];
      allUsers[i] = MapEntry(
        user.key,
        _fixImageRotation(user.value),
      );
    }

    users.value = allUsers;
  }

  Uint8List _fixImageRotation(Uint8List imageBytes) {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) return imageBytes;

      final fixedImage = img.copyRotate(image, 0);
      return Uint8List.fromList(img.encodeJpg(fixedImage));
    } catch (e) {
      debugPrint('Error fixing image rotation: $e');
      return imageBytes;
    }
  }

  Future<void> deleteUser(String name) async {
    try {
      isSyncing.value = true;
      final box = Hive.box('face_db');
      await box.delete(name);

      // Also delete from Firestore and Storage
      await firestoreService.deleteUser(name);

      // Remove from cache
      cloudImages.remove(name);

      loadStoredUsers(); // Refresh the list
      CommonCode().showToast(message: "$name deleted successfully");
    } catch (e) {
      CommonCode().showToast(message: "Failed to delete user: $e");
    } finally {
      isSyncing.value = false;
    }
  }

  // Sync Hive data with Firestore
  Future<void> syncWithFirestore() async {
    try {
      isSyncing.value = true;
      final box = Hive.box('face_db');
      final allUsers = box.toMap();

      // Upload all users to Firestore
      for (var entry in allUsers.entries) {
        final String name = entry.key;
        final Uint8List imageBytes = entry.value;
        final exists = await firestoreService.userExists(name);

        if (!exists) {
          await firestoreService.addUser(name: name,imageBytes: imageBytes);
        } else {
          // Optionally update existing user
          // await firestoreService.updateUser(name, imageBytes);
        }
      }

      CommonCode().showToast(message: "Synced with Firestore!");
    } catch (e) {
      CommonCode().showToast(message: "Failed to sync data: $e");
    } finally {
      isSyncing.value = false;
    }
  }

  // Load image from cloud (with caching)
  Future<Uint8List?> loadCloudImage(String name) async {
    try {
      // Check if image is already in cache
      if (cloudImages.containsKey(name)) {
        return cloudImages[name];
      }

      // Download image from Storage
      final Uint8List imageData = await storageService.getImage(name);

      // Add to cache
      cloudImages[name] = imageData;

      return imageData;
    } catch (e) {
      debugPrint('Error loading cloud image: $e');
      return null;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onBackPressed() => Get.back();
}