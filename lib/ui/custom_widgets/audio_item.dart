
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/common_code.dart';
import 'audio_box.dart';

class AudioItem extends StatefulWidget {
  final String message;
  final VoidCallback? onCancel;
  const AudioItem({
    super.key,
    required this.message,
    this.onCancel,
  });

  @override
  State<AudioItem> createState() => _AudioItemState();
}

class _AudioItemState extends State<AudioItem> {
  RxBool isPlaying = false.obs;
  Rx<Duration> progress = Duration.zero.obs;
  Duration totalDuration = Duration.zero;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      await audioPlayer.setSource(UrlSource(widget.message));
      audioPlayer.onDurationChanged.listen((event) {
        totalDuration = event;
      });
      audioPlayer.onPlayerComplete.listen((event) {
        isPlaying.value = false;
      });
    } catch (e) {
      CommonCode().showToast(message: e.toString());
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                if (isPlaying.value) {
                  await audioPlayer.pause();
                  isPlaying.value = false;
                } else {
                  await audioPlayer.play(DeviceFileSource(widget.message));
                  audioPlayer.onPositionChanged.listen((event) {
                    progress.value = event;
                  });
                  isPlaying.value = true;
                }
              },
              icon: Obx(
                    () => Icon(
                  isPlaying.value ? Icons.pause_circle : Icons.play_circle,
                  color: kPrimaryColor,
                  size: 28,
                ),
              ),
            ),
          ),
          Obx(
                () => AudioBox(
              audioTimelength: progress.value,
              audioPlayStatus: isPlaying.value,
            ),
          ),
          Flexible(
            child: IconButton(
              onPressed: () {
                isPlaying.value = false;
                widget.onCancel!();
              },
              icon: const Icon(
                Icons.restart_alt,
                color: kPrimaryColor,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}