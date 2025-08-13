import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/setting_screen_controller.dart';
import '../../utils/app_colors.dart';

class SettingScreen extends GetView<SettingScreenController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: kFieldGreyColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: kWhiteColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: kPrimaryColor,
        title: const Text(
          "Settings",
          style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildHeadingWidget(title: "General"),
          Obx(() => _buildGeneralTabItem(title: "App Version", value: controller.appVersion.value)),
        ],
      ),
    );
  }



  Widget _buildHeadingWidget({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        title,
        style: const TextStyle( fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
      ),
    ); 
  }

  Widget _buildGeneralTabItem({required String title, required String value}) {
    return Container(
      decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: 0.1,
                offset: const Offset(0, 1),
                blurRadius: 1)
          ]),
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
      width: Get.width,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(Icons.info_outlined, color: Colors.grey, size: 26),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          // Spacer(),
        ],
      ),
    );
  }

  Widget _buildGeneralSwitchTabItem(
      {required String title, required bool value, Function(bool)? onChanged}) {
    return Container(
      decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: 0.1,
                offset: const Offset(0, 1),
                blurRadius: 1)
          ]),
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 4),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      width: Get.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Switch(
            value: value,
            onChanged: onChanged ,
            activeColor: kPrimaryColor,
          ),
        ],
      ),
    );
  }
}
