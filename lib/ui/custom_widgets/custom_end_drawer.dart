import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/custom_widget_controllers/custom_end_drawer_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/user_session.dart';

class CustomEndDrawer extends GetView<CustomEndDrawerController> {
  const CustomEndDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20),
          // bottomRight: Radius.circular(20)
      )),
      backgroundColor: kPrimaryColor.withAlpha(235),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(right: 15, left: 18, top: 24+MediaQuery.of(context).padding.top, bottom: 20),
            child: Column(
              children: [
                Container(
                  width: 86,
                  padding: const EdgeInsets.all(3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x44444444),
                          blurRadius: 1.5,
                          spreadRadius: 1.5)
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(70.0),
                    child: Image.asset('assets/images/app_logo.png'),
                  ),
                ),
                const SizedBox(width: 8,),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Text(
                    UserSession.userModel.value.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: kWhiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Obx(
                  () => Text(
                    UserSession.userModel.value.email,
                    style: const TextStyle(
                      color: kWhiteColor,
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
              child: Container(
                width: double.infinity,
                // padding: const EdgeInsets.only( top: 0, bottom: 0),
                decoration: const BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 20),
                      _getDrawerNavItem(title: "Settings", icon: CupertinoIcons.settings),
                      // const Divider(indent: 54),
                      // _getDrawerNavItem(title: "User", icon: 'assets/icons/user_icon.png',
                      //   enabled: UserSession.userModel.value.hasInfrastructurePermission,
                      // ),
                    ],),
                ),
              ),
            ),
          ),
          Container(
            color: kWhiteColor,
            // width: double.infinity,
            child: Column(
              children: [
                const Divider(thickness: 1,height: 1),
                // SizedBox(height: 12,),
                _getDrawerNavItem(title: "Logout", icon: Icons.logout_outlined),
                // SizedBox(height: 12,),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _getDrawerNavItem({required String title, required icon, bool enabled = true, bool changeColor = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: enabled ? ()=> controller.onTap(title) : null,
        child: Row(
          children: [
            (icon is String) ?
            Image.asset(enabled ? icon :'assets/icons/lock_icon.png', width: 30, height: 30, color: !enabled ?kLightGreyColor: changeColor? kPrimaryColor:null ) :
            Icon(icon, size: 25, color: !enabled ?kLightGreyColor: changeColor? kPrimaryColor:null),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.left,
                style:  TextStyle(
                    color: kTextColor.withAlpha(210),
                  fontSize: 17,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            const Icon(CupertinoIcons.forward, color: kLightGreyColor),
          ],
        ),
      ),
    );
  }
}
