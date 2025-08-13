import 'package:floor/floor.dart';

@entity
class TalukaEntity {
  @PrimaryKey()
  final String id;
  final String districtId;
  final String name;

  TalukaEntity({
    required this.id,
    required this.districtId,
    required this.name,
  });

  @override
  String toString() {
    return 'TalukaEntity{id: $id, districtId: $districtId, name: $name}';
  }
}
