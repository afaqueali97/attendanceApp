import 'package:floor/floor.dart';

@entity
class UCEntity {
  @PrimaryKey()
  final String id;
  final String talukaId;
  final String name;

  UCEntity({
    required this.id,
    required this.talukaId,
    required this.name,
  });

  @override
  String toString() {
    return 'UCEntity{id: $id, talukaId: $talukaId, name: $name}';
  }
}