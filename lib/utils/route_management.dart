import 'package:get/get.dart';
import 'package:rename_me/ui/screens/attendance_app_screens/view_attendance_records_screen.dart';
import 'package:rename_me/ui/screens/attendance_app_screens/face_scanning_screen.dart';
import 'package:rename_me/ui/screens/attendance_app_screens/register_new_user_screen.dart';
import 'package:rename_me/ui/screens/attendance_app_screens/view_registered_users_screen.dart';
import '../ui/screens/dashboard_screen.dart';
import '../ui/screens/registration_screen.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/setting_screen.dart';
import '../ui/screens/splash_screen.dart';
import '../utils/constants.dart';
import '../utils/screen_bindings.dart';

/*Created By: Afaque Ali on 03-Aug-2023*/

class RouteManagement {
  static List<GetPage> getPages() {
    // const duration = Duration(milliseconds: 500);
    return [
      GetPage(
        name: kSplashScreenRoute,
        page: () => const SplashScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: kDashboardScreenRoute,
        page: () => const DashboardScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(
        name: kSettingScreenRoute,
        page: () => const SettingScreen(),
        binding: ScreensBindings(),
      ),
      GetPage(name: kRegistrationScreenRoute,
          page: ()=> const RegistrationScreen(),
          binding: ScreensBindings()
      ),
      GetPage(name: kLoginScreenRoute,
          page: ()=> const LoginScreen(),
          binding: ScreensBindings()
      ),
      GetPage(name: kScanFaceScreenRoute,
          page: ()=> const FaceScanningScreen(),
          binding: ScreensBindings()
      ),
      GetPage(
        name: kRegisterUserScreenRoute,
        page: ()=> const RegisterNewUserScreen(),
        binding: ScreensBindings()
      ),
      GetPage(
          name: kViewRegisteredUsersScreenRoute,
          page: () => const ViewRegisteredUsersScreen(),
          binding: ScreensBindings()),
      GetPage(
        name: kViewAttendanceRecordsScreenRoute,
        page: () => const ViewAttendanceRecordsScreen(),
        binding: ScreensBindings(),
      )
    ];
  }
}
