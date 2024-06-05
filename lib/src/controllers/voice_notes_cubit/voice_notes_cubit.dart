import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/helper/audio_recerder_file_helper.dart';
import 'package:vedanta_frontend/src/model/voice_note_model.dart';


class VoiceNotesProvider extends ChangeNotifier {
  final AudioRecorderFileHelper audioRecorderFileHelper;
  List<VoiceNoteModel> voiceNotes = [];
  String? errorMessage;

  VoiceNotesProvider(this.audioRecorderFileHelper);

  int get fetchLimit => audioRecorderFileHelper.fetchLimit;

  Future<void> getAllVoiceNotes(int pageKey) async {
    try {
      voiceNotes = await audioRecorderFileHelper.fetchVoiceNotes(pageKey);
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      errorMessage = 'An error occurred: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> deleteRecordFile(VoiceNoteModel voiceNoteModel) async {
    try {
      await audioRecorderFileHelper.deleteRecord(voiceNoteModel.path);
      voiceNotes.remove(voiceNoteModel);
      notifyListeners();
    } catch (e) {
      errorMessage = 'An error occurred: ${e.toString()}';
      notifyListeners();
    }
  }

  void addToVoiceNotes(VoiceNoteModel voiceNoteModel) {
    voiceNotes.add(voiceNoteModel);
    notifyListeners();
  }
}
