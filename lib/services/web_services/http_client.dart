/*Created By: Afaque Ali on 15-Aug-2023*/

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/response_model.dart';
import '../../models/token_model.dart';
import '../../utils/common_code.dart';
import '../../utils/constants.dart';
import '../../utils/user_session.dart';
import 'package:http_parser/http_parser.dart';

class HTTPClient extends GetConnect{
  HTTPClient._internal();
  factory HTTPClient() {
    return _instance;
  }
  static const int _requestTimeOut = 300;
  static final HTTPClient _instance = HTTPClient._internal();

  Future<ResponseModel> postRequest({required String url, dynamic requestBody, bool requireToken = true}) async {
    if(!(await CommonCode().checkInternetConnection())){
      return Future.value(ResponseModel.named(statusCode:602, statusDescription:kNoInternetMsg, data:kNoInternetMsg));
    }

    try {
      Response response = await post(url, requestBody!=null?FormData(requestBody):null,
        headers: requireToken ? /*url.endsWith('login') ? {"Authorization":UserSession.O_TOKEN} :*/ await _getHeaders() :null,
      ).timeout(const Duration(seconds: _requestTimeOut));

      log('POST───────────────────Request.body> $requestBody');
      log('POST───────────────────Response.body> $url\n${response.body}');

      ResponseModel responseModel = ResponseModel.fromJson(response.body is Map ?response.body : jsonDecode(response.body));
      return responseModel;
    } on TimeoutException {
      return Future.value(ResponseModel.named(statusCode: 408, statusDescription: "Request TimeOut", data: kPoorInternetConnection));
    } on SocketException {
      return Future.value(ResponseModel.named(statusCode: 400, statusDescription: "Bad Request", data: kNetworkError));
    } catch (e) {
      if(!(await CommonCode().checkInternetAccess())){
        return Future.value(ResponseModel.named(statusCode:602, statusDescription:kPoorInternetConnection, data:kPoorInternetConnection));
      }
      return Future.value(ResponseModel.named(statusCode:500, statusDescription:kServiceError, data: kServiceError));
    }
  }


  Future<ResponseModel> getRequest({required String url, Map<String, String> params =const{}, bool requireToken = true}) async {

    if(params.isNotEmpty){
      log('───────────────────Get> $params');
      url ='$url?';
      for(MapEntry<String, String> p in params.entries){
        url = '$url${p.key}=${p.value}&';
      }
      url = url.substring(0,url.length-1);
    }

    try {
      if(!(await CommonCode().checkInternetConnection())){
        return Future.value(ResponseModel.named(statusCode:602, statusDescription:kNoInternetMsg, data:kNoInternetMsg));
      }

      Response response = await get(url, headers: requireToken ?  await _getHeaders(): null).timeout(const Duration(seconds: _requestTimeOut));
      log('───────────────────Get> $url\n${response.body}');

      ResponseModel responseModel = ResponseModel.fromJson(response.body is Map ?response.body : jsonDecode(response.body));
      return responseModel;
    } on TimeoutException {
      return Future.value(ResponseModel.named(statusCode: 408, statusDescription: "Request TimeOut", data: kPoorInternetConnection));
    } on SocketException {
      return Future.value(ResponseModel.named(statusCode: 400, statusDescription: "Bad Request", data: kNetworkError));
    } catch (e) {
      if(!(await CommonCode().checkInternetAccess())){
        return Future.value(ResponseModel.named(statusCode:602, statusDescription:kPoorInternetConnection, data:kPoorInternetConnection));
      }
      return Future.value(ResponseModel.named(statusCode:500, statusDescription:kServiceError, data: kServiceError));
    }
  }


  Future<ResponseModel> postMultipartRequest({required String url, Map<String, String> fields =const{}, Map<String, String> files =const{}}) async {
    if(!(await CommonCode().checkInternetConnection())){
      return Future.value(ResponseModel.named(statusCode:602, statusDescription:kNoInternetMsg, data:kNoInternetMsg));
    }
    try {
      Map<String, String> customHeader = await _getHeaders();
      // customHeader['Connection'] = 'keep-alive';
      // customHeader['Accept'] = 'application/json';
      // customHeader['Content-Type'] = 'multipart/form-data';
      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll(customHeader);
      request.fields.addAll(fields);

      for(MapEntry<String, String> file in files.entries){
        String type = file.value.substring(file.value.lastIndexOf('.')+1);
        String name = file.value.substring(file.value.lastIndexOf('/')+1);

        // if (file.value.startsWith("http")) {
        //   String path = await CommonCode().saveImage(url: file.value);
        //   request.files.add(await http.MultipartFile.fromPath(
        //     file.key, path,
        //     filename: name,
        //     contentType: MediaType('image', type),
        //   ));
        // } else{
        //   request.files.add(await http.MultipartFile.fromPath(
        //     file.key, file.value,
        //     filename: name,
        //     contentType: MediaType('image', type),
        //   ));
        // }
      // }
        request.files.add(await http.MultipartFile.fromPath(
          file.key, file.value,
          filename: name,
          contentType: MediaType('image', type),
        ));
      }
      log('Multipart────────────────────url> $url');
      log('Multipart────────────────────files> $files');
      log('Multipart────────────────────fields> $fields');

      http.StreamedResponse streamedResponse=await request.send();
      http.Response httpResponse=await http.Response.fromStream(streamedResponse);

      log('Multipart────────────────────Response.body> ${httpResponse.body}');
      ResponseModel response=ResponseModel.fromJson(jsonDecode(httpResponse.body));
      return Future.value(response);

    } on TimeoutException {
      log('Exception────────────────────> ');
      return Future.value(ResponseModel.named(statusCode: 408, statusDescription: "Request TimeOut", data: "Request TimeOut"));
    } on SocketException {
      log('Exception────────────────────> e');
      return Future.value(ResponseModel.named(statusCode: 400, statusDescription: "Bad Request", data: "Bad Request"));
    } catch (e) {
      log('Exception────────────────────> $e');
      if(!(await CommonCode().checkInternetAccess())){
        return Future.value(ResponseModel.named(statusCode:602, statusDescription:kPoorInternetConnection, data:kPoorInternetConnection));
      }
      return Future.value(ResponseModel.named(statusCode:500, statusDescription:kServiceError, data: kServiceError));
    }
  }


  // Future<File> loadNetworkImage(String url)async {
  //
  //   _saveNetworkImage() async {
  //     var response = await Dio().get(
  //         "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg",
  //         options: Options(responseType: ResponseType.bytes));
  //     final result = await ImageGallerySaver.saveImage(
  //         Uint8List.fromList(response.data),
  //         quality: 60,
  //         name: "hello");
  //     print(result);
  //   }
  //   return file;
  // }

  Future<ResponseModel> deleteRequest({required String url, Map<String, String> params =const{}, bool requireToken = true}) async {

    if(params.isNotEmpty){
      log('───────────────────Get> $params');
      url ='$url?';
      for(MapEntry<String, String> p in params.entries){
        url = '$url${p.key}=${p.value}&';
      }
      url = url.substring(0,url.length-1);
    }

    try {
      if(!(await CommonCode().checkInternetConnection())){
        return Future.value(ResponseModel.named(statusCode:602, statusDescription:kNoInternetMsg, data:kNoInternetMsg));
      }

      http.Response response = await http.delete(Uri.parse(url), headers: requireToken ?  await _getHeaders(): null);
      log('───────────────────Delete> $url\n${response.body}');

      ResponseModel responseModel = ResponseModel.fromJson(response.body is Map ?response.body : jsonDecode(response.body));
      return responseModel;
    } on TimeoutException {
      return Future.value(ResponseModel.named(statusCode: 408, statusDescription: "Request TimeOut", data: kPoorInternetConnection));
    } on SocketException {
      return Future.value(ResponseModel.named(statusCode: 400, statusDescription: "Bad Request", data: kNetworkError));
    } catch (e) {
      if(!(await CommonCode().checkInternetAccess())){
        return Future.value(ResponseModel.named(statusCode:602, statusDescription:kPoorInternetConnection, data:kPoorInternetConnection));
      }
      return Future.value(ResponseModel.named(statusCode:500, statusDescription:kServiceError, data: kServiceError));
    }
  }
}

Future<Map<String, String>> _getHeaders() async {

  TokenModel? token = await UserSession().getToken();
  /*if(token.isExpired){
    if(ProgressDialog().isOpened){
      ProgressDialog().dismissDialog();
    }
    await UserSession().logout();
    CustomDialogs().showDialog('Alert', kSessionExpireMsg, DialogType.warning, onOkBtnPressed: (){
      Get.offAllNamed(kLoginScreenRoute);
    });
    return {};
  }
  else */if(token.accessToken.isNotEmpty) {
    return {'Authorization': 'Bearer ${token.accessToken}'};
  }
  else{
    return {};
  }
}



