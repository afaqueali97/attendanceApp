import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:rename_me/models/result_model.dart';
import 'package:rename_me/utils/common_code.dart';
import '../models/item_model.dart';
import '../models/user_model.dart';
import '../models/token_model.dart';

/*Created By: Afaque Ali on 15-Aug-2023*/
class UserSession {

  static final RxBool isDataChanged = RxBool(false);
  static final Rx<UserModel> userModel = UserModel.empty().obs;
  static Rx<Offset> backButtonPosition = Offset(12, Get.height*0.8).obs;
  static RxInt backButtonTransparency = (0xCC).obs;
  static const String keyAllDataSynced = "AllDataSynced";

  static final UserSession _instance = UserSession._internal();
  UserSession._internal();
  factory UserSession() {
    return _instance;
  }

  Future<bool> createSession({required UserModel user}) async {
    const FlutterSecureStorage storage =  FlutterSecureStorage();
    userModel.value = user;
    await storage.write(key: 'USER_DATA', value: jsonEncode(userModel.value.toOfflineJson()));
    return true;
  }

  Future<bool> isUserLoggedIn() async {
    const FlutterSecureStorage storage =  FlutterSecureStorage();
    final value = await storage.read(key: 'USER_DATA');
    userModel.value = UserModel.fromOfflineJson(jsonDecode(value ?? "{}"));
    return !userModel.value.isEmpty && userModel.value.isRemembered;
  }

  Future<bool> logout() async {
    const FlutterSecureStorage storage =  FlutterSecureStorage();
    // await storage.delete(key: 'FINGER_PRINT_AUTH');
    // await storage.delete(key: 'FACE_ID_AUTH');
    if (await UserSession().getFingerPrintAuth()) {
      userModel.value.isRemembered = false;
      await createSession(user: userModel.value);
    } else {
    await storage.delete(key: 'USER_DATA');
    userModel.value = UserModel.empty();
    }
    return true;
  }

  Future<void> saveToken({required TokenModel token}) async {
    const FlutterSecureStorage storage =  FlutterSecureStorage();
    await storage.write(key: 'access_token', value: jsonEncode(token.forSession()));
  }

  Future<TokenModel> getToken() async {
    const FlutterSecureStorage storage =  FlutterSecureStorage();
    final value = await storage.read(key: 'access_token');
    final TokenModel token = TokenModel.fromSession(jsonDecode(value ?? '{}'));
    return token;
  }

  Future<void> setFingerPrintAuth({required bool value})async{
    const FlutterSecureStorage storage =  FlutterSecureStorage();
    await storage.write(key: 'FINGER_PRINT_AUTH', value: value.toString());
  }

  Future<bool> getFingerPrintAuth()async{
    const FlutterSecureStorage storage =  FlutterSecureStorage();
    final value = await storage.read(key: 'FINGER_PRINT_AUTH');
    return value == 'true';
  }

  Future<void> setFaceIdAuth({required bool value})async{
    const FlutterSecureStorage storage =  FlutterSecureStorage();
    await storage.write(key: 'FACE_ID_AUTH', value: value.toString());
  }

  Future<bool> getFaceIdAuth()async{
    const FlutterSecureStorage storage =  FlutterSecureStorage();
    final value = await storage.read(key: 'FACE_ID_AUTH');
    return value == 'true';
  }

  // Save and get any type of meta data list
  Future<void> saveMetaData({required List<ItemModel> metaData, required String type}) async {
    const FlutterSecureStorage storage =  FlutterSecureStorage();
    await storage.write(key: type, value: jsonEncode(metaData.map((e) => e.toJson()).toList()));
  }

  Future<List<ItemModel>> getMetaData({required String type}) async {
    const FlutterSecureStorage storage =  FlutterSecureStorage();
    final result = await storage.read(key: type);
    if(result == null) return [];
    final List<ItemModel> metaData = (jsonDecode(result) as List).map((e) => ItemModel.fromJson(e)).toList();
    return metaData;
  }

  Future<void> saveDataSyncStatus({required String key, required bool value}) async {
    const FlutterSecureStorage storage =  FlutterSecureStorage();
    await storage.write(key: key, value: value.toString());
  }

  Future<bool> getDataSyncStatus({required String key}) async {
    const FlutterSecureStorage storage =  FlutterSecureStorage();
    final value = await storage.read(key: key);
    return value == 'true';
  }

  Future<void> setFirstTimeSyncStatus({required bool value}) async {
    const FlutterSecureStorage storage =  FlutterSecureStorage();
    await storage .write(key: 'FirstTimeDataSync', value: value.toString());
  }

  Future<bool?> checkFirstTimeSyncStatus() async {
    const FlutterSecureStorage storage =  FlutterSecureStorage();
    final value = await storage.read(key: 'FirstTimeDataSync');
    if(value == null) return null;
    return value == 'true';
  }


  final FlutterSecureStorage _storage =  const FlutterSecureStorage();
  static final RxString language = 'en'.obs;
  static String basicData = '';
  static RxString apkVersion = "1.0.0".obs;

  Future<void> setBiometricEnabled(bool enable)async{
    /*final preference = await SharedPreferences.getInstance();
    return await preference.setBool(_isBioEnabled, enable);*/
    await _storage.write(aOptions: _getAndroidOptions(),key: '_isBioEnabled', value: enable.toString());

  }

  Future<bool> isBiometricEnabled()async{
    /*final preference = await SharedPreferences.getInstance();
    return preference.getBool(_isBioEnabled)??false;*/
    var bio = await _storage.read(key: '_isBioEnabled',aOptions: _getAndroidOptions());

    if(bio!=null){
      return bio=='true';
    } else{
      return false;
    }
  }

  Future<void> setTabularOptionEnabled(bool enable)async{
    await _storage.write(aOptions: _getAndroidOptions(),key: '_isTabularOptionEnabled', value: enable.toString());
  }

  Future<bool> isTabularOptionEnabled()async{
    String bio = (await _storage.read(key: '_isTabularOptionEnabled',aOptions: _getAndroidOptions()))??'';
    return bio=='true';
  }

  Future<void> setRememberMe(bool rememberMe)async{
    /*final preference = await SharedPreferences.getInstance();
    return await preference.setBool(_rememberMe, rememberMe);*/
    await _storage.write(aOptions: _getAndroidOptions(),key: '_rememberMe', value: rememberMe.toString());
  }

  Future<bool?> isRememberMe()async{
    /*final preference = await SharedPreferences.getInstance();
    return preference.getBool(_rememberMe)??false;*/
    String? rememberMe = await _storage.read(aOptions: _getAndroidOptions(),key: '_rememberMe');
    if(rememberMe!=null){
      return rememberMe=='true';
    } else {
      return null;
    }
  }

  Future<void> setUserCNIC({required String cnic}) async {
    /*final preference = await SharedPreferences.getInstance();
    preference.setString(_userCNIC, cnic);*/
    await _storage.write(aOptions: _getAndroidOptions(),key: '_userCNIC', value: cnic);
  }

  Future<String> getUserCNIC() async {
    /*final preference = await SharedPreferences.getInstance();
    return preference.getString(_userCNIC)??"";*/
    return await _storage.read(aOptions: _getAndroidOptions(),key: '_userCNIC')??'';
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  Future<void> setLanguage(String language) async {
    await _storage.write(aOptions: _getAndroidOptions(),key: "_language", value: language);
  }

  Future<void> setDeviceImei({required String imei}) async {
    await _storage.write(aOptions: _getAndroidOptions(),key: '_deviceIMEI', value: imei);
  }

  Future<String> getDeviceImei() async {
    return await _storage.read(aOptions: _getAndroidOptions(),key: '_deviceIMEI')??'';
  }

  Future<void> getLanguage() async {
    /*final preference = await SharedPreferences.getInstance();
    return preference.getString(_userCNIC)??"";*/
    language.value = await _storage.read(aOptions: _getAndroidOptions(),key: '_language')??'en';
  }

  Future<void> setSecureImage({required ResultModel resultModel,}) async {
    await _storage.write(aOptions: _getAndroidOptions(),key: "_resultModel", value: json.encode(resultModel.toSecureJson()));
  }

  Future<ResultModel> getSecureImage() async {
    return ResultModel.fromSecureJson(jsonDecode(await _storage.read(aOptions: _getAndroidOptions(),key: "_resultModel")??"'':''"));
  }

}
