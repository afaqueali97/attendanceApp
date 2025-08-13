
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image/image.dart' as img;
import 'dart:io' as io;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rename_me/utils/constants.dart';
import '../utils/app_colors.dart';
import '../services/service_urls.dart';
import 'date_time_formatter.dart';


/*Created By: Afaque Ali on 05-Aug-2023*/
class CommonCode {

  Future<File> compressImage(File file,{int quality=50}) async {
    double sizeKb = (file.lengthSync() / 1000).toPrecision(2);
    CommonCode().showToast(message: 'ImageSize: $sizeKb KB');
    CompressFormat compressFormat = CompressFormat.jpeg;
    try {
      final filePath = file.absolute.path;
      int lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
      if (lastIndex == -1) {
        lastIndex = filePath.lastIndexOf(RegExp(r'.png'));
        compressFormat = CompressFormat.png;
      }
      final imageSplit = filePath.substring(0, (lastIndex));
      final outPath = "${imageSplit}_out${filePath.substring(lastIndex)}";
      File? compressedImage = await FlutterImageCompress.compressAndGetFile(
          filePath, outPath,
          quality: quality, format: compressFormat);

      if (compressedImage != null) {
        double sizeKb = (compressedImage.lengthSync() / 1000).toPrecision(2);
        CommonCode().showToast(message: 'ImageSize: $sizeKb KB');
        return compressedImage;
      } else {
        return file;
      }
    } catch (e) {
      return file;
    }
  }

  // static Rx<GeneralModel> statistics=GeneralModel().obs;




  static String buildFileName(){
    return "${DateTimeFormatter.getFormattedToday(pattern: 'yyyyMMdd')}-ECP${DateTimeFormatter.getFormattedToday(pattern: 'hhmmss')}";
  }

  void showToast({required String message}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xF9454141),
        textColor: Colors.white,
        fontSize: 13.0);
  }


  Future<File> furtherCompressImage(File file) async{
    //using image plugin
    final filePath = file.absolute.path;
    int lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    if (lastIndex == -1) {
      lastIndex = filePath.lastIndexOf(RegExp(r'.png'));
    }
    final imageSplit = filePath.substring(0, (lastIndex));
    img.Image image = img.decodeImage(file.readAsBytesSync())??img.Image(55, 55);
    img.Image thumbnail = img.copyResize(image, width: 500);
    final outPath2 = "${imageSplit}_out2${filePath.substring(lastIndex)}";
    io.File("$outPath2").writeAsBytesSync(img.encodePng(thumbnail));
    File newCompressed = File(outPath2);
    return newCompressed;
  }

  Future<File> compressImageLoop(File file) async {
    int maxSizeKB = kMaxFileSize;
    CompressFormat compressFormat = CompressFormat.jpeg;
    try {
      String filePath = file.absolute.path;
      int lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
      if (lastIndex == -1) {
        lastIndex = filePath.lastIndexOf(RegExp(r'.png'));
        compressFormat = CompressFormat.png;
      }
      String imageSplit = filePath.substring(0, (lastIndex));
      String outPath = "${imageSplit}_out${filePath.substring(lastIndex)}";
      File? compressedImage;
      int quality = 75; // Initial quality setting
      // Loop until the compressed image is within the size limit
      while ((file.lengthSync()/1024) > maxSizeKB && quality>5) {
        compressedImage = await FlutterImageCompress.compressAndGetFile(
          filePath,
          outPath,
          quality: quality,
          format: compressFormat,
        );
        if (compressedImage != null) {
          if(compressedImage.lengthSync()/1024<=kMaxFileSize){
            return compressedImage;
          }
          quality -= 5; // Reduce quality for the next compression attempt
        } else {
          break; //compression failed case
        }
      }
      return compressedImage ?? file;
    } catch (e) {
      // Return the original file in case of any error
      return file;
    }
  }

  // mock location check
  Future<bool> isLocationMock() async {
    bool isMock = false;
    MethodChannel methodChannel  = getMethodChannel();
    try {
      isMock = await methodChannel.invokeMethod("isMockLocation");
    } catch (e) {}
    return isMock;
  }


  static MethodChannel getMethodChannel(){
    return const MethodChannel("getUniqueIdentifier");
  }

  Future<bool> checkInternetConnection() async {
    var result = await Connectivity().checkConnectivity();
    return result == ConnectivityResult.mobile || result == ConnectivityResult.wifi;
  }

  Future<bool> checkInternetAccess() async {
    try {
      if(await checkInternetConnection()) {
        http.Response response =
        await http.get(Uri.parse("https://www.google.com/"))
            .timeout(const Duration(seconds: 5));
        return response.body.length > 4;
      }
    } catch (_) {}
    return false;
  }

  Future<bool> checkServerConnection() async {
    if(!(await checkInternetConnection())) {
      // showToast(message: kNoInternetMsg);
      return false;
    }
    try {
      http.Response response = (await http.get(Uri.parse(kConnectionCheckURL)).timeout(const Duration(seconds: 5)));
      if(response.statusCode != 200 && (await checkInternetConnection())) {
        CommonCode().showToast(message: "Unable to connect with server");
      }
      return response.statusCode == 200;

    } on TimeoutException catch (_) {
    return  false;
    }
    on Exception catch (_) {
      return false;
    }
  }

  Widget showProgressIndicator(bool visibility, bool isListEmpty) {
    return visibility ? Visibility(
        visible: visibility,
        child:  Padding(
            padding: EdgeInsets.only(top: isListEmpty ? Get.height*0.3 : 10),
            child: Center(child: SizedBox(width: isListEmpty ? null : 20, height: isListEmpty ? null : 20, child: const CircularProgressIndicator(color: kPrimaryColor,strokeWidth: 2))))
    ) : Visibility(
      visible: isListEmpty,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: Get.height*0.3),
        child: Column(
          children: [
            Image.asset('assets/icons/empty-list.png', width: 120, color: kFieldShadowColor,),
            const Text('No Data Found!', style: TextStyle(fontSize: 22, color: kFieldShadowColor, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }


  ///
  /// This method check for latest version on Database and Navigate user to Play Store for Update Application.
  /// - If version is necessary then Popup will not be removed until App is Updated.
  ///
  // Future<void> checkForUpdate() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   String appVersion = packageInfo.version;
  //   VersionCheckModel latestVersion = await GeneralService().getVersionData();
  //   if (Platform.isAndroid && latestVersion.androidVersion.isNotEmpty) {
  //     String version = latestVersion.androidVersion;
  //     if (appVersion.compareTo(version).isNegative) {
  //       CustomDialogs().showDialog(
  //           "Version Update Available",
  //           "New version $version is available.\n${latestVersion.isNecessary?'It is Necessary to':'Please'} Update it.",
  //           DialogType.SUCCES,
  //           const Color(kPrimaryColor),
  //           dismissible: !(latestVersion.isNecessary),
  //           onOkBtnPressed: openStore);
  //     }
  //   }
  // }

  // void openStore() {
  //   launchUrl(//https://play.google.com/store/apps/details?id=pk.gos.spsu.mobileApp
  //     Uri.parse("market://details?id=pk.gos.spsu.mobileApp"),
  //     mode: LaunchMode.externalNonBrowserApplication,
  //   );
  // }

  Future<String> saveImage({required String url,bool greaterThanEleven = false, String imageData= ''}) async {
    Directory? directory;
    String fileSavingName = "file.pdf";
    String newPath = "";
    try {
      if (Platform.isAndroid) {
        String appendDate = "${DateTime.now().microsecond}";
        if (await requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          List<String> paths = directory!.path.split("/");
          List<String> urlList = url.split("/");
          // String downloadFileName = urlList.last;
          // fileSavingName = "${downloadingModelList[indexOfCurrentFileBeingDownloaded].bankTransactionNoOfFile.value}"+"_${appendDate}_"+urlList.last;
          fileSavingName = "_${appendDate}_${urlList.last}";
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/$folder";
            } else {
              break;
            }
          }
          if (!greaterThanEleven) {
            newPath = "$newPath/Download/SFERPApp";
          }else{
            newPath = "$newPath/Download/";
          }
          directory = Directory(newPath);
        } else {
          return "";
        }
      } else {
        if (await requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return "";
        }
      }
      File saveFile = File("${directory.path}/$fileSavingName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        //downloading
         var response =await http.get(Uri.parse(url));
         saveFile.writeAsBytes(response.bodyBytes);
        saveFile.writeAsBytes(base64Decode(imageData));
        //downloaded
        //for ios
        // if (Platform.isIOS) {
        //   await ImageGallerySaver.saveFile(saveFile.path,
        //       isReturnPathOfIOS: true);
        // }
        return "$newPath/$fileSavingName";
      }
      return "";
    } catch (e) {
      return "";
    }
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }


}
