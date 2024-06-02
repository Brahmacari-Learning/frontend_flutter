import 'package:flutter/material.dart';

class MencocokkanGambaru extends StatefulWidget {
  final Map<String, dynamic> entry;
  final Future<void> Function(String option, BuildContext context) answer;
  const MencocokkanGambaru({
    super.key,
    required this.entry,
    required this.answer,
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
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 4 / 3,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling inside GridView
                    children: [
                      _buildOption(model['optionOne'], 'a', widget.answer),
                      _buildOption(model['optionTwo'], 'b', widget.answer),
                      _buildOption(model['optionThree'], 'c', widget.answer),
                      _buildOption(model['optionFour'], 'd', widget.answer),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String image, String option,
      Future<void> Function(String opt, BuildContext context) answer) {
    return GestureDetector(
      onTap: () {
        answer(option, context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          'https://cdn.hmjtiundiksha.com/$image',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
