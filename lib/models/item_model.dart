
import '../offline_database/entities/division_entity.dart';

class ItemModel {
  final String id;
  final String title;

  ItemModel(this.id, this.title);
 
  ItemModel.empty()
      : id = '',
        title = '';
  Map<String, String> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory ItemModel.fromEntity(DivisionEntity entity) {
    return ItemModel(
      entity.id,
      entity.name,
    );
  }

  DivisionEntity toEntity() {
    return DivisionEntity(
      id: id,
      name: title,
    );
  }

  ItemModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        title = json['title'] ?? '';

  @override
  String toString() {
    return title;
  }

}