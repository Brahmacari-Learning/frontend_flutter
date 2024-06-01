import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/stage_provider.dart';

class StageQuizScreen extends StatefulWidget {
  final int idQuiz;
  const StageQuizScreen({super.key, required this.idQuiz});

  @override
  State<StageQuizScreen> createState() => _StageQuizScreenState();
}

class _StageQuizScreenState extends State<StageQuizScreen> {
  Future<void> _futureQuiz = Future.value();
  List<Map<String, dynamic>> quizEntries = [];
  int currentEntry = 0;
  String type = 'quiz';

  Future<void> _getInfoQuiz() async {
    final stageProvider = Provider.of<StageProvider>(context, listen: false);
    final response = await stageProvider.info(widget.idQuiz);

    setState(() {
      quizEntries = response['entries'];
      assert(quizEntries.isNotEmpty);
    });
  }

  @override
  void initState() {
    _futureQuiz = _getInfoQuiz();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureQuiz,
      builder: (context, snapshot) {
        return const PilganGanda();
      },
    );
  }
}

class EntryQuizView extends StatefulWidget {
  final int idEntry;
  const EntryQuizView({super.key, required this.idEntry});

  @override
  State<EntryQuizView> createState() => _EntryQuizViewState();
}

class _EntryQuizViewState extends State<EntryQuizView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PilganGanda extends StatefulWidget {
  const PilganGanda({super.key});

  @override
  State<PilganGanda> createState() => _PilganGandaState();
}

class _PilganGandaState extends State<PilganGanda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9C7AFF),
      appBar: AppBar(
        title: const Text('Pilgan Ganda'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF9C7AFF),
      ),
      body: Padding(
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
              buttonOptionPilganGanda('Pancadatu', () {}),
              const SizedBox(
                height: 10,
              ),
              buttonOptionPilganGanda('Pancadatu', () {}),
              const SizedBox(
                height: 10,
              ),
              buttonOptionPilganGanda('Pancadatu', () {}),
              const SizedBox(
                height: 10,
              ),
              buttonOptionPilganGanda('Pancadatu', () {}),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton buttonOptionPilganGanda(String text, void Function() onClick) {
    return ElevatedButton(
      onPressed: onClick,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF9C7AFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0,
        // ignore: prefer_const_constructors
        side: BorderSide(
          color: const Color.fromARGB(172, 255, 255, 255),
          width: 2.0,
        ),
        minimumSize: const Size(double.infinity, 70),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
