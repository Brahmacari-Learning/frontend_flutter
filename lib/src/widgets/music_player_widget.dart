import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/services/audio_player_service.dart';

class MusicPlayerWidget extends StatefulWidget {
  final String url;

  const MusicPlayerWidget({super.key, required this.url});

  @override
  State<MusicPlayerWidget> createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  late AudioPlayerService _audioPlayerService;
  bool _isPlaying = false;
  double _currentVolume = 0.5;
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayerService = AudioPlayerService();
    _audioPlayerService.play(widget.url);

    _audioPlayerService.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayerService.playerStateStream.listen((playerState) {
      setState(() {
        _isPlaying = playerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Slider(
          value: _currentPosition.inSeconds.toDouble(),
          min: 0,
          max: (_audioPlayerService.duration?.inSeconds.toDouble() ?? 1),
          onChanged: (value) {
            _audioPlayerService.seek(Duration(seconds: value.toInt()));
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                if (_isPlaying) {
                  _audioPlayerService.pause();
                } else {
                  _audioPlayerService.resume();
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: () {
                _audioPlayerService.stop();
              },
            ),
            Expanded(
              child: Slider(
                value: _currentVolume,
                min: 0,
                max: 1,
                onChanged: (value) {
                  setState(() {
                    _currentVolume = value;
                  });
                  _audioPlayerService.setVolume(value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
