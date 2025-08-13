import 'package:get/get.dart';
import '../../ui/custom_widgets/custom_dialogs.dart';
import '../../utils/constants.dart';
import '../../utils/user_session.dart';

class CustomEndDrawerController extends GetxController{

  Future<void> onTap(String title) async {
    Get.back();
    if(title == 'Logout'){
      CustomDialogs().confirmationDialog(message: "Are you sure want to Logout?", yesFunction: () async{
        await UserSession().logout();
        Get.offAllNamed(kHomeScreenRoute);
      });
    } else if(title=='Settings' && Get.currentRoute != kSplashScreenRoute){
      Get.offAllNamed(kSettingScreenRoute, predicate: (r)=>r.isFirst);
    }
  }
}