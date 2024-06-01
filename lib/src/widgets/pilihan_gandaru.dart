import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/screens/stage_quiz_screen.dart';

import 'button_option_full_width.dart';

class PilihanGandaru extends StatefulWidget {
  final Map<String, dynamic> entry;
  final Future<void> Function(String option, BuildContext context) answer;
  const PilihanGandaru({
    super.key,
    required this.entry,
    required this.answer,
  });

  @override
  State<PilihanGandaru> createState() => _PilihanGandaruState();
}

class _PilihanGandaruState extends State<PilihanGandaru> {
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
                  Text(
                    model['title'],
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buttonOptionFullWidth(model['optionOne'], () {
                    widget.answer('a', context);
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  buttonOptionFullWidth(model['optionTwo'], () {
                    widget.answer('b', context);
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  buttonOptionFullWidth(model['optionThree'], () {
                    widget.answer('c', context);
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  buttonOptionFullWidth(model['optionFour'], () {
                    widget.answer('d', context);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
