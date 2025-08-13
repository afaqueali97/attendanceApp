import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/splash_screen_controller.dart';
import '../../utils/app_colors.dart';

/*Created By: Afaque Ali on 05-Aug-2023*/
class SplashScreen extends GetView<SplashScreenController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> Future.value(false),
      child: GestureDetector(
        onTap: controller.onScreenTap,
        child: Scaffold(
          key: controller.scaffoldKey,
          body: Container(
            width: Get.width,
            height: Get.height,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              image: DecorationImage(
                image: AssetImage("assets/images/splash_bg.png"),
                fit: BoxFit.cover,
                // repeat: ImageRepeat.repeatY,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
