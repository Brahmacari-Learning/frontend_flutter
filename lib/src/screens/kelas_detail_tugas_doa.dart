import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/controllers/voice_notes_cubit/voice_notes_cubit.dart';
import 'package:vedanta_frontend/src/model/voice_note_model.dart';
import 'package:vedanta_frontend/src/providers/class_provider.dart';
import 'package:vedanta_frontend/src/screens/audio_recorder_screen.dart';
import 'package:vedanta_frontend/src/services/auth_wraper.dart';
import 'package:vedanta_frontend/src/widgets/app_botom_sheet.dart';
import 'package:vedanta_frontend/src/widgets/doa_card_widget.dart';
import 'package:vedanta_frontend/src/widgets/music_player_widget.dart';

class KelasDetailTugasDoa extends StatefulWidget {
  final int idKelas;
  final int idTugas;
  const KelasDetailTugasDoa(
      {super.key, required this.idKelas, required this.idTugas});

  @override
  State<KelasDetailTugasDoa> createState() => _KelasDetailTugasDoaState();
}

class _KelasDetailTugasDoaState extends State<KelasDetailTugasDoa> {
  @override
  Widget build(BuildContext context) {
    // provider class
    final classProvider = Provider.of<ClassProvider>(context);

    return AuthWrapper(
      child: FutureBuilder(
        future: classProvider.detailTugasDoa(widget.idKelas, widget.idTugas),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('An error occurred'),
              ),
            );
          }
          final result = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Tugas Doa',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(
                color: Colors.purple, // Warna pink untuk back button
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoaCardWidget(
                      headerText: result['doa']['title'],
                    ),
                    const SizedBox(height: 16),
                    if (result['doa']['pelafalanFile'] != null)
                      MusicPlayerWidget(
                          url:
                              'https://cdn.hmjtiundiksha.com/${result['doa']['pelafalanFile']}')
                    else
                      const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      result['doa']['body'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      result['doa']['makna'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Rekam doamu',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _AddRecordButton(),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.mic,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '00:00',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.delete,
                            color: Colors.purple,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gambaran Aktivitas',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Image.asset(
                            'lib/assets/images/upload.png',
                            width: 70,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Mengunggah Gambar',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Simpan',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  // full width button
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AddRecordButton extends StatelessWidget {
  const _AddRecordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(27),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashColor: Colors.white12,
        onTap: () async {
          final VoiceNoteModel? newVoiceNote =
              await showAppBottomSheet(context, builder: (context) {
            return const AudioRecorderView();
          });

          if (newVoiceNote != null && context.mounted) {
            context.read<VoiceNotesProvider>().addToVoiceNotes(newVoiceNote);
          }
        },
        child: const SizedBox(
          width: 75,
          height: 75,
          child: Icon(
            Icons.mic,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
