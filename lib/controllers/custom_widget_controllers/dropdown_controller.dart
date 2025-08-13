/* Created By: Afaque Ali on 02-Aug-2023 */

import 'package:get/get.dart';

import '../../utils/user_session.dart';

class DropdownController {

  final RxString errorMessage=''.obs;
  final Rx<dynamic> selectedItem=Rx(null);
  final String title;
  final String hintText;
  final RxList<dynamic> items;

  final bool mandatory;

  DropdownController({required this.title, required this.items, this.mandatory=true,  this.hintText='',});

  bool validate(){
    if(selectedItem.value == null){
      errorMessage.value = mandatory ? "Please select $title" : '';
    } else {
      UserSession.isDataChanged.value = true;
      errorMessage.value = "";
    }
    return errorMessage.isEmpty;
  }

  void setFirstItem(){
    if(items.isNotEmpty) {
      // if (items.length == 1) {
        selectedItem.value = items.first;
      // }
    }
  }

  void clear(){
    items.clear();
    selectedItem.value = null;
  }
}
