import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/* Created By: Afaque Ali on 04-OCT-2024 */
class AudioBox extends StatefulWidget {
  final Duration audioTimelength;
  final bool audioPlayStatus;

  const AudioBox({
    super.key,
    this.audioTimelength = const Duration(),
    this.audioPlayStatus = false,
  });

  @override
  State<AudioBox> createState() => _AudioBoxState();
}

class _AudioBoxState extends State<AudioBox> {
  @override
  Widget build(BuildContext context) {
    bool iconSwitchStatus = false;

    Widget audioFrequencyStatusWidget({Function? callback}) {
      Future.delayed(const Duration(seconds: 1), () {
        if (widget.audioPlayStatus && callback != null) {
          callback();
        }
      });

      if (!widget.audioPlayStatus && iconSwitchStatus) {
        iconSwitchStatus = false;
      }

      Icon icon = Icon(iconSwitchStatus ? Icons.volume_down : Icons.volume_up,
          size: 25, color:  kPrimaryColor);

      return icon;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 25,
          height: 25,
          child: StatefulBuilder(builder: ((context, setState) {
            return audioFrequencyStatusWidget(callback: () {
              iconSwitchStatus = !iconSwitchStatus;
              setState(() {});
            });
          })),
        ),
        const SizedBox(width: 5),
        const Icon(
          Icons.multitrack_audio_outlined,
          size: 28,
          color: kPrimaryColor,
        ),
        const SizedBox(width: 10),
        Transform.translate(
          offset: const Offset(-10, 0),
          child: const Icon(
            Icons.multitrack_audio_rounded,
            size: 28,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(width: 10),
        Transform.translate(
          offset: const Offset(-20, 0),
          child: const Icon(
            Icons.multitrack_audio_rounded,
            size: 28,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(width: 10),
        Transform.translate(
          offset: const Offset(-30, 0),
          child: const Icon(
            Icons.multitrack_audio_rounded,
            size: 28,
            color: kPrimaryColor,
          ),
        ),
        // if (widget.audioTimelength != Duration.zero)
        Container(
          constraints: const BoxConstraints(maxWidth: 50),
          child: Text(
            "${widget.audioTimelength.inMinutes}:${widget.audioTimelength.inSeconds}",
            style: const TextStyle(fontSize: 18, color:kPrimaryColor),
          ),
        ),
        //
      ],
    );
  }
}