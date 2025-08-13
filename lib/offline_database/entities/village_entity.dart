import 'package:floor/floor.dart';

@entity
class VillageEntity {
  @PrimaryKey()
  final String id;
  final String ucId;
  final String name;

  VillageEntity({
    required this.id,
    required this.ucId,
    required this.name,
  });

  @override
  String toString() {
    return 'VillageEntity{id: $id, ucId: $ucId, name: $name}';
  }
}