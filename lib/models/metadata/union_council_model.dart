
import '../../offline_database/entities/uc_entity.dart';

class UnionCouncilModel {
  String id = '';
  String name = '';
  String talukaId = '';

  UnionCouncilModel({
    required this.id,
    required this.name,
    required this.talukaId,
  });

  UnionCouncilModel.empty();

  UnionCouncilModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        name = json['name'] ?? '',
        talukaId = json['tehsil_id'] ?? '';

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'tehsil_id': talukaId,
      };

  UCEntity toEntity() {
    return UCEntity(
      id: id,
      talukaId: talukaId,
      name: name,
    );
  }

  factory UnionCouncilModel.fromEntity(UCEntity entity) {
    return UnionCouncilModel(
      id: entity.id,
      talukaId: entity.talukaId,
      name: entity.name,
    );
  }

  @override
  String toString() {
    return name;
  }
}
