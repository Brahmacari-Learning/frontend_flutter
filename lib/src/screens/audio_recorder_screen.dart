import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:vedanta_frontend/src/controllers/audio_recorder_controller.dart';
import 'package:vedanta_frontend/src/helper/audio_recerder_file_helper.dart';
import 'package:vedanta_frontend/src/screens/audio_waves.dart';
import 'package:vedanta_frontend/src/widgets/play_pause_button.dart';

class AudioRecorderView extends StatelessWidget {
  const AudioRecorderView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AudioRecorderController>(
      create: (context) => AudioRecorderController(
        AudioRecorderFileHelper(),
        (message) {
          print(message);
        },
      )..start(),
      child: const _AudioRecorderViewBody(),
    );
  }
}

class _AudioRecorderViewBody extends StatefulWidget {
  const _AudioRecorderViewBody({super.key});

  @override
  State<_AudioRecorderViewBody> createState() => _AudioRecorderViewBodyState();
}

class _AudioRecorderViewBodyState extends State<_AudioRecorderViewBody> {
  @override
  void dispose() {
    context.read<AudioRecorderController>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AudioWavesView(),
        const SizedBox(height: 16),
        const _TimerText(),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            GestureDetector(
              onTap: () {
                context.read<AudioRecorderController>().stop((voiceNoteModel) {
                  Navigator.pop(context, voiceNoteModel);
                });
              },
              child: const Text(
                "Simpan",
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 18,
                ),
              ),
            ),
            const Spacer(),
            Consumer<AudioRecorderController>(
              builder: (context, audioRecorderService, child) {
                return PlayPauseAudioButton(
                  isPlaying:
                      audioRecorderService.recordState == RecordState.record,
                  onTap: () {
                    if (audioRecorderService.recordState == RecordState.pause) {
                      audioRecorderService.resume();
                    } else {
                      audioRecorderService.pause();
                    }
                  },
                );
              },
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                context.read<AudioRecorderController>().stop((voiceNoteModel) {
                  if (voiceNoteModel == null) {
                    Navigator.pop(context);
                  } else {
                    context
                        .read<AudioRecorderController>()
                        .delete(voiceNoteModel.path)
                        .then((value) {
                      Navigator.pop(context);
                    });
                  }
                });
              },
              child: const Text(
                "Batal",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimerText extends StatelessWidget {
  const _TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Consumer<AudioRecorderController>(
        builder: (context, audioRecorderService, child) {
          final durationInSec = audioRecorderService.recordDuration;
          final int minutes = durationInSec ~/ 60;
          final int seconds = durationInSec % 60;

          return Text(
            '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
