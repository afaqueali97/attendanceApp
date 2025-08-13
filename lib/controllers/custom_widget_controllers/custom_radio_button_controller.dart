import 'package:get/get.dart';
import '../../models/item_model.dart';

class CustomRadioButtonController extends GetxController {
  var selectedValue = Rx<ItemModel?>(null);
  var errorMessage = ''.obs;

  void setSelectedValue(ItemModel? value) {
    selectedValue.value = value;
    validate();
  }

  bool validate() {
    errorMessage.value = '';
    if (selectedValue.value == null) {
      errorMessage.value='Please select from above options!';
      return false;
    } else {
      return true;
    }
  }
}
