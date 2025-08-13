import 'package:flutter/material.dart';
import '../../utils/user_session.dart';
import '../../utils/app_colors.dart';

class CustomDashboardAppbar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final double appBarHeight;
  final String screenName;
  final Function? onBackButtonPress;

  const CustomDashboardAppbar({
    super.key,
    required this.scaffoldKey,
    required this.screenName,
    required this.onBackButtonPress,
    required this.appBarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      toolbarHeight: appBarHeight,
      automaticallyImplyLeading: false,
      actions: [
        Align(
          alignment: Alignment.topCenter,
          child: GestureDetector(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 0, right: 5, top: 20),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: kWhiteColor),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(Icons.notifications, color: kWhiteColor),
                ),
                Positioned(
                  right: 7,
                  top: 20,
                  child: Container(
                    height: 10,
                    width: 5,
                    decoration: const BoxDecoration(color: kRequiredRedColor, shape: BoxShape.circle),
                  ),
                )
              ],
            ),
            onTap: () {},
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: GestureDetector(
            child: Container(
              width: 38,
              height: 38,
              margin: const EdgeInsets.only(right: 20, top: 20, left: 5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Image.asset('assets/icons/menu-new.png', color: kPrimaryColor),
            ),
            onTap: () {},
          ),
        ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kGreenColor, kBlueColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello ${UserSession.userModel.value.role.toLowerCase().contains("inspector")? "Inspector" : ""},", style: const TextStyle(color: kWhiteColor),),
            Row(
              children: [
                Text(UserSession.userModel.value.name, style: const TextStyle(color: kWhiteColor, fontWeight: FontWeight.w700),),
                Image.asset('assets/icons/hand.png', width: 30,)
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
