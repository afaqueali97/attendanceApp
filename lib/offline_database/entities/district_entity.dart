import 'package:floor/floor.dart';

@entity
class DistrictEntity {
  @primaryKey
  final String id;
  final String divisionId;
  final String name;

  DistrictEntity({
    required this.id,
    required this.divisionId,
    required this.name,
  });

  @override
  String toString() {
    return 'DistrictEntity{id: $id, divisionId: $divisionId name: $name}';
  }
}
