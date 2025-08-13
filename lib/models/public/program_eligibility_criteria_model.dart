import 'package:get/get.dart';
import '../../controllers/custom_widget_controllers/custom_checkbox_controller.dart';
import '../../controllers/custom_widget_controllers/custom_radio_button_controller.dart';
import '../../controllers/custom_widget_controllers/dropdown_controller.dart';
import '../../utils/text_field_manager.dart';
import '../../utils/text_filter.dart';
import '../item_model.dart';


class EligibilityCriteriaGroupsModel{
  String programId='';
  String eligibilityCriteriaSetupId='';
  String value='';
  String from ='';
  String to ='';
  String fieldName='';
  String fieldType='';
  dynamic fieldController ='';

  EligibilityCriteriaGroupsModel({
    required this.programId,
    required this.eligibilityCriteriaSetupId,
    required this.value,
    this.from='',
    this.to='',
    this.fieldController,
    required this.fieldName,
    required this.fieldType});

  EligibilityCriteriaGroupsModel.fromMap(Map<String,dynamic> map){
    programId =map['id']??'';
    eligibilityCriteriaSetupId=map['eligibility_criteria_setup_id']??'';
    value=map['value']??'';
    from = map['from']?? '';
    to = map['to']??'';
    fieldName =map['field_name']?? '';
    fieldType= map['field_type']??'';
    fieldController=TextFieldManager(fieldName);
  }

  @override
  String toString() {
    return 'ProgramEligibilityCriteriaGroups{programId: $programId, eligibilityCriteriaSetupId: $eligibilityCriteriaSetupId, value: $value, from: $from, to: $to, fieldName: $fieldName, fieldType: $fieldType, fieldController: $fieldController}';
  }
}

class EligibilityCriteriaSetupModel{
  String id='';
  String fieldName ='';
  String fieldType ='';
  String eligibilityCriteriaId='';
  String programEligibilityCriteriaSetupId ='';
  dynamic fieldController;
  List<ItemModel> criteriaValues=[];

  EligibilityCriteriaSetupModel({
    required this.id,
    required this.fieldName,
    required this.fieldType,
    this.fieldController,
    required this.eligibilityCriteriaId,
    required this.programEligibilityCriteriaSetupId,
    required this.criteriaValues});

  EligibilityCriteriaSetupModel.fromMap(Map<String, dynamic> map){
    id = map['id'];
    fieldName = map['field_name']??'';
    fieldType = map['field_type']??'';
    programEligibilityCriteriaSetupId = map['program_eligibility_criteria_id']??"";
    eligibilityCriteriaId = map['eligibility_criteria_id']??'';
    criteriaValues = (map['criteria_values'] != null) ? List<ItemModel>.from(map['criteria_values']) : [];
    if(fieldType == 'text' ){
      fieldController = TextFieldManager(fieldName,mandatory: true);
    }else if(fieldType == 'range' ){
      fieldController = TextFieldManager(fieldName,filter: TextFilter.decimal,mandatory: true);
    }else if(fieldType == 'dropdown'){
      RxList<dynamic> fieldOptions = RxList<dynamic>.from(criteriaValues);
      fieldController = DropdownController(title: fieldName, items: fieldOptions);
    }else if (fieldType == 'radio') {
      fieldController= CustomRadioButtonController();
    }else if (fieldType == 'checkbox') {
      fieldController = CustomCheckboxController(options: criteriaValues);
    }
  }

  @override
  String toString() {
    return 'ProgramEligibilityCriteriaSetup{id: $id, fieldName: $fieldName, fieldType: $fieldType, eligibilityCriteriaId: $eligibilityCriteriaId, programEligibilityCriteriaSetupId: $programEligibilityCriteriaSetupId, fieldController: $fieldController, criteriaValues: $criteriaValues}';
  }
}

class EligibilityCriteriaModel {
  String id='';
  String provinceFlag='';
  List<EligibilityCriteriaGroupsModel> criteriaGroups=[];
  List<EligibilityCriteriaSetupModel> eligibilityCriteriaSetup=[];

  EligibilityCriteriaModel(
      {required this.id,
        required this.provinceFlag,
        required this.criteriaGroups,
        required this.eligibilityCriteriaSetup});

  EligibilityCriteriaModel.empty();


  @override
  String toString() {
    return 'EligibilityCriteria{id: $id, provinceFlag: $provinceFlag, criteriaGroups: $criteriaGroups, eligibilityCriteriaSetup: $eligibilityCriteriaSetup}';
  }

  EligibilityCriteriaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    provinceFlag = json['province_flag']??'';
    if (json['criteria_groups'] != null) {
      criteriaGroups = <EligibilityCriteriaGroupsModel>[];
      json['criteria_groups'].forEach((v) {
        criteriaGroups.add(EligibilityCriteriaGroupsModel.fromMap(v));
      });
    }
    if (json['eligibility_criteria_setup'] != null) {
      eligibilityCriteriaSetup = <EligibilityCriteriaSetupModel>[];
      json['eligibility_criteria_setup'].forEach((v) {
        eligibilityCriteriaSetup.add(EligibilityCriteriaSetupModel.fromMap(v));
      });
    }
  }

}
