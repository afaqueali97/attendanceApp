import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';
import '../utils/user_session.dart';

class DashboardScreenController extends GetxController{
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> onDashboardCardTap(String title) async {
    switch (title) {
      case "Register User":
        Get.toNamed(kRegisterUserScreenRoute);
        break;
      case "Mark Attendance":
        Get.toNamed(kScanFaceScreenRoute);
        break;
      case "View Registered Users":
        Get.toNamed(kViewRegisteredUsersScreenRoute);
        break;
      case "View Attendance Records":
        Get.toNamed(kViewAttendanceRecordsScreenRoute);
        break;


      case "Dashboard":
        // Get.toNamed();
        break;
      // case "Intake Registration":
      //   if(UserSession.userModel.value.hasViewIntakeListPermission){
      //     Get.toNamed(kIntakeRegistrationListScreenRoute);
      //   }
      //   break;
      // case "Reports":
      //   // Get.toNamed();
      //   break;
      // case "GRM":
      // Get.toNamed(kComplaintScreenRoute);
      //   break;
      // case "E-Memo":
      //   Get.toNamed(kEMemoScreenRoute);
      //   break;
      default:
        Get.toNamed(kTaskManagementScreenRoute);  // By Default Task Management Route
    }
  }
} 