import 'package:get/get.dart';
import '../../models/location_model.dart';
import '../../utils/location_checker.dart';
import '../../utils/text_field_manager.dart';

class CustomLocationController extends GetxController {
  CustomLocationController({required this.locationTfManager});

  final TextFieldManager locationTfManager;

  Future<void> onLoadLocation() async {
    locationTfManager.controller.text = 'loading...';
    LocationModel location = await LocationChecker().currentLocation();
    if (location.isNotEmpty) {
      // locationTfManager.controller.text ='${location.latitude.toString()}, ${location.longitude.toString()}';
      locationTfManager.controller.text = location.address;
    } else {
      locationTfManager.controller.text = '';
    }
    locationTfManager.validate();
  }
  
  bool validate() {
    if (locationTfManager.validate()) {
      return true;
    } else {
      return false;
    }
  }
}
