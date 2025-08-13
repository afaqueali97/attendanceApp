
import '../../offline_database/entities/division_entity.dart';

class DivisionModel {
  String id = '';
  String name = '';

  DivisionModel({
    required this.id,
    required this.name,
  });

  DivisionModel.empty();

  DivisionModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        name = json['name'] ?? '';

  Map<String, String> toJson() => {
        'id': id,
        'name': name,
      };
  factory DivisionModel.fromEntity(DivisionEntity entity) {
    return DivisionModel(
      id: entity.id,
      name: entity.name,
    );
  }

  DivisionEntity toEntity() {
    return DivisionEntity(
      id: id,
      name: name,
    );
  }

  @override
  String toString() {
    return name;
  }
}
