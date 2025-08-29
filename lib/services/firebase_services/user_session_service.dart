import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSessionService extends GetxService {
  static UserSessionService get instance => Get.find<UserSessionService>();

  final RxString userId = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString displayName = ''.obs;
  final RxBool isLoggedIn = false.obs;

  Future<void> createSession({
    required String userId,
    required String email,
    required String displayName,
    required bool rememberMe,
  }) async {
    this.userId.value = userId;
    this.userEmail.value = email;
    this.displayName.value = displayName;
    this.isLoggedIn.value = true;

    if (rememberMe) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      await prefs.setString('userEmail', email);
      await prefs.setString('displayName', displayName);
    }
  }

  Future<void> clearSession() async {
    userId.value = '';
    userEmail.value = '';
    displayName.value = '';
    isLoggedIn.value = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userEmail');
    await prefs.remove('displayName');
  }

  Future<bool> hasActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedUserId = prefs.getString('userId');

    if (savedUserId != null) {
      userId.value = savedUserId;
      userEmail.value = prefs.getString('userEmail') ?? '';
      displayName.value = prefs.getString('displayName') ?? '';
      isLoggedIn.value = true;
      return true;
    }

    return false;
  }

  Future<String?> getUserId() async {
    if (userId.value.isNotEmpty) {
      return userId.value;
    }

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
}