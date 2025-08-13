class ProgramEligibilityPointsModel{
  String id ='';
  String title ='';
  Map<String,List<String>> eligibilityPoints = {};

  ProgramEligibilityPointsModel({required this.id, required this.title, required this.eligibilityPoints});

  ProgramEligibilityPointsModel.empty();

  Map<String,dynamic> toMap(){
    return <String,dynamic>{
      'id': id,
      'title': title,
      'eligibilityPoints': eligibilityPoints
    };
  }

  ProgramEligibilityPointsModel.fromMap(Map<String, dynamic> map){
    id = map['id'] ?? '';
    title = map['title'] ?? '';
    eligibilityPoints = map['eligibilityPoints'] ?? {};
  }
}