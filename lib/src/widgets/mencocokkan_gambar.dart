import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/widgets/button_option_full_width.dart';

class MencocokkanGambaru extends StatefulWidget {
  final Map<String, dynamic> entry;
  // final Future<void> Function(String option, BuildContext context) answer;
  const MencocokkanGambaru({
    super.key,
    required this.entry,
    // required this.answer,
  });

  @override
  State<MencocokkanGambaru> createState() => _MencocokkanGambaruState();
}

class _MencocokkanGambaruState extends State<MencocokkanGambaru> {
  @override
  Widget build(BuildContext context) {
    final model = widget.entry['questionModel'];

    return Scaffold(
      backgroundColor: const Color(0xFF9C7AFF),
      appBar: AppBar(
        title: const Text('Pilgan Ganda'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF9C7AFF),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: LinearProgressIndicator(
              minHeight: 8,
              borderRadius: BorderRadius.all(Radius.circular(4)),
              value: 1 / 3,
              backgroundColor: Color(0xFF7646FE),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                    width: double.infinity,
                    child: Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Benang_tridatu.jpg/220px-Benang_tridatu.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Benda apakah di atas itu?",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buttonOptionFullWidth('Pancadatu', () {}),
                  const SizedBox(
                    height: 10,
                  ),
                  buttonOptionFullWidth('Tridatu', () {}),
                  const SizedBox(
                    height: 10,
                  ),
                  buttonOptionFullWidth('Sangadatu', () {}),
                  const SizedBox(
                    height: 10,
                  ),
                  buttonOptionFullWidth('Ekadatu', () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
