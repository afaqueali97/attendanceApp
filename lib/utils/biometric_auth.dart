import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:pspa/utils/common_code.dart';
// import 'package:pspa/utils/user_session.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import '../utils/user_session.dart';

import 'common_code.dart';

class BiometricAuth{

  static final BiometricAuth _instance = BiometricAuth._internal();
  BiometricAuth._internal();
  factory BiometricAuth() {
    return _instance;
  }

  late final LocalAuthentication localAuth;
  static RxBool isBiometricAvailable = false.obs;
  static RxBool isFaceIdAvailable = false.obs;
  static RxBool isDeviceSupported = false.obs;
  static bool isFaceIdEnabled = false;
  static bool isFingerPrintEnabled = false;

  Future<void> initBiometricAuth()async{
    localAuth = LocalAuthentication();
    bool isCheckBiometric =await localAuth.canCheckBiometrics;
    bool isCheckDeviceSupport = await localAuth.isDeviceSupported();
    isDeviceSupported.value = isCheckBiometric || isCheckDeviceSupport;
  }

  Future<void> initBiometricSupportive() async{
    if(!isDeviceSupported.value) return;
    await _getAvailableBiometrics();
    isFaceIdEnabled = await UserSession().getFaceIdAuth();
    isFingerPrintEnabled = await UserSession().getFingerPrintAuth();
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
    isFaceIdAvailable.value = availableBiometrics.contains(BiometricType.face) || availableBiometrics.contains(BiometricType.weak);
    isBiometricAvailable.value = availableBiometrics.contains(BiometricType.fingerprint) || availableBiometrics.contains(BiometricType.strong);
    if(!isFaceIdAvailable.value){
      await UserSession().setFaceIdAuth(value: false);
    }
    if(!isBiometricAvailable.value){
      await UserSession().setFingerPrintAuth(value: false);
    }
    // if(Platform.isIOS){
    //   isFaceIdAvailable.value = availableBiometrics.contains(BiometricType.face);
    //   isBiometricAvailable.value = availableBiometrics.contains(BiometricType.fingerprint);
    // }else{
    //   isBiometricAvailable.value = availableBiometrics.contains(BiometricType.fingerprint);
    // }
  }

  Future<bool> biometricAuth({required String title}) async{
   try{
    bool isAuthenticated = false;
      isAuthenticated = await localAuth.authenticate(
        localizedReason: title,
        options:  const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    return isAuthenticated;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        CommonCode()
            .showToast(message: 'Biometric Authentication is not available');
      } else if (e.code == auth_error.notEnrolled) {
        CommonCode().showToast(
            message: 'Biometric Authentication is not enrolled on this device');
      } else if (e.code == auth_error.passcodeNotSet) {
        CommonCode().showToast(
            message: 'Please set passcode to enable Biometric Authentication');
      } else if (e.code == auth_error.lockedOut) {
        CommonCode()
            .showToast(message: 'Biometric Authentication is locked out');
      } else if (e.code == auth_error.permanentlyLockedOut) {
        CommonCode().showToast(
            message: 'Biometric Authentication is permanently locked out');
      } else if (e.code == auth_error.otherOperatingSystem) {
        CommonCode().showToast(
            message: 'Biometric Authentication is not supported on this OS');
      }
      return false;
   }
  }
}