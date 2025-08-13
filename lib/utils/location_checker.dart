/*
  Created By: Afaque Ali on 16-Jan-2023
*/

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/location_model.dart';
import 'common_code.dart';

class LocationChecker{
  static final LocationChecker _instance = LocationChecker._privateConstructor();
  LocationChecker._privateConstructor();

  factory LocationChecker(){
    return _instance;
  }

  Future<void> requestPermission() async {
    PermissionStatus permissionStatus = await Permission.location.status;
    if (!permissionStatus.isGranted) {
      await Permission.location.request();
    }
  }

  Future<LocationModel> currentLocation() async {
    await requestPermission();
    final GeolocatorPlatform geoLocatorPlatform = GeolocatorPlatform.instance;
    if (await Permission.location.status.isGranted) {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String address = await getAddressFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      LocationModel locationModel = LocationModel(currentPosition.latitude, currentPosition.longitude, address);
      return locationModel;
    } else {
      CommonCode().showToast(message: "You have denied the Location permission.\n Please allow it.");
      LocationPermission permissionStatus = await geoLocatorPlatform.requestPermission();
      if (permissionStatus == LocationPermission.deniedForever) {
        await openAppSettings();
      }
      return LocationModel(0.0, 0.0, '');
    }
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
    } catch (e) {
      CommonCode().showToast(message: "Error: $e");
    }
    return '';
  }
}
