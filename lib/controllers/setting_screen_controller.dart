import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingScreenController extends GetxController{
  final RxString appVersion = "".obs;
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onInit() async{
    super.onInit();
    getVersionInfo();
  }


  Future<void> getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
  }

}