import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/stage_provider.dart';
import 'package:vedanta_frontend/src/widgets/custom_alert.dart';
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
  }

  void _showCustomNotification(BuildContext context, bool correct, int point) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0, // Position the notification at the top of the screen
        left: 0,
        right: 0,
        child: CustomNotification(
          message:
              correct ? 'Kerja Bagus! +$point Points' : ' Yah Salah! +0 Points',
          correct: correct,
        ),
      ),
    );

    // Insert the overlay entry into the overlay
    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay entry after a delay
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Future<void> _answer(String option, BuildContext context) async {
    final stageProvider = Provider.of<StageProvider>(context, listen: false);
    final response =
        await stageProvider.answerEntry(widget.idQuiz, currentEntry, option);

    final bool correct = response['correct'];
    final int point = response['point'];

    _showCustomNotification(context, correct, point);

    await Future.delayed(const Duration(milliseconds: 500), () {});

    setState(() {
      _futureQuiz = _getInfoQuiz();
    });
  }

  @override
  void initState() {
    super.initState();
    _futureQuiz = _getInfoQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _futureQuiz,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF9C7AFF),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFF9C7AFF),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }
        if (info.isEmpty) {
          return const Scaffold(
            backgroundColor: Color(0xFF9C7AFF),
            body: Center(
              child: Text('No entries found.'),
            ),
          );
        }
        if (info['type'] == 'entry') {
          return EntryQuizView(entry: info['quizEntry'], answer: _answer);
        } else if (info['type'] == 'COMPLETING') {
          return KerjaBagus(info: info);
        } else {
          return const Scaffold(
            backgroundColor: Color(0xFF9C7AFF),
            body: Center(
              child: Text('Tunggu dulu'),
            ),
          );
        }
      },
    );
  }
}

class EntryQuizView extends StatelessWidget {
  final Map<String, dynamic> entry;
  final Future<void> Function(String option, BuildContext context) answer;
  const EntryQuizView({super.key, required this.entry, required this.answer});

  @override
  Widget build(BuildContext context) {
    switch (entry['questionModel']['type']) {
      case 'pilgan':
        return PilihanGandaru(entry: entry, answer: answer);
      case 'cocokgambar':
        return MencocokkanGambaru(entry: entry, answer: answer);
      case 'isian':
        return Isian(entry: entry, answer: answer);
      case 'simakaudio':
        return SimakAudio(entry: entry, answer: answer);
      default:
        return const Scaffold(
          body: Center(
            child: Text('Unsupported question type'),
          ),
        );
    }
  }
}
