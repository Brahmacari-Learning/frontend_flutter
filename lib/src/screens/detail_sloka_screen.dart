import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/widgets/gita_card_widget.dart';
import 'package:vedanta_frontend/src/widgets/music_player_widget.dart';

class DetailSlokaScreen extends StatefulWidget {
  const DetailSlokaScreen({super.key});

  @override
  State<DetailSlokaScreen> createState() => _DetailSlokaScreenState();
}

class _DetailSlokaScreenState extends State<DetailSlokaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Sloka'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GitaCardWidget(
              headerText: 'Sedang Membaca:',
              subHeaderText: 'BAB 1: SLOKA 1',
              text: 'Arjuna Vishaada Yoga',
              withButton: false,
            ),
            SizedBox(height: 20),
            // Media Player Widget
            MusicPlayerWidget(
                url:
                    "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"),
            Text(
                'dhṛtarāṣṭra uvācadharmakṣetre kurukṣetre samavetā yuyutsavaḥmāmakāḥ pāṇḍavāścaiva kimakurvata sañjaya')
          ],
        ),
      ),
    );
  }
}
