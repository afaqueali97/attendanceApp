import 'package:get/get.dart';
import '../../controllers/custom_widget_controllers/browse_image_controller.dart';
import '../../controllers/custom_widget_controllers/custom_checkbox_controller.dart';
import '../../controllers/custom_widget_controllers/custom_location_controller.dart';
import '../../controllers/custom_widget_controllers/custom_radio_button_controller.dart';
import '../../controllers/custom_widget_controllers/custom_voice_recorder_controller.dart';
import '../../controllers/custom_widget_controllers/dropdown_controller.dart';
import '../../utils/date_time_manager.dart';
import '../../utils/field_type.dart';
import '../../utils/text_field_manager.dart';
import '../../utils/text_filter.dart';
import '../item_model.dart';
import 'documnet_model.dart';

class FormFieldModel{
  String id='';
  String fieldName='';
  String fieldType='';
  String slug='';
  String formId='';
  String value ='';
  List<ItemModel> options =[];
  String textType='';
  double from=0;
  double to=0;
  int length=0;
  dynamic fieldController;

  FormFieldModel(
      {required this.id, required this.fieldName, required this.fieldType, required this.slug, required this.options,required this.value,required this.formId,required this.textType,required this.length, required this.from,required this.to});

  FormFieldModel.empty();

  FormFieldModel.fromMap(Map<String, dynamic> map) {
    id= map['id'] ?? '';
    fieldName= map['field_name'] ?? '';
    slug= map['slug'] ?? '';
    value =map['field_value']??'';
    formId =map['formId']??'';
    from = double.tryParse('${map['from']}')??0;
    to = double.tryParse('${map['to']}')??0;
    List<dynamic> optionsData= map['options'] ?? [];
    options= List<ItemModel>.from(optionsData.map((item) => ItemModel(optionsData.indexOf(item).toString(), item.toString())));
    // if(optionsData is String){
    //   List<dynamic> opt = jsonDecode(map['options']);
    //   options = opt.map((option) => ItemModel(option, option)).toList();
    // } else {
    //   options= List<ItemModel>.from(optionsData);
    // }
        
    fieldType= map['field_type']!=null? map['field_type'].toString().toLowerCase(): '';
    textType= map['text_type'] ?? '';
    length = int.tryParse('${map['length']}') ?? 0;
    if(fieldType== FieldType.text.name){
      fieldController = TextFieldManager(fieldName.capitalizeFirst.toString(),filter:textType!=''?getFilter():TextFilter.none,length: length);
    }
    if(fieldType== FieldType.mobile.name){
      fieldController = TextFieldManager(fieldName.capitalizeFirst.toString(),filter: TextFilter.mobile);
    }
    if(fieldType== FieldType.cnic.name){
      fieldController = TextFieldManager(fieldName.capitalizeFirst.toString(),filter: TextFilter.cnic);
    }
    if(fieldType== FieldType.email.name){
      fieldController = TextFieldManager(fieldName.capitalizeFirst.toString(),filter: TextFilter.email);
    }
    if(fieldType==FieldType.radio.name){
      fieldController= CustomRadioButtonController();
    }
    if(fieldType==FieldType.checkbox.name){
      fieldController= CustomCheckboxController(options: options);
    }
    if(slug==FieldType.image.name){
      fieldController = BrowseImageController(title: fieldName,maxLength: 3);
    }
    if(fieldType==FieldType.dropdown.name){
      fieldController = DropdownController(title: fieldName, items: options.obs);
    }
    if(fieldType== FieldType.range.name){
      fieldController =TextFieldManager(fieldName.capitalizeFirst.toString(),filter: TextFilter.decimal,length: 10);
    }
    if(fieldType==FieldType.date.name){
      fieldController = DateTimeManager(fieldName,firstDate: DateTime(DateTime.now().year-100),lastDate:DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    }
    if(slug==FieldType.audio.name){
      fieldController = CustomVoiceRecorderController();
      fieldController.audioFileList.add(DocumentModel.empty());
      
    }
    if(fieldType==FieldType.location.name){
      fieldController = CustomLocationController(locationTfManager: TextFieldManager(fieldName, filter: TextFilter.alphaNumeric, length: 50));
    }
  }


  @override
  String toString() {
    return 'FormFieldModel{id: $id, fieldName: $fieldName, fieldType: $fieldType, slug: $slug, formId: $formId, value: $value, options: $options, textType: $textType, from: $from, to: $to, length: $length}';
  }

  TextFilter getFilter() {
    switch (textType) {
      case 'text':
        return TextFilter.name;
      case 'number':
        return TextFilter.number;
      case 'decimal':
        return TextFilter.decimal;
      case 'mobile':
        return TextFilter.mobile;
      case 'email':
        return TextFilter.email;
      case 'cnic':
        return TextFilter.cnic;
      case 'open':
        return TextFilter.none;
      default:
        return TextFilter.none;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'fieldName': fieldName,
      'fieldType': fieldType,
      'slug': slug,
      'value': value,
      'options': options.map((item) => item.title).toList(),
      'textType': textType,
      'length': length,
      'from': from,
      'to': to
    };
  }

  Map<String, String> toStoreUserFormJson() {
    return {
      fieldType: value,
    };
  }


}
