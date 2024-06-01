import 'package:flutter/material.dart';
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
  Map<String, dynamic> info = {};
  int currentEntry = -1;

  Future<void> _getInfoQuiz() async {
    final stageProvider = Provider.of<StageProvider>(context, listen: false);
    final response = await stageProvider.info(widget.idQuiz);

    if (response['type'] == 'entry') {
      currentEntry = response['quizEntry']['id'];
    }
    setState(() {
      info = response;
    });
    assert(info.isNotEmpty);
  }

  Future<void> _answer(String option, BuildContext context) async {
    final stageProvider = Provider.of<StageProvider>(context, listen: false);
    final response =
        await stageProvider.answerEntry(widget.idQuiz, currentEntry, option);

    final bool correct = response['correct'];
    final int point = response['point'];

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(correct ? 'Correct! +$point' : 'Wrong! +0'),
      duration: const Duration(milliseconds: 500),
    ));

    await Future.delayed(const Duration(milliseconds: 500), () {});

    setState(() {
      _futureQuiz = _getInfoQuiz();
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (info.isEmpty) {
          return const Center(
            child: Text('No entries found.'),
          );
        }
        if (info['type'] == 'entry') {
          return EntryQuizView(entry: info['quizEntry'], answer: _answer);
        } else {
          return const Center(
            child: Text('Tunggu dulu'),
          );
        }
      },
    );
  }
}

class EntryQuizView extends StatefulWidget {
  final Map<String, dynamic> entry;
  final Future<void> Function(String option, BuildContext context) answer;
  const EntryQuizView({super.key, required this.entry, required this.answer});

  @override
  State<EntryQuizView> createState() => _EntryQuizViewState();
}

class _EntryQuizViewState extends State<EntryQuizView> {
  @override
  Widget build(BuildContext context) {
    switch (widget.entry['questionModel']['type']) {
      case 'pilgan':
        return PilihanGandaru(entry: widget.entry, answer: widget.answer);
      case 'cocokgambar':
        return MencocokkanGambaru(entry: widget.entry);
      default:
        return const Placeholder();
    }
  }
}

class MencocokkanGambaru extends StatefulWidget {
  final Map<String, dynamic> entry;
  const MencocokkanGambaru({
    super.key,
    required this.entry,
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

ElevatedButton buttonOptionFullWidth(String text, void Function() onClick) {
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
