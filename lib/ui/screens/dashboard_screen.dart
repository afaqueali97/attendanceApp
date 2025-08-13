import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_screen_controller.dart';
import '../../utils/app_colors.dart';
import '../custom_widgets/custom_dialogs.dart';

class DashboardScreen extends GetView<DashboardScreenController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        CustomDialogs().showAwesomeConfirmationDialog("Are you sure you want to exit?",onOkBtnPressed: ()=>exit(0));
        return Future.value(false);
      },
      child: Scaffold(
        key: controller.scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 90,
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
           leading: GestureDetector(
              child:  const Padding(
                padding: EdgeInsets.only(left: 10,top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image.asset('assets/icons/menu_icon.png', height: 26, width: 34),
                    // const SizedBox(height: 2),
                    // const Text('Menu',style: TextStyle(fontSize: 11,fontWeight: FontWeight.w400,color: kWhiteColor))
                  ],
                ),
              ),
              onTap: () {
                controller.scaffoldKey.currentState!.openDrawer();
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
        ),
        body: _buildBody(),
      ),
    );
  }
Widget  _buildBody() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.only(top: Get.height*0.1,left: 20,right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Main Menu",style: TextStyle(color: Color(0xff231F20),fontSize: 24,fontWeight: FontWeight.w400)),
                Container(
                  width: Get.width,
                  height: Get.height,
                  child: GridView(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    children: [
                      _dashboardCard(title: "Register User",iconPath: 'assets/icons/dashboard_icons/add_user_icon.png'),
                      _dashboardCard(title: "Mark Attendance",iconPath: 'assets/icons/dashboard_icons/face_scan_icon.png'),
                      _dashboardCard(title: "View Registered Users",iconPath: 'assets/icons/dashboard_icons/list_icon.png'),
                      // _dashboardCard(title: "Delete user",iconPath: 'assets/icons/dashboard_icons/remove_user_icon.png'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -5,
          child: Container(
           height: Get.height*0.07,
           width: Get.width,
           padding: const EdgeInsets.only(bottom: 20),
           alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),
            child: const Text(
            "Dashboard",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500,  color: kWhiteColor),
          ),
          ),
        )
      ],
    );
  }

   Widget _dashboardCard({String title="Title",Color shadowColor=const Color(0xff0F663E), String iconPath='', bool enabled =true}) {
    return GestureDetector(
      onTap:()=> controller.onDashboardCardTap(title),
      child: Container(
        height: 160,
        decoration: BoxDecoration(color: const Color(0xffF4F3FF),borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: shadowColor,blurRadius: 0,offset: const Offset(8, 6)),BoxShadow(color: shadowColor,blurRadius: 0,offset: const Offset(8, 0))]),
        margin: const EdgeInsets.only(right: 8,top: 20),
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(color: enabled? Colors.transparent: Colors.grey.shade200,borderRadius: BorderRadius.circular(20),
          boxShadow:  const [BoxShadow(color: Colors.black12,blurRadius: 10,offset: Offset(0, 10))]),
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 60,width: 60,padding: const EdgeInsets.only(left: 7),child: enabled? Image.asset(iconPath): Image.asset('assets/icons/lock.png',color: Colors.transparent)),
              const SizedBox(height: 5),
              Text(title,textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 2,
                style:  const TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color(0xff000000)))
            ],
          ),
        ),
      ),
    );
  }

}
