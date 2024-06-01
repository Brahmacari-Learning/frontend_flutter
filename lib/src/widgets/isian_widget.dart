import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Isian extends StatefulWidget {
  final Map<String, dynamic> entry;
  final Future<void> Function(String option, BuildContext context) answer;
  const Isian({
    super.key,
    required this.entry,
    required this.answer,
  });

  @override
  State<Isian> createState() => _IsianState();
}

class _IsianState extends State<Isian> {
  @override
  Widget build(BuildContext context) {
    // Controller
    final controller = TextEditingController();
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
                  TextFormField(
                    controller: controller,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    maxLength: model['correct']
                        .length, // Set the desired length of the OTP
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Ketikkan Jawaban Anda',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inputkan jawaban';
                      }
                      if (value.length != model['correct'].length) {
                        return 'Jawaban terdiri dari ${model['correct'].length} huruf';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.answer(controller.text, context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 194, 66, 211),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 0,
                      // ignore: prefer_const_constructors
                      side: BorderSide(
                        color: const Color.fromARGB(28, 255, 255, 255),
                        width: 2.0,
                      ),
                      minimumSize: const Size(double.infinity, 70),
                    ),
                    child: const Text(
                      'Jawab',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
