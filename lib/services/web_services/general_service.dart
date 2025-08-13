import '../../models/image_model.dart';
import '../../models/version_check_model.dart';

import '../../models/response_model.dart';
import '../../models/survey/documnet_model.dart';
import 'http_client.dart';
import '../service_urls.dart';

class GeneralService {
  late HTTPClient _httpClient;

  GeneralService._internal() {
    _httpClient = HTTPClient();
  }

  factory GeneralService() {
    return _instance;
  }
  static final GeneralService _instance = GeneralService._internal();

  Future<VersionCheckModel> getVersionData() async {
    ResponseModel responseModel = await _httpClient.getRequest(url: kVersionCheckURL,requireToken: false);
    if (responseModel.statusCode == 200 && responseModel.data!=null && responseModel.data.isNotEmpty) {
      VersionCheckModel versionCheckModel = VersionCheckModel.fromJson(responseModel.data is List  ? responseModel.data.first : responseModel.data);
      return versionCheckModel;
    } else {
      return VersionCheckModel.empty();
    }
  }

  Future<ImageModel> getDocById(String docId, String kGetDocumentByIdURL) async {
    ImageModel imageModel = ImageModel.empty();
    ResponseModel responseModel = await _httpClient.postRequest(
        url: kGetDocumentByIdURL,
        requestBody: {'document_id': docId},
        requireToken: true);
    if (responseModel.statusDescription == 'Survey media found.') {
      imageModel = ImageModel.fromJson(responseModel.data);
    }
    return imageModel;
  }

  Future<String> downloadFile(String docId, String urlOfFile) async {
    String path = '';
    ResponseModel responseModel = await _httpClient.postRequest(
        url: urlOfFile,
        requestBody: {'document_id': docId},
        requireToken: true);
    if (responseModel.statusDescription == 'Survey media found.') {
      DocumentModel documentModel = DocumentModel.fromMap(responseModel.data);
      path = await documentModel.getFilePath;
    }
    return path;
  }

}
