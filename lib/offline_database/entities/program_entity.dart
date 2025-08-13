// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:floor/floor.dart';

@entity
class ProgramEntity {
  @primaryKey
  final String id;
  final String title;
  final String iconPath;
  final String programDescription;
  final int borderColorCode;

  ProgramEntity({
    required this.id,
    required this.title,
    required this.iconPath,
    required this.programDescription,
    required this.borderColorCode,
  });

  @override
  String toString() {
    return 'ProgramEntity{id: $id, name: $title, iconPath: $iconPath, programDescription: $programDescription, borderColorCode: $borderColorCode}';
  }
}
