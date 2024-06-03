import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/widgets/button_option_full_width.dart';

class KlasemenScreen extends StatefulWidget {
  final int id;
  const KlasemenScreen({super.key, required this.id});

  @override
  State<KlasemenScreen> createState() => _KlasemenScreenState();
}

class _KlasemenScreenState extends State<KlasemenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C7AFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF9C7AFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/images/presensi_harian.png', width: 300),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Belum cukup data untuk ditampilkan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ButtonOptionFullWidth(
                text: "Kembali",
                onClick: () {
                  Navigator.pop(context);
                },
                color: const Color(0xFFFF9051),
              ),
            )
          ],
        ),
      ),
    );
  }
}
