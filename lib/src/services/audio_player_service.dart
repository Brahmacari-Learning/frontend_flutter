import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> play(String url) async {
    await _audioPlayer.setUrl(url);
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void resume() {
    _audioPlayer.play();
  }

  void stop() {
    _audioPlayer.stop();
  }

  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void setVolume(double volume) {
    _audioPlayer.setVolume(volume);
  }

  Duration? get duration => _audioPlayer.duration;

  void dispose() {
    _audioPlayer.dispose();
  }
}
