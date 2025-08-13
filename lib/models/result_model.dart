/*
Created by afaque ali on 2 jan 2023
*/




class ResultModel {
   String fileName = "";
   String constituencyId='';
   String constituencyImage='';
   String constituencyImageKey='';//image's key code
   String latitude = '';
   String longitude= '';
   String captureTime = '';
  bool isSynced = false;

  ResultModel({required this.constituencyId, required this.constituencyImage, required this.constituencyImageKey,required this.latitude,required this.longitude,required this.captureTime,this.isSynced=false, this.fileName = ""});

   /*Map<String,String> toJson(){
    return {
      'id':UserSession.currentUser.value.id,
      'image':constituencyImage,
      'name':constituencyId,
    };
   }*/

   Map<String, dynamic> toSecureJson() {
    return {
    "fileName" : fileName ,
    "constituencyId" : constituencyId,
    "constituencyImage" : constituencyImage,
    "constituencyImageHashCode" : constituencyImageKey,
    "latitude" : latitude ,
    "longitude" : longitude,
    "captureTime" : captureTime ,
    "isSynced" : isSynced,
    };
  }

  ResultModel.fromSecureJson(Map<String,dynamic> json){
    fileName = json["fileName"];
    constituencyId = json["constituencyId"];
    constituencyImage = json["constituencyImage"];
    constituencyImageKey = json["constituencyImageHashCode"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    captureTime = json["captureTime"];
    isSynced = json["isSynced"];
  }

   @override
  String toString() {
    return 'ResultModel{fileName: $fileName, constituencyId: $constituencyId, constituencyImage: $constituencyImage, latitude: $latitude, longitude: $longitude, captureTime: $captureTime, isSynced: $isSynced}';
  }
}