 import 'package:get/get.dart';
import '../../models/item_model.dart';

class CustomCheckboxController extends GetxController {
  RxList<ItemModel> selectedOptions = RxList();
  List<ItemModel> options=[];

  CustomCheckboxController({required this.options});

  void toggleOption(ItemModel option) {
    if (selectedOptions.contains(option)) {
      selectedOptions.remove(option);
    } else {
      selectedOptions.add(option);
    }
  }
}
