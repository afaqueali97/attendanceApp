import '../image_model.dart';
import 'documnet_model.dart';

class UserSurveyFormFiledModel {
  String id = '';
  String uid = '';
  String userName = '';
  String createdAt = '';
  List<SurveyFieldModel> surveyFields = [];
  List<ImageModel> surveyImages = [];
  List<DocumentModel> surveyAudios = [];

  UserSurveyFormFiledModel.empty();
  UserSurveyFormFiledModel({
    required this.id,
    required this.uid,
    required this.createdAt,
    required this.surveyFields,
    required this.surveyImages,
    required this.surveyAudios,
  });

  factory UserSurveyFormFiledModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> surveyImages = (json['survey_image'] ?? []);
    List<dynamic> surveyAudios = (json['survey_audio'] ?? []);
    Map<String, dynamic> surveyFields = (json['survey_fields'] is List || json['survey_fields']==null) ? {}: Map<String, dynamic>.from(json['survey_fields']);
    return UserSurveyFormFiledModel(
      id: json['id'] ?? '',
      uid: json['user_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      surveyFields: surveyFields.entries.map((e) {
        var name = e.key.toString();
        var value = e.value.toString().replaceAll(RegExp(r'[\[\]]'), '');
        return SurveyFieldModel(name: name, value: value);
      }).toList(),
      surveyImages: surveyImages.map((e) => ImageModel.fromJson(e)).toList(),
      surveyAudios: surveyAudios.map((e) => DocumentModel.fromMap(e)).toList(),
    );
  }
}

class SurveyFieldModel {
  String name = '';
  String value = '';

  SurveyFieldModel({required this.name, required this.value});
}
