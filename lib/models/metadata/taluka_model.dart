
import '../../offline_database/entities/taluka_entity.dart';

class TalukaModel {
  String id = '';
  String districtId = '';
  String name = '';
  
  TalukaModel({
    required this.id,
    required this.name,
    required this.districtId,
  });

  TalukaModel.empty();

  TalukaModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?? '',
        name = json['name']?? '',
        districtId = json['district_id']?? '';

  Map<String, String> toJson() => {'name': name, 'id': id, 'district_id': districtId};

  TalukaEntity toEntity() {
    return TalukaEntity(
      id: id,
      districtId: districtId,
      name: name,
    );
  }

  factory TalukaModel.fromEntity(TalukaEntity entity) {
    return TalukaModel(
      id: entity.id,
      districtId: entity.districtId,
      name: entity.name,
    );
  }


  @override
  String toString() {
    return name;
  }
}
