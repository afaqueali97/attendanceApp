import 'dart:developer';
import 'package:audio_session/audio_session.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as r;
import '../../utils/app_colors.dart';
import 'custom_seekbar.dart';

/* Last Modified: Afaque Ali on 20-Oct-2021 */
/* Last Modified: Afaque Ali on 08-Oct-2024 */

class CustomAudioPlayer extends StatefulWidget {
  final String audioFilePath ;
  final bool autoPlay;
  CustomAudioPlayer({super.key, required this.audioFilePath, this.autoPlay = false,});
  @override
  _CustomAudioPlayer createState() => _CustomAudioPlayer();
}

class _CustomAudioPlayer extends State<CustomAudioPlayer>
    with WidgetsBindingObserver {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _player.playbackEventStream
        .listen((event) {}, onError: (Object e, StackTrace stackTrace) {});
    try {
      if (widget.audioFilePath.toLowerCase().contains("https://") ||
          widget.audioFilePath.toLowerCase().contains("http://")) {
        await _player.setUrl(widget.audioFilePath);
      } else if (widget.audioFilePath
              .toLowerCase()
              .contains("storage/emulated") ||
          widget.audioFilePath.toLowerCase().contains("/data/user/")) {
        await _player.setFilePath(widget.audioFilePath);
      } else {
        await _player.setAsset(widget.audioFilePath);
      }
      if (widget.autoPlay) {
        _player.play();
      } else {
        _player.stop();
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _player.stop();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      r.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: kGreyColor, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<PlayerState>(
                  stream: _player.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 40.0,
                        height: 40.0,
                        child: const CircularProgressIndicator(
                            color: kPrimaryColor),
                      );
                    } else if (playing != true) {
                      return IconButton(
                        icon:
                            const Icon(Icons.play_arrow, color: kPrimaryColor),
                        iconSize: 40.0,
                        onPressed: () {
                          _player.play();
                        },
                        splashRadius: 25,
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return IconButton(
                        icon: const Icon(Icons.pause, color: kPrimaryColor),
                        iconSize: 40.0,
                        onPressed: _player.pause,
                        splashRadius: 25,
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(Icons.replay, color: kPrimaryColor),
                        iconSize: 40.0,
                        onPressed: () => _player.seek(Duration.zero),
                        splashRadius: 25,
                      );
                    }
                  },
                ),
                Expanded(
                  child: StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return CustomSeekBar(
                        duration: positionData?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        bufferedPosition:
                            positionData?.bufferedPosition ?? Duration.zero,
                        onChangeEnd: _player.seek,
                      );
                    },
                  ),
                ),
                // Spacer(),
                //Shows us the speed icon and speed bar example
                // Speed Bar Opens..
                IconButton(
                  splashRadius: 20,
                  icon: const Icon(Icons.volume_up, color: kPrimaryColor),
                  onPressed: () {
                    showSliderDialog(
                      context: context,
                      title: "Volume",
                      divisions: 10,
                      min: 0.0,
                      max: 1.0,
                      value: _player.volume,
                      stream: _player.volumeStream,
                      onChanged: _player.setVolume,
                    );
                  },
                ),
                // ControlButtons(_player),
              ],
            ),
          );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;
  const ControlButtons(this.player, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 40.0,
                height: 40.0,
                child: const CircularProgressIndicator(color: kPrimaryColor),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow, color: kPrimaryColor),
                iconSize: 40.0,
                onPressed: () {
                  player.play();
                },
                splashRadius: 25,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause, color: kPrimaryColor),
                iconSize: 40.0,
                onPressed: player.pause,
                splashRadius: 25,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay, color: kPrimaryColor),
                iconSize: 40.0,
                onPressed: () => player.seek(Duration.zero),
                splashRadius: 25,
              );
            }
          },
        ),
        const Spacer(),
        //Shows us the speed icon and speed bar example
        // Speed Bar Opens..
        IconButton(
          splashRadius: 20,
          icon: const Icon(
            Icons.volume_up,
            color: kPrimaryColor,
          ),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
/*
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            splashRadius: 20,
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold,color: Color(kPrimaryColor))),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
*/
      ],
    );
  }
}
