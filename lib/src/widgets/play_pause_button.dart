import 'package:flutter/material.dart';

class PlayPauseAudioButton extends StatelessWidget {
  final bool isPlaying;
  final Function()? onTap;
  const PlayPauseAudioButton(
      {super.key, required this.isPlaying, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 54,
          height: 54,
          padding: EdgeInsets.only(left: isPlaying ? 0 : 4),
          child: isPlaying
              ? const Icon(
                  Icons.pause,
                  size: 32,
                )
              : const Icon(
                  Icons.play_arrow,
                  size: 32,
                ),
        ),
      ),
    );
  }
}
