import 'package:flutter/material.dart';

class PlayPauseAudioButton extends StatelessWidget {
  final bool isPlaying;
  final Function()? onTap;
  const PlayPauseAudioButton(
      {Key? key, required this.isPlaying, required this.onTap})
      : super(key: key);

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
              ? Icon(
                  Icons.pause,
                  size: 32,
                )
              : Icon(
                  Icons.play_arrow,
                  size: 32,
                ),
        ),
      ),
    );
  }
}
