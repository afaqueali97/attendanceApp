import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/version_check_model.dart';
import '../services/web_services/general_service.dart';
import '../ui/custom_widgets/custom_dialogs.dart';
import '../utils/constants.dart';
import '../utils/user_session.dart';
import 'package:url_launcher/url_launcher.dart';

/*Created By: Afaque Ali on 15-Aug-2023*/

class SplashScreenController extends GetxController {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late Timer _timer;

  @override
  void onInit() {
    _timer = Timer(const Duration(seconds: 5), () {
      _screenNavigation();
    });
    super.onInit();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _screenNavigation() async {
    // checkForUpdate();
      if (await UserSession().isUserLoggedIn()) {
        Get.offAllNamed(kDashboardScreenRoute);
      } else {
        Get.offAllNamed(kDashboardScreenRoute);
        // Get.offAllNamed(kScanFaceScreenRoute);
      }
  }

  void onScreenTap() {
    _timer.cancel();
    _screenNavigation();
  }

  Future<void> checkForUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    VersionCheckModel latestVersion = await GeneralService().getVersionData();
    if (Platform.isAndroid && latestVersion.androidVersion.isNotEmpty) {
      String version = latestVersion.androidVersion;
      if (appVersion.compareTo(version).isNegative) {
        CustomDialogs().showAppUpdateDialog(
            "Update Available",
            "New version $version is available.\n${latestVersion.isNecessary?'It is Necessary to':'Please'} Update it.",
            features: latestVersion.whatsNew,
            dismissible: !(latestVersion.isNecessary),
            onOkBtnPressed:()=> openStore(packageInfo.packageName));
      }
    }
  }

  void openStore(String packageName) {
    launchUrl(
      Uri.parse("https://play.google.com/store/apps/details?id=$packageName"),
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }

}
