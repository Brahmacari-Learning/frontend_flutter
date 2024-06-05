import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as path;
import 'package:vedanta_frontend/src/helper/audio_recerder_file_helper.dart';
import 'package:vedanta_frontend/src/model/voice_note_model.dart';

class AudioRecorderController extends ChangeNotifier {
  final AudioRecorderFileHelper _audioRecorderFileHelper;
  final Function(String message) onError;

  AudioRecorderController(this._audioRecorderFileHelper, this.onError);

  final AudioRecorder _audioRecorder = AudioRecorder();
  Timer? _timer;
  int _recordDuration = 0;
  RecordState _recordState = RecordState.stop;
  double _amplitude = 0.0;

   Stream<double> get amplitudeStream => _audioRecorder
      .onAmplitudeChanged(const Duration(milliseconds: 160))
      .map((amp) => amp.current);
  Stream<RecordState> get recordStateStream => _audioRecorder.onStateChanged();

  int get recordDuration => _recordDuration;
  RecordState get recordState => _recordState;
  double get amplitude => _amplitude;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _recordDuration++;
      notifyListeners();
    });
  }

  //METHODS
  Future<void> start() async {
    final isMicPermissionGranted = await _checkMicPermissions();

    if (!isMicPermissionGranted) {
      onError("Could not grant mic permission");
      return;
    }

    try {
      final filePath = path.join(
          (await _audioRecorderFileHelper.getRecordsDirectory).path,
          "${DateTime.now().millisecondsSinceEpoch}.m4a");

      await _audioRecorder.start(const RecordConfig(), path: filePath);

      _recordState = RecordState.record;
      _startTimer();
      _audioRecorder
          .onAmplitudeChanged(const Duration(milliseconds: 160))
          .listen((amp) {
        _amplitude = amp.current;
        notifyListeners();
      });
      _audioRecorder.onStateChanged().listen((state) {
        _recordState = state;
        notifyListeners();
      });
      notifyListeners();
    } catch (e) {
      onError("Could not start the record");
    }
  }

  void resume() async {
    _startTimer();
    await _audioRecorder.resume();
    _recordState = RecordState.record;
    notifyListeners();
  }

  Future<void> pause() async {
    _timer?.cancel();
    await _audioRecorder.pause();
    _recordState = RecordState.pause;
    notifyListeners();
  }

  void stop(Function(VoiceNoteModel? voiceNoteModel) onStop) async {
    final recordPath = await _audioRecorder.stop();
    _timer?.cancel();
    _recordState = RecordState.stop;
    if (recordPath != null) {
      onStop(VoiceNoteModel(
        name: path.basename(recordPath),
        createAt: DateTime.now().subtract(Duration(seconds: _recordDuration)),
        path: recordPath,
      ));
    } else {
      onStop(null);
      onError("Could not stop the record");
    }
    _recordDuration = 0;
    notifyListeners();
  }

  Future<void> delete(String filePath) async {
    await pause();

    try {
      await _audioRecorderFileHelper.deleteRecord(filePath);
    } catch (e) {
      onError("Could not delete the record");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<bool> _checkMicPermissions() async {
    const micPermission = Permission.microphone;

    if (await micPermission.isGranted) {
      return true;
    } else {
      final permissionStatus = await micPermission.request();

      if (permissionStatus.isGranted || permissionStatus.isLimited) {
        return true;
      } else {
        return false;
      }
    }
  }
}
