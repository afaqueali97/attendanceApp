import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class DocumentModel{
  String docId = '';
  String docName = '';
  String docType = '';
  String docFieldType = '';
  String docSize = '';
  String docPath = '';

  DocumentModel({
    required this.docId,
    required this.docName,
    required this.docType,
    required this.docFieldType,
    required this.docSize,
    required this.docPath,
  });

  DocumentModel.empty();

  DocumentModel.fromMap(Map<String, dynamic> map) {
    docId = map['id'] ?? '';
    docName = map['doc_name'] ?? '';
    docType = map['doc_type'] ?? '';
    docFieldType = map['model_type'] ?? '';
    docSize = map['doc_size'] ?? '';
    docPath = map['doc_content'] ?? '';
  }

  Uint8List get docBase64Encoded {
    if(docPath.isNotEmpty) {
      return const Base64Decoder().convert(docPath);
    }else{
      return Uint8List(0);
    }
  }

  Future<String> get getFilePath async {
    try {
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}$docName').create();
      file.writeAsBytesSync(docBase64Encoded);
      return file.path;
    }catch(e) {
      log(
          "///////////////////////////////////////////////////////////////$e");
      return '';
    }
  }
}