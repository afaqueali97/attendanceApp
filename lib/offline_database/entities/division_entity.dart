 import 'package:floor/floor.dart';

@entity
class DivisionEntity {
  @primaryKey
  final String id;
  final String name;

  DivisionEntity({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    return 'DivisionEntity{id: $id, name: $name}';
  }
}