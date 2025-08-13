

import '../../offline_database/entities/district_entity.dart';

class DistrictModel {
  String id = '';
  String divisionId = '';
  String name = '';

  DistrictModel({
    required this.id,
    required this.divisionId,
    required this.name,
  });

  DistrictModel.empty();

  DistrictModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        divisionId = json['division_id'] ?? '',
        name = json['name'] ?? '';

  Map<String, String> toJson() => {
        'id': id,
        'division_id': divisionId,
        'name': name,
      };
  factory DistrictModel.fromEntity(DistrictEntity entity) {
    return DistrictModel(
      id: entity.id,
      divisionId: entity.divisionId,
      name: entity.name,
    );
  }

  DistrictEntity toEntity() {
    return DistrictEntity(
      id: id,
      divisionId: divisionId,
      name: name,
    );
  }

  @override
  String toString() {
    return name;
  }
}
