import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ui/custom_widgets/custom_app_bar.dart';
import '../../utils/app_colors.dart';
import 'custom_dialogs.dart';

/*Created By: Afaque Ali on 05-Aug-2023*/
class CustomScaffold extends StatefulWidget {

  final Widget body;
  final String className,screenName;
  final Function? onWillPop,
      gestureDetectorOnTap,
      onBackButtonPressed,
      gestureDetectorOnPanDown,
      onAddPressed,
      onNotificationListener;
  final Future<void> Function()? onRefresh;
  final ScrollController? scrollController;
  final double horizontalPadding;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final double appBarHeight;
  final PreferredSize? bottomSheet;
  final Widget? floatingActionButton;


  const CustomScaffold({super.key,
    required this.className,
    required this.screenName,
    this.onWillPop,
    this.onBackButtonPressed,
    this.gestureDetectorOnPanDown,
    this.gestureDetectorOnTap,
    this.onNotificationListener,
    this.onAddPressed,
    this.onRefresh,
    required this.scaffoldKey,
    required this.body,
    this.scrollController,
    this.horizontalPadding=20,
    this.appBarHeight = 80,
    this.bottomSheet,
    this.floatingActionButton,
  });

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: (){
          if(widget.className == "HomeScreen"|| widget.className == "SignInScreen"){
            if(widget.scaffoldKey.currentState!.isDrawerOpen){
              Get.back();
            }else {
              CustomDialogs().showAwesomeConfirmationDialog("Are you sure you want to exit?",onOkBtnPressed: ()=>exit(0));
            }
            return Future.value(false);
          }else{
            if(widget.onWillPop!=null) {
              return widget.onWillPop!();
            } else {
              return Future.value(true);
            }
          }
        },
        child: GestureDetector(
          onTap: (){
            if(widget.gestureDetectorOnTap != null){
              widget.gestureDetectorOnTap!();
            }
          },
          onPanDown: (panDetails){
            if(widget.gestureDetectorOnPanDown!= null){
              widget.gestureDetectorOnPanDown!(panDetails);
            }
          },
          child: NotificationListener(
            onNotification: (notificationInfo){
              if(widget.onNotificationListener!=null) {
                return widget.onNotificationListener!(notificationInfo);
              } else {
                return false;
              }
            } ,
            child: Scaffold(
              backgroundColor: kPrimaryColor,
              extendBody: true,
              resizeToAvoidBottomInset: true,
              key: widget.scaffoldKey,
              appBar: CustomAppbar(screenName: widget.screenName, scaffoldKey: widget.scaffoldKey, appBarHeight: widget.appBarHeight, bottomSheet: widget.bottomSheet,onBackButtonPress: widget.onBackButtonPressed),
              body: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  decoration: const BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  ),
                  child: Stack(
                  children: [
                  widget.onRefresh != null
                      ? RefreshIndicator(
                      onRefresh: widget.onRefresh!,
                    color: kPrimaryColor,
                    child: ListView(
                      controller: widget.scrollController,
                        // physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom:  widget.onAddPressed == null ? 16 : 64, left: widget.horizontalPadding, right: widget.horizontalPadding),
                      children: [
                        widget.body
                      ],
                    ),
                  ) : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom:  widget.onAddPressed == null ? 16 : 64, left: widget.horizontalPadding, right: widget.horizontalPadding),
                    child:widget.body,
                  ),
                  // bottomNavigationBar: const CustomBottomNavBar(),
                  // endDrawer: isDrawerVisible ?const CustomNavigationDrawer():null,
                  ]
                  ),
                ),
              ),
              floatingActionButton: widget.floatingActionButton ?? (widget.onAddPressed == null ? null : FloatingActionButton(
                onPressed:()=> widget.onAddPressed!(),
                backgroundColor: kPrimaryColor,
                shape: const CircleBorder(),
                child: const Icon(Icons.add,color: kWhiteColor, size: 32),
              )),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            ) ,
          ),
        ));
  }

}