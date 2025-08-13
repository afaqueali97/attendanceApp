
class FormModel{
  String id='';
  String formName='';
  String createdAt='';
  

  FormModel({required this.id, required this.formName,required this.createdAt});

  FormModel.empty();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'form_name': formName,
      'created_at': createdAt,
    };
  }

  FormModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        formName = json['form_name'] ?? '',
        createdAt = json['created_at'];

  @override
  String toString() {
    return 'AdminFormModel{id: $id, formName: $formName, createdAt: $createdAt}';
  }
}