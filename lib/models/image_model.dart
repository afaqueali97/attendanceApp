import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';


class ImageModel {
   String id='';
   String filePath='';
   String name='';
   String createdAt='';
   String createdBy = '';
   String mediaType = '';
   String imageData = '';
   String deletedAt = '';
   String deletedBy = '';
   bool isSynced = false;

  ImageModel({
    required this.id,
    required this.filePath,
    this.createdAt = '',
    this.name = '',
    this.mediaType = '',
    this.createdBy = '',
    this.imageData = '',
    this.isSynced = false,
  });
  ImageModel.empty();

   ImageModel copyWith({
     String? id,
     String? filePath,
     String? name,
     String? createdAt,
     String? createdBy,
     String? mediaType,
     String? imageData,
   }) {
     return ImageModel(
       id: id ?? this.id,
       filePath: filePath ?? this.filePath,
       name: name ?? this.name,
       createdAt: createdAt ?? this.createdAt,
       createdBy: createdBy ?? this.createdBy,
       mediaType: mediaType ?? this.mediaType,
       imageData: imageData ?? this.imageData,
     );
   }

  ImageModel.fromJson(Map<String, dynamic> json):
    id = json['id']??'',
    filePath = json['file_path'] ?? '',
    createdAt = json['created_at'] ??'',
    mediaType = json['media_type'] ?? '',
    name = json['file_name'] ??'',
    isSynced = true;


  Map<String, String> toJson(){
    return {
      'id': id,
      'file_path':filePath,
    };
  }



   // Convert from an entity to a model


   Future<String> downloadAndEncodeImage(String url,) async {
     try {
       http.Response response = await http.get(Uri.parse(url));
       // log("----------------------------${response.body}");
       if (response.statusCode == 200) {
         Uint8List compressedBytes = response.bodyBytes;
         // log("-------------->>>>>[IMAGE]:BEFORE/Compression:: -------------------------- ${response.bodyBytes.length}");
         if(compressedBytes.length> 1200000) {
           compressedBytes = await FlutterImageCompress.compressWithList(response.bodyBytes, quality: 60, format: CompressFormat.jpeg);
           // log("------------>>>>>[IMAGE]:AFTER/Compression:: -------------------------- ${compressedBytes.length}");
         }
         // log("===>>>>> Not/Compressed:: ${compressedBytes.length}");


         return base64Encode(compressedBytes);
       } else {
         return '';
         // throw Exception('Failed to download image. Status code: ${response.statusCode}');
       }
     } on Exception catch (error) {
       log('EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE: $error');
       return ''; // Consider returning null or rethrowing the error.
     }
   }


  Uint8List get imageEncoded {
    if(imageData.isNotEmpty) {
      // File file = File(filePath);
      return const Base64Decoder().convert(filePath);
      // return uint8list;
    }else{
      return Uint8List(0);
    }
  }

  Future<String> get getFilePath async {
    try {
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}$name').create();
      file.writeAsBytesSync(imageEncoded);
      return file.path;
    }catch(e) {
      log(
          "///////////////////////////////////////////////////////////////$e");
      return '';
    }
  }
   Future<String> saveImageToFile(String name, String imageEncoded) async {
     try {

       Directory appDocDirectory = await getApplicationDocumentsDirectory();

       String filePath = '${appDocDirectory.path}/dir';

       // Convert base64 string to Uint8List
       Uint8List imageBytes = base64Decode(imageEncoded);

       // Write bytes to file
       File file = File(filePath);
       if(file.existsSync() && file.path.isNotEmpty) {
         file.writeAsBytes(imageBytes);
       } else{
         file = await File(filePath).create(recursive: true);
         file.writeAsBytes(imageBytes);
       }
       return filePath;
     } catch (e) {
       log('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& Error saving image: $e');
       return '';
     }
   }

   String toFloor() {
     Map<String, dynamic> file = <String, dynamic>{
       'imageId': id,
       'path': filePath,
       'imageData': imageData,
       'createdBy': createdBy,
       'name': name,
       'mediaType': mediaType,
       'createdAt': createdAt,
     };
     try{
       return jsonEncode(file);
     } catch(_) {
       return '';
     }
   }

   // Convert from an entity to a model
   ImageModel.fromFloor(String image) {
     Map<String, dynamic> data = jsonDecode(image);
     id= data['imageId'] ??'';
     filePath= data['path'] ?? '';
     imageData= data['imageData'] ??'';
     createdBy= data['createdBy'] ??'';
     name= data['name'] ??'';
     mediaType= data['mediaType'] ??"";
     createdAt= data['createdAt'] ??'';

   }

  @override
  String toString() {
    return filePath;
  }

}