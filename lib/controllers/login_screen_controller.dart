import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/web_services/user_services.dart';
import '../ui/custom_widgets/custom_dialogs.dart';
import '../ui/custom_widgets/custom_progress_dialog.dart';
import '../utils/constants.dart';
import '../utils/text_field_manager.dart';
import '../utils/text_filter.dart';
import '../utils/user_session.dart';


class LoginScreenController extends GetxController{

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextFieldManager usernameTFMController = TextFieldManager('',hint:'Enter username' ,filter: TextFilter.email );
  TextFieldManager passwordTFMController = TextFieldManager('Password',hint: 'Enter Password');
  RxBool rememberMe = false.obs,obscurePassword = true.obs;

  @override
  void onInit() async{
    super.onInit();
  }



  void onSignInPressed() async{
    //todo remove this if implementing in real project
    Get.offAllNamed(kDashboardScreenRoute);

    if(usernameTFMController.validate() & passwordTFMController.validate()){
      ProgressDialog().showDialog();
      UserModel user = await UserService().loginUser(username: usernameTFMController.text, password: passwordTFMController.text);
      ProgressDialog().dismissDialog();

      if(user.responseMessage == 'Success'){
        if(rememberMe.value){
          user.isRemembered = true;await UserSession().createSession(user: user);
        }else{
          user.isRemembered = false;
          await UserSession().createSession(user: user);
        }
        Get.offAllNamed(kDashboardScreenRoute);
      } else {
        CustomDialogs().showDialog("Login Failed", user.responseMessage, DialogType.error);
      }
    }
  }

  void removeFocus(){
    if(usernameTFMController.focusNode.hasFocus){
      usernameTFMController.focusNode.unfocus();
    }
    if(passwordTFMController.focusNode.hasFocus){
      passwordTFMController.focusNode.unfocus();
    }
  }
}