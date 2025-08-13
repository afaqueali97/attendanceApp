
import 'dart:developer';

import '../../models/response_model.dart';
import '../../models/token_model.dart';
import '../../models/user_model.dart';
import '../../services/service_urls.dart';
import '../../services/web_services/http_client.dart';
import '../../utils/user_session.dart';

class UserService{

  static final UserService _instance = UserService._internal();
  UserService._internal(){
    _httpClient = HTTPClient();
  }
  factory UserService()=>_instance;

  late HTTPClient _httpClient;



  Future<UserModel> loginUser({required String username, required String password})async{
    UserModel user = UserModel.empty();
    Map<String, String> body = {
      'email': username,
      'password':password
    };
    try {
      ResponseModel responseModel = await _httpClient.postRequest(url: kLoginURL, requestBody: body, requireToken: false);
      if(responseModel.statusCode == 200 && responseModel.data != null && responseModel.data['token'] != null ){
        user = UserModel.fromJson(responseModel.data??{});
        log('------------------${user.permissions.contains('complaint_type-create')}');
       await UserSession().saveToken(token: TokenModel.fromString(responseModel.data['token']??''));
      }else{
        user.responseMessage = responseModel.statusDescription;
      }
    } on Exception catch (e) {
      log("-===================$e");
    }
    return user;
  }
  Future<String> registerUser({required UserModel user})async{
    String response = "";
    Map<String, String> body = {
      'email': user.email,
      'password':user.password
    };
    try {
      ResponseModel responseModel = await _httpClient.postRequest(url: kLoginURL, requestBody: body, requireToken: false);
      if(responseModel.statusCode == 200 && responseModel.data != null && responseModel.data['token'] != null ){
        response = "Success";
      }else{
        response = responseModel.statusDescription;
      }
    } on Exception catch (e) {
      log("-===================$e");
    }
    return response;
  }
}