class EMemoModel{
  String id = '';
  String name = '';
  String rank = '';
  String sentDate = '';
  String type = '';

  EMemoModel({required this.id, this.name ='', this.rank='', this.sentDate='', this.type=''});

  EMemoModel.empty();

  Map<String, dynamic> toMap(){
    return <String,dynamic>{
      'id': id,
      'name': name,
      'rank': rank,
      'sentDate': sentDate,
      'type': type
    };
  }

  EMemoModel.fromMap(Map<String,dynamic> map){
    id = map['id'] ?? '';
    name = map['name'] ?? '';
    rank = map['rank'] ?? '';
    sentDate = map['sentDate'] ?? '';
    type = map['type'] ?? '';
  }
}