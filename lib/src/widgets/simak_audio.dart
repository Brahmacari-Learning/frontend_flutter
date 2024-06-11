import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/widgets/music_player_widget.dart';
import 'button_option_full_width.dart';

class SimakAudio extends StatefulWidget {
  final Map<String, dynamic> entry;
  final Future<void> Function(String option, BuildContext context) answer;
  const SimakAudio({
    super.key,
    required this.entry,
    required this.answer,
  });

  @override
  State<SimakAudio> createState() => _SimakAudioState();
}

class _SimakAudioState extends State<SimakAudio> {
  @override
  Widget build(BuildContext context) {
    final model = widget.entry['questionModel'];

    return Scaffold(
      backgroundColor: const Color(0xFF9C7AFF),
      appBar: AppBar(
        title: Text('Pertanyaan ${widget.entry['number']}'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF9C7AFF),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: LinearProgressIndicator(
                minHeight: 8,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                value: double.parse('${widget.entry['number']}') /
                    widget.entry['entryCount'],
                backgroundColor: const Color(0xFF7646FE),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MusicPlayerWidget(
                        url:
                            "https://cdn.hmjtiundiksha.com/${model['audioUrl']}"),
                    const SizedBox(
                      height: 20,
                    ),
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
                    ButtonOptionFullWidth(
                        text: model['optionOne'],
                        onClick: () {
                          widget.answer('a', context);
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    ButtonOptionFullWidth(
                        text: model['optionTwo'],
                        onClick: () {
                          widget.answer('b', context);
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    ButtonOptionFullWidth(
                        text: model['optionThree'],
                        onClick: () {
                          widget.answer('c', context);
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    ButtonOptionFullWidth(
                        text: model['optionFour'],
                        onClick: () {
                          widget.answer('d', context);
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
