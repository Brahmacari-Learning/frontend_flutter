import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/controllers/audio_player_controller.dart';
import 'package:vedanta_frontend/src/widgets/play_pause_button.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String path;
  const AudioPlayerScreen({Key? key, required this.path}) : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final audioPlayerController = AudioPlayerController();
  late final Future loadAudio;
  double? sliderTempValue;

  @override
  void initState() {
    loadAudio = audioPlayerController.loadAudio(widget.path);
    super.initState();
  }

  @override
  void dispose() {
    audioPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadAudio,
      builder: (context, snapshot) {
        return StreamBuilder(
            stream: audioPlayerController.progressStream,
            builder: (context, snapshot) {
              final audioDuration = audioPlayerController.duration.toDouble();
              double progress = (snapshot.data ?? 0).toDouble();
              return Column(
                children: [
                  Slider(
                    value: sliderTempValue ?? progress.clamp(0, audioDuration),
                    min: 0,
                    max: audioDuration,
                    onChanged: (value) {
                      setState(() {
                        sliderTempValue = value;
                      });
                      audioPlayerController.seek(value.toInt());
                    },
                    onChangeStart: (value) {
                      audioPlayerController.pause();
                    },
                    onChangeEnd: (value) {
                      audioPlayerController.seek(value.toInt());
                      sliderTempValue = null;
                      audioPlayerController.play();
                    },
                  ),
                  Text(_formatToDateTime(progress.toInt())),
                  const SizedBox(
                    height: 12,
                  ),
                  StreamBuilder(
                      stream: audioPlayerController.playStatusStream,
                      builder: (context, snapshot) {
                        final bool isPlaying = snapshot.data ?? false;
                        return PlayPauseAudioButton(
                            isPlaying: isPlaying,
                            onTap: () {
                              if (isPlaying) {
                                audioPlayerController.pause();
                              } else {
                                audioPlayerController.play();
                              }
                            });
                      })
                ],
              );
            });
      },
    );
  }

  String _formatToDateTime(int durationInMill) {
    final int minutes = durationInMill ~/ Duration.microsecondsPerMinute;
    final int seconds = (durationInMill % Duration.microsecondsPerMinute) ~/
        Duration.microsecondsPerSecond;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
