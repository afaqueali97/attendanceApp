import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rename_me/models/attendance_module/user_attendance_model.dart';
import 'package:image/image.dart' as img;

class ViewRegisteredUsersScreenController extends GetxController{

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final box = Hive.box('face_db');
  RxList<UserAttendanceModel> userAttendanceModel = RxList();
  RxList<MapEntry<dynamic, dynamic>> users = <MapEntry<dynamic, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStoredUsers();
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

      // Rotate 180 degrees to correct the orientation
      // final fixedImage = img.copyRotate(image, 180);
      final fixedImage = img.copyRotate(image, 0);
      return Uint8List.fromList(img.encodeJpg(fixedImage));
    } catch (e) {
      debugPrint('Error fixing image rotation: $e');
      return imageBytes;
    }
  }

  Future<void> deleteUser(String name) async {
    final box = Hive.box('face_db');
    await box.delete(name);
    loadStoredUsers(); // Refresh the list
    Get.snackbar('Success', '$name deleted successfully');
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onBackPressed() => Get.back();
}