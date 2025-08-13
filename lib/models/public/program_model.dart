import '../../offline_database/entities/program_entity.dart';

class ProgramModel {
  String id = "";
  String title = "";
  String iconPath = 'assets/icons/programs.png';
  String programDescription = "";
  int borderColorCode = 0xffFFFFFF;

  ProgramModel({
    required this.id,
    required this.title,
    required this.iconPath,
    required this.programDescription,
    required this.borderColorCode,
  });

  ProgramModel.empty();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'program_name': title,
      'iconPath': iconPath,
      'program_description': programDescription,
      'program_theme_color': borderColorCode,
    };
  }

  ProgramModel.fromMap(Map<String, dynamic> map):
        id = map['id'] ?? "",
        title = map['program_name'] ?? "",
        iconPath = "${map['program_image'] ?? ''}",
        programDescription = map['program_description'] ?? "",
        borderColorCode = int.parse(map['program_theme_color'].toString().replaceAll("#", "0xff")) ;

  factory ProgramModel.fromEntity(ProgramEntity entity) {
    return ProgramModel(
      id: entity.id,
      title: entity.title,
      iconPath: entity.iconPath,
      programDescription: entity.programDescription,
      borderColorCode: entity.borderColorCode,
    );
  }

  ProgramEntity toEntity() {
    return ProgramEntity(
      id: id,
      title: title,
      programDescription: programDescription,
      borderColorCode: borderColorCode,
      iconPath: iconPath,
    );
  }
}
