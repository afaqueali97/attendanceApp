/*Created by Afaque Ali on 21-Aug-2024*/

import '../../controllers/registration_screen_controller.dart';
import '../../ui/custom_widgets/custom_scaffold.dart';
import '../../ui/custom_widgets/general_button.dart';
import '../../ui/custom_widgets/general_date_picker_field.dart';
import '../../ui/custom_widgets/general_text_field.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationScreen extends GetView<RegistrationScreenController> {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      key: controller.scaffoldKey,
      // className: runtimeType.toString(),
      // screenName: '',
      // gestureDetectorOnTap: controller.removeFocus,
      // onNotificationListener: (detail){
      //   if(detail is UserScrollNotification) {
      //     controller.removeFocus();
      //   }
      //   return true;
      // },
      // showBottomNavBar: false,
      body: GestureDetector(
          onTap: controller.removeFocus,
          child: getBody(context)),
    );
  }

  Widget getBody(BuildContext context){
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
        Container(
          margin: EdgeInsets.only(top: Get.height*0.1,bottom: 20),
          child: const Text('Create Account', style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color:kTextColor,
          ),
          ),
        ),
        GeneralTextField(tfManager: controller.fullNameTfManager,),
        GeneralTextField(tfManager: controller.cnicTfManager,),
        GeneralTextField(tfManager: controller.emailTfManager,),
        GeneralTextField(tfManager: controller.mobileNoTfManager,),
        GeneralTextField(tfManager: controller.passwordTfManager,),
        GeneralTextField(tfManager: controller.confirmPasswordTfManager,),
        const SizedBox(height: 8),
        GeneralButton(onPressed: (){controller.onRegister();},text: 'Register',),
        const SizedBox(height:30),
        RichText(
          textAlign: TextAlign.right,
          text: TextSpan(
            style: const TextStyle(
              fontFamily: "PoppinsLight",
              color: kTextHintColor,
            ),
            children: <TextSpan>[
              const TextSpan(text: "Already have an account? "),
              TextSpan(
                text: "Sign In",
                style: const TextStyle(
                    height: 1.2,
                    fontSize: 16,
                    letterSpacing: 0.08,
                    fontFamily: "PoppinsLight",
                    fontWeight: FontWeight.w600,
                    color: kTextLinkColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {Get.toNamed(kLoginScreenRoute);},
              ),
            ],
          ),
        ),
      ],),
    );
  }
}
