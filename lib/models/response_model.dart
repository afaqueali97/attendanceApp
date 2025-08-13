/*Created By: Afaque Ali on 15-Aug-2023*/

class ResponseModel {
  int statusCode = -1;
  String statusDescription = "";
  dynamic data ="";

  ResponseModel();
  ResponseModel.named({required this.statusCode, required this.statusDescription, this.data});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    // statusCode = int.parse((json["status_code"]??0).toString());
    statusCode = json["success"]??false ? 200 : 400;
    statusDescription = '${json["message"]??""}';
    data = json["data"];
  }

  @override
  String toString() {
    return 'ResponseModel{statusCode: $statusCode, statusDescription: $statusDescription, data: $data}';
  }
}
