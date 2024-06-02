import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/stage_provider.dart';
import 'package:vedanta_frontend/src/widgets/isian_widget.dart';
import 'package:vedanta_frontend/src/widgets/mencocokkan_gambar.dart';
import 'package:vedanta_frontend/src/widgets/quiz_claim_reward_kerja_bagus.dart';
import 'package:vedanta_frontend/src/widgets/simak_audio.dart';

import '../widgets/pilihan_gandaru.dart';

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
        } else if (info['type'] == 'COMPLETING') {
          return KerjaBagus(info: info);
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
      case 'isian':
        return Isian(entry: widget.entry, answer: widget.answer);
      case 'simakaudio':
        return SimakAudio(entry: widget.entry, answer: widget.answer);
      default:
        return const Placeholder();
    }
  }
}
