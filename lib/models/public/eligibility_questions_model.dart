import '../../controllers/custom_widget_controllers/custom_radio_button_controller.dart';
import '../../utils/text_field_manager.dart';
import '../item_model.dart';

class EligibilityQuestionModel {
  String id = '';
  String question = '';
  List<ItemModel> options = <ItemModel>[];
  String fieldType = '';
  dynamic fieldController;

  EligibilityQuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.fieldType,
    required this.fieldController,
  });

  EligibilityQuestionModel.empty();

   EligibilityQuestionModel.fromMap(Map<String, dynamic> map) {
      id= map['id'] ?? '';
      question= map['question'] ?? '';
      options= (map['options'] != null) ? List<ItemModel>.from(map['options']) : [];
      fieldType= map['fieldType'] ?? '';
      if(fieldType=='TextField'){
        fieldController =TextFieldManager('');
      }
      if(fieldType=='RadioButton'){
        fieldController= CustomRadioButtonController();
      }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'question': question,
      'options': options.map((option) => option.toJson()).toList(),
      'fieldType': fieldType,
    };
  }
}
