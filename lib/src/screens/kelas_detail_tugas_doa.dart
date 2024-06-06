import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/controllers/voice_notes_cubit/voice_notes_cubit.dart';
import 'package:vedanta_frontend/src/model/voice_note_model.dart';
import 'package:vedanta_frontend/src/providers/class_provider.dart';
import 'package:vedanta_frontend/src/screens/audio_player_screen.dart';
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
  VoiceNoteModel? _newVoiceNote;
  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                color: Colors.purple,
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
                            'https://cdn.hmjtiundiksha.com/${result['doa']['pelafalanFile']}',
                      )
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
                    const SizedBox(height: 16),
                    if (_newVoiceNote != null)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AudioPlayerScreen(
                                path: _newVoiceNote!.path,
                              ),
                            ),
                          );
                        },
                        child: Container(
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
                                  const SizedBox(width: 10),
                                  Text(
                                    _newVoiceNote!.name,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.purple,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _newVoiceNote = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      const SizedBox(height: 16),
                      _AddRecordButton(
                        onVoiceNoteAdded: (voiceNote) {
                          setState(() {
                            _newVoiceNote = voiceNote;
                          });
                        },
                      )
                    ],
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
                    if (_image != null)
                      Stack(
                        children: [
                          Image.file(_image!),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.grey[700],
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _image = null;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    else ...[
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: const EdgeInsets.all(24),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          await _pickImage(ImageSource.gallery);
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.photo_library,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          'Galeri',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          await _pickImage(ImageSource.camera);
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.camera,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                        label: const Text('Kamera',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.purple,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
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
                      )
                    ],
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
  final Function(VoiceNoteModel) onVoiceNoteAdded;

  const _AddRecordButton({required this.onVoiceNoteAdded});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final VoiceNoteModel? newVoiceNote =
            await showAppBottomSheet(context, builder: (context) {
          return const AudioRecorderView();
        });
        if (newVoiceNote != null && context.mounted) {
          onVoiceNoteAdded(newVoiceNote);
        }
      },
      child: Container(
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
                const SizedBox(width: 10),
                Text(
                  'Rekam Suara',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
