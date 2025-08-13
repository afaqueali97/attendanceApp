import 'package:get/get.dart';
import 'package:rename_me/controllers/attendance_app_screen_controllers/delete_user_screen_controller.dart';
import 'package:rename_me/controllers/attendance_app_screen_controllers/face_scanning_screen_controller.dart';
import 'package:rename_me/controllers/attendance_app_screen_controllers/register_new_user_screen_controller.dart';
import 'package:rename_me/controllers/attendance_app_screen_controllers/view_registered_users_screen_controller.dart';
import '../controllers/dashboard_screen_controller.dart';
import '../controllers/registration_screen_controller.dart';
import '../controllers/login_screen_controller.dart';
import '../controllers/setting_screen_controller.dart';
import '../controllers/splash_screen_controller.dart';


///Created by Afaque Ali 03-Aug-2023
class ScreensBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenController());
    Get.lazyPut(() => DashboardScreenController());
    Get.lazyPut(() => RegistrationScreenController());
    Get.lazyPut(() => LoginScreenController());
    Get.lazyPut(() => SettingScreenController());
    // Get.lazyPut(() => ScanFaceScreenController());
    Get.lazyPut(() => FaceScanningScreenController());
    Get.lazyPut(() => DeleteUserScreenController());
    Get.lazyPut(() => RegisterNewUserScreenController());
    Get.lazyPut(() => ViewRegisteredUsersScreenController());
  }

}
