import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/doa_provider.dart';
import 'package:vedanta_frontend/src/widgets/doa_card_widget.dart';
import 'package:vedanta_frontend/src/widgets/music_player_widget.dart';

class DoaDetailScreen extends StatelessWidget {
  final int idDoa;
  const DoaDetailScreen({super.key, required this.idDoa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doa'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: FutureBuilder<Map>(
          future: _getDoa(context, idDoa),
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
              final doa = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoaCardWidget(headerText: doa['title']),
                    const SizedBox(height: 20),
                    if (doa['pelafalanFile'] != null)
                      MusicPlayerWidget(url: doa['pelafalanFile'])
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
                      doa['body'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    doa['makna'] != ''
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Artinya:',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                doa['makna'] ?? '',
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<Map> _getDoa(BuildContext context, int idDoa) async {
    final doaProvider = Provider.of<DoaProvider>(context, listen: false);
    final response = await doaProvider.getDoaById(idDoa);
    if (response['error'] == true) {
      throw Exception(response['message']);
    } else {
      return response['doa'];
    }
  }
}
