import '../models/base_model.dart';


class UserModel extends BaseModel{
  String id = '';
  String name = "";
  String fatherName = "";
  String cnic = "";
  String age = "";
  String email = "";
  String status = "";
  String phoneNumber = "";
  String file = "";
  String role = "";
  String password = "";
  List permissions = [];
  bool isRemembered = false;

  UserModel.empty();

  UserModel.fromJson(Map<String,dynamic> json){
    id = json['user']['id']??'';
    name = json['user']["name"]??"Admin";
    fatherName = json['user']["father_name"]??"";
    cnic = json['user']["cnic"]??"";
    age = json['user']["age"]??"";
    email = json['user']["email"]??"admin@gmial.com";
    status = json['user']["status"]??"";
    phoneNumber = json['user']["phone_number"]??"";
    file = json['user']["file"]??"";
    role = json["role"] ?? "";
    isRemembered = json['is_remembered'] ?? false;
    permissions = json["permissions"] ?? [];
  }

  UserModel.fromOfflineJson(Map<String, dynamic> json) {
    id = '${json['id'] ?? ''}';
    name = '${json["name"] ?? "Admin"}';
    fatherName = '${json["father_name"] ?? ""}';
    cnic = '${json["cnic"] ?? ""}';
    age = '${json["age"] ?? ""}';
    email = '${json["email"] ?? ""}';
    status = '${json["status"] ?? ""}';
    phoneNumber = '${json["phone_number"] ?? ""}';
    file = '${json["file"] ?? ""}';
    isRemembered = json['is_remembered'] ?? false;
    permissions = json["permissions"] ?? [];
  }

  Map<String, dynamic> toOfflineJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "father_ame": fatherName,
      "cnic": cnic,
      "age": age,
      "status": status,
      "phone_number": phoneNumber,
      "file": file,
      "is_remembered": isRemembered,
      "permissions": permissions,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "id" : id,
      "name" : name,
      "email" : email,
      "father_ame" : fatherName,
      "cnic" : cnic,
      "age" : age,
      "status" : status,
      "phone_number" : phoneNumber,
      "file" : file,
      "role" : role,
      "permissions": permissions,
      "is_remembered": isRemembered,
    };
  }

  bool get isEmpty {
    return id.isEmpty;
  }


  bool get isPublicUser => role == "public";
  bool get isAdmin => role == "admin";


  @override
  String toString() {
    return '$name ($role)';
  }

  //========================( Intake Permissions )=====================//
  bool get hasCreateIntakePermission => permissions.contains('intake_registration-create');
  bool get hasViewIntakeListPermission => permissions.contains('intake_registration-show');
}
