import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/gita_provider.dart';
import 'package:vedanta_frontend/src/widgets/gita_card_widget.dart';
import 'package:vedanta_frontend/src/widgets/music_player_widget.dart';

class DetailSlokaScreen extends StatelessWidget {
  final int bab;
  final int sloka;
  const DetailSlokaScreen({super.key, required this.bab, required this.sloka});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Sloka'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: FutureBuilder<Map>(
          future: _getSloka(context, bab, sloka),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No data found.'),
              );
            } else {
              final sloka = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GitaCardWidget(
                      headerText: 'Sedang Membaca:',
                      subHeaderText:
                          'BAB ${sloka['numberBab']}: SLOKA ${sloka['number']}',
                      text: sloka['babTitle'] ?? '',
                      withButton: false,
                      onPress: () {},
                    ),
                    const SizedBox(height: 20),
                    if (sloka['urlPelafalan'] != null)
                      MusicPlayerWidget(url: sloka['urlPelafalan'])
                    else
                      const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    const Text(
                      'Sloka:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      sloka['content'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Terjemahan:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      sloka['translationIndo'] ?? '',
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Penjelasan Ganesh Bot:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MarkdownBody(
                          data: sloka['makna'] ?? '',
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<Map> _getSloka(BuildContext context, int bab, int sloka) async {
    final gitaProvider = Provider.of<GitaProvider>(context, listen: false);
    final response = await gitaProvider.getGitaSloka(bab, sloka);
    if (response['error'] == true) {
      throw Exception(response['message']);
    } else {
      return response;
    }
  }
}
