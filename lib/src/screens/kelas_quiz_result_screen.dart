import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/class_provider.dart';
import 'package:vedanta_frontend/src/widgets/music_player_widget.dart';

class KelasQuizResultScreen extends StatefulWidget {
  final int idQuiz;
  final int idKelas;
  const KelasQuizResultScreen(
      {super.key, required this.idQuiz, required this.idKelas});

  @override
  State<KelasQuizResultScreen> createState() => _KelasQuizResultScreenState();
}

class _KelasQuizResultScreenState extends State<KelasQuizResultScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClassProvider>(context, listen: false);
    return FutureBuilder(
      future: provider.quizResult(widget.idKelas, widget.idQuiz),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('An error occurred'),
            ),
          );
        }
        final result = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Hasil',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.purple, // Warna pink untuk back button
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "NILAIMU",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(80, 155, 39, 176),
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "Nilai",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.purple,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      25.0,
                                    ),
                                  ),
                                  child: Text(
                                    "${result['correctCount'] / result['entries'].length * 100}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                const Text(
                                  "Poin",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.purple,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      25.0,
                                    ),
                                  ),
                                  child: Text(
                                    "${result['correctCount']}/${result['entries'].length}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        // progress bar showing right and wrong answers
                        LinearProgressIndicator(
                          value:
                              result['correctCount'] / result['entries'].length,
                          backgroundColor: Colors.red,
                          color: Colors.green,
                          minHeight: 10,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2.0),
                              color: const Color.fromARGB(89, 105, 240, 175),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(children: [
                                    const Icon(
                                      Icons.check,
                                      size: 18,
                                    ),
                                    Text('${result['correctCount']}')
                                  ])
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(2.0),
                              color: const Color.fromARGB(80, 255, 82, 82),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(children: [
                                    const Icon(
                                      Icons.check,
                                      size: 18,
                                    ),
                                    Text(
                                      '${result['entries'].length - result['correctCount']}',
                                    )
                                  ])
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  for (var i = 0; i < result['entries'].length; i++) ...[
                    if (result['entries'][i]['model']['type'] == 'pilgan') ...[
                      pilgan(result['entries'][i], i)
                    ] else if (result['entries'][i]['model']['type'] ==
                        'isian') ...[
                      isian(result['entries'][i], i)
                    ] else if (result['entries'][i]['model']['type'] ==
                        'simakaudio') ...[
                      simakAudio(result['entries'][i], i)
                    ] else if (result['entries'][i]['model']['type'] ==
                        'cocokgambar') ...[
                      cocokGambar(result['entries'][i], i)
                    ],
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  pilgan(Map<String, dynamic> data, int index) {
    final options = ['optionOne', 'optionTwo', 'optionThree', 'optionFour'];
    final opt = ['a', 'b', 'c', 'd'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. ${data['model']['title']}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          for (int i = 0; i < options.length; i++) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: data['model']['correct'] == opt[i]
                      ? const Color.fromARGB(132, 165, 214, 167)
                      : data['model']['correct'] != data['answer'] &&
                              data['answer'] == opt[i]
                          ? const Color.fromARGB(110, 244, 67, 54)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        data['model'][options[i]],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        softWrap: true,
                      ),
                    ),
                    if (data['model']['correct'] == opt[i])
                      const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    else if (data['model']['correct'] != data['answer'] &&
                        data['answer'] == opt[i])
                      const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  isian(Map<String, dynamic> data, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. ${data['model']['title']}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: data['model']['correct'] == data['answer']
                    ? const Color.fromARGB(132, 165, 214, 167)
                    : const Color.fromARGB(132, 240, 174, 165),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Jawaban: ${data['answer']}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      softWrap: true,
                    ),
                  ),
                  if (data['model']['correct'] == data['answer'])
                    const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  else
                    const Icon(
                      Icons.close,
                      color: Colors.red,
                    )
                ],
              ),
            ),
          ),
          if (data['model']['correct'] != data['answer'])
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(132, 165, 214, 167),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Jawaban yang benar: ${data['model']['correct']}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        softWrap: true,
                      ),
                    ),
                    const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  simakAudio(Map<String, dynamic> data, int index) {
    final options = ['optionOne', 'optionTwo', 'optionThree', 'optionFour'];
    final opt = ['a', 'b', 'c', 'd'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. ${data['model']['title']}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            softWrap: true,
          ),
          const SizedBox(height: 20),
          MusicPlayerWidget(
              url:
                  'https://cdn.hmjtiundiksha.com/${data['model']['audioUrl']}'),
          const SizedBox(height: 20),
          for (int i = 0; i < options.length; i++) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: data['model']['correct'] == opt[i]
                      ? const Color.fromARGB(132, 165, 214, 167)
                      : data['model']['correct'] != data['answer'] &&
                              data['answer'] == opt[i]
                          ? const Color.fromARGB(110, 244, 67, 54)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        data['model'][options[i]],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        softWrap: true,
                      ),
                    ),
                    if (data['model']['correct'] == opt[i])
                      const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    else if (data['model']['correct'] != data['answer'] &&
                        data['answer'] == opt[i])
                      const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  cocokGambar(Map<String, dynamic> data, int index) {
    final options = ['optionOne', 'optionTwo', 'optionThree', 'optionFour'];
    final opt = ['a', 'b', 'c', 'd'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. ${data['model']['title']}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 4 / 3,
            ),
            itemCount: options.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  // Handle option selection
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: data['model']['correct'] == opt[i]
                        ? const Color.fromARGB(132, 165, 214, 167)
                        : data['model']['correct'] != data['answer'] &&
                                data['answer'] == opt[i]
                            ? const Color.fromARGB(108, 236, 142, 135)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          'https://cdn.hmjtiundiksha.com/${data['model'][options[i]]}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.red,
                              size: 50,
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                      if (data['model']['correct'] == opt[i])
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        )
                      else if (data['model']['correct'] != data['answer'] &&
                          data['answer'] == opt[i])
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
