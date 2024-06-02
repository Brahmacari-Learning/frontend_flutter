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
    final info = widget.info;
    final statsInfo = stats(info);
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
            Text(
              statsInfo['text'],
              style: const TextStyle(
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
              "lib/assets/images/${statsInfo['bintang']}_star.png",
              width: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Kamu dapat bintang ${statsInfo['bintang']}!",
              style: const TextStyle(
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
              children: [
                Text(
                  "• ${statsInfo['correctCount']}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFFFFE55A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  " Benar ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "• ${statsInfo['wrongCount']}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFFFF9051),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
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
              onClick: () {
                Navigator.pop(context);
              },
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

Map<String, dynamic> stats(Map<String, dynamic> info) {
  Map<String, dynamic> result = {};
  double rate = double.parse("${info['correctCount']}") / info['countQuiz'];
  // contains text, star image, correct count, wrong count
  if (rate < 0.5) {
    result = {
      "text": "Kamu harus lebih serius!",
      "bintang": 1,
      "correctCount": info['correctCount'],
      "wrongCount": info['countQuiz'] - info['correctCount'],
    };
  } else if (rate < 0.7) {
    result = {
      "text": "Lumayan!",
      "bintang": 2,
      "correctCount": info['correctCount'],
      "wrongCount": info['countQuiz'] - info['correctCount'],
    };
  } else {
    result = {
      "text": "Kerja Bagus!",
      "bintang": 3,
      "correctCount": info['correctCount'],
      "wrongCount": info['countQuiz'] - info['correctCount'],
    };
  }
  return result;
}