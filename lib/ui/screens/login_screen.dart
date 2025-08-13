

import '../../ui/custom_widgets/general_text_field.dart';
import '../../utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/login_screen_controller.dart';
import '../../ui/custom_widgets/general_button.dart';
import '../../utils/app_colors.dart';

class LoginScreen extends GetView<LoginScreenController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.removeFocus,
      child: Scaffold(key: controller.scaffoldKey,
        backgroundColor: kWhiteColor,
        body: _getBody(),
      ),
    );
  }

  Widget _getBody(){
    final height = Get.height;
    final width = Get.width;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height*0.14),

          Image.asset("assets/images/gos_logo.png",
            width: Get.width*0.3,
            // height: Get.width*0.3,
            color: kBlackColor,
          ),
          const SizedBox(height: 20),

          const Text('TRANSPORT & MASS TRANSIT',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color:kPrimaryColor,
            ),
          ),
          const Text('GOVERNMENT OF SINDH',
            style: TextStyle(
              color: kTextHintColor,
              fontSize: 18,
              letterSpacing: 2
            ),
          ),
          SizedBox(height: height*0.04),

          GeneralTextField(tfManager: controller.usernameTFMController,

            prefixIcon: Icons.mail_outline_rounded,
          ),
          const SizedBox(height: 12),
          GeneralTextField(tfManager: controller.passwordTFMController),


          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Remember Me',style: TextStyle(fontSize: 14,color: kLightGreyColor,fontWeight: FontWeight.w600),),
              const SizedBox(width: 4),
              Obx(()=> Switch(
                activeColor: kPrimaryColor,
                inactiveThumbColor: kGreyColor,
                value: controller.rememberMe.value,
                onChanged: (_) => controller.rememberMe.toggle(),
              )),
              const Spacer(),
              const Text('Forgot Password?',style: TextStyle(fontSize: 14,color: kTextLinkColor, letterSpacing:0, decoration: TextDecoration.underline,decorationColor: kTextLinkColor)),
            ],
          ),


          const SizedBox(height: 16),
          GeneralButton(
            onPressed: controller.onSignInPressed,
            text: 'Login',

            height: 40,
          ),

          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: height*0.02),
            child: RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                style: const TextStyle(
                    fontFamily: "PoppinsLight",
                    color: kTextHintColor,
                ),
                children: <TextSpan>[
                const TextSpan(text: "Don't have an account? "),
                TextSpan(
                  text: "Sign Up",
                  style: const TextStyle(
                      height: 1.2,
                      fontSize: 16,
                      letterSpacing: 0.08,
                      fontWeight: FontWeight.w600,
                      fontFamily: "PoppinsLight",
                      color: kTextLinkColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {Get.toNamed(kRegistrationScreenRoute);},
                ),
              ],
              ),
            ),
          ),
          const SizedBox(height: 40),

        ],
      ),
    );
}

}

