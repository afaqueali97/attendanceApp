import '../models/item_model.dart';
import '../models/user_model.dart';

class DummyData {
  static bool debugMode = true;


  static UserModel loginUser() {
    return UserModel.fromJson({
      "id":'1',
      "name":'Amjad',
      "email":'amjadjamali@gmail.com',
      "group_id":'1',
      "district_id":'235sdgb-egy45yhy-34y4g34y',
    });
 }

 static List<ItemModel> getGenderData(){
  return [
    ItemModel("male", "Male"),
    ItemModel("female", "Female"),
    ItemModel("transgender", "Transgender"),

  ];
 }


}
