import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/widgets/button_option_full_width.dart';

class KerjaBagus extends StatefulWidget {
  final Map<String, dynamic> info;
  const KerjaBagus({super.key, required this.info});

  @override
  State<KerjaBagus> createState() => _KerjaBagusState();
}

class _KerjaBagusState extends State<KerjaBagus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C7AFF),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF9C7AFF),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Kerja Bagus",
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              "lib/assets/images/kerja_bagus.png",
              width: 200,
            ),
            Image.asset(
              "lib/assets/images/2_star.png",
              width: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Kamu dapat bintang 3!",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // ignore: prefer_const_constructors
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "• 13",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFFFE55A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " Benar ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "• 7",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFFF9051),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " Salah",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ButtonOptionFullWidth(
              text: "Stage Berikutnya",
              onClick: () {},
              color: const Color(0xFFFF9051),
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonOptionFullWidth(
              text: "Lihat Klasemen",
              onClick: () {},
            ),
          ],
        ),
      ),
    );
  }
}
