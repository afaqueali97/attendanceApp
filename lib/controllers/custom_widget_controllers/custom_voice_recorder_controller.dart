import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3_plus/record_mp3_plus.dart';

import '../../models/survey/documnet_model.dart';
import '../../services/web_services/general_service.dart';
import '../../utils/common_code.dart';

/* Created By: Afaque Ali on 04-OCT-2024 */
class CustomVoiceRecorderController extends GetxController {
  String title;
  RxList<DocumentModel> audioFileList = RxList();
  List<RxBool> isAudioLoading = <RxBool>[].obs;
  RxString errorMessage = ''.obs;
  String recordFilePath = "";
  RxBool isRecording = false.obs;
  RxBool isRecorderInit = false.obs;
  bool isBusy = false;
  int i = 0;

  CustomVoiceRecorderController({this.title = 'Audio'});

  void startRecord(String fileName) async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath(fileName);
      if (isRecording.value) {
        stopRecord();
        return;
      } else {
        RecordMp3.instance.start(recordFilePath, (type) {});
      }
      isRecording(!isRecording.value);
    } else {
      isRecording(false);
      CommonCode().showToast(message: 'Permission denied');
    }
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        isRecording(true);
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        isRecording(false);
      }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      log('RecordMp3 -> stop: $recordFilePath');
      audioFileList.add(DocumentModel.empty()..docPath = recordFilePath);
      audioFileList.refresh();
      isRecording(false);
      errorMessage.value = '';
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      log('RecordMp3 -> resume: $recordFilePath');
      isRecording(true);
    }
  }



  void play() {
    if (recordFilePath.isEmpty && File(recordFilePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play(DeviceFileSource(recordFilePath));
    }
  }

   Future<String> getFilePath1(String fileName) async {
    Directory tempDir = await getTemporaryDirectory();  // Get a temporary directory path
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();  // Use current timestamp
    String uniqueFileName = 'file_$timestamp.mp3';  // Create a unique file name
    return path.join(tempDir.path, uniqueFileName);  // Return the complete path
}

  Future<String> getFilePath(String fileName) async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path;
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/$fileName.mp3";
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  bool validate() {
    if (audioFileList.length==1) {
      errorMessage.value = 'Please record audio';
      return false;
    } else {
      errorMessage.value = '';
      return true;
    }
  }

  Future<void> downloadAudio(int index) async {
    isAudioLoading[index].value = true;
    String result = await GeneralService().downloadFile(audioFileList[index].docId,"");
    isAudioLoading[index].value = false;
    if (result.isNotEmpty) {
      audioFileList[index].docPath = result;
      audioFileList.refresh();
    }
  }

  @override
  void onClose() {
    RecordMp3.instance.stop();
    isRecorderInit(false);
    super.onClose();
  }
}