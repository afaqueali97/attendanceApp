
import '../../offline_database/entities/village_entity.dart';

class VillageModel {
  String id = '';
  String name = '';
  String ucId = '';

  VillageModel({
    required this.id,
    required this.name,
    required this.ucId,
  });

  VillageModel.empty();

  VillageModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        name = json['village_name']?? '',
        ucId = json['uc_id']?? '';

  Map<String, dynamic> toJson() => {
        'village_name': name,
        'id': id,
        'uc_id': ucId,
      };

  VillageEntity toEntity() {
    return VillageEntity(
      id: id,
      ucId: ucId,
      name: name,
    );
  }

  factory VillageModel.fromEntity(VillageEntity entity) {
    return VillageModel(
      id: entity.id,
      ucId: entity.ucId,
      name: entity.name,
    );
  }

  @override
  String toString() {
    return name;
  }
}
