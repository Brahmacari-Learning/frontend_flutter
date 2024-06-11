import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/stage_provider.dart';
import 'package:vedanta_frontend/src/screens/stage_materi_screen.dart';
import 'package:vedanta_frontend/src/screens/stage_quiz_screen.dart';
import 'package:vedanta_frontend/src/services/auth_wraper.dart';

class StageScreen extends StatefulWidget {
  final int idStage;
  final String title;
  const StageScreen({super.key, required this.idStage, required this.title});

  @override
  State<StageScreen> createState() => _StageScreenState();
}

class _StageScreenState extends State<StageScreen> {
  Future<void> _futureGetStage = Future.value();
  Map<String, dynamic> _stage = {};

  Future<void> getStage() async {
    final provider = Provider.of<StageProvider>(context, listen: false);
    final stage = await provider.getStage(widget.idStage);

    setState(() {
      _stage = stage;
    });
  }

  @override
  void initState() {
    super.initState();
    _futureGetStage = getStage();
  }

  stateQuiz(int index) {
    if (_stage['Quiz'][index]['completed']) {
      return 'completed';
    } else if (index == _stage['firstNotCompletedIndex']) {
      return 'mustDo';
    }
    return 'locked';
  }

  generateColor(int index) {
    final state = stateQuiz(index);
    if (state == 'completed') {
      return const Color.fromARGB(255, 81, 104, 81);
    } else if (state == 'locked') {
      return const Color.fromARGB(255, 39, 39, 39);
    }
    return const Color.fromARGB(255, 243, 159, 33);
  }

  onClickQuiz(int id, int index) async {
    final provider = Provider.of<StageProvider>(context, listen: false);
    final state = stateQuiz(index);
    if (state == 'completed') {
      final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Peringatan', style: TextStyle(fontSize: 24)),
            content: const Text(
              'Anda yakin ingin mengulang menjawab quiz ini?',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Ya'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Tidak'),
              ),
            ],
          );
        },
      );

      if (!result!) {
        return;
      }

      await provider.restartQuiz(id);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StageQuizScreen(
            idQuiz: id,
          ),
        ),
      );
      setState(() {
        _futureGetStage = getStage();
      });
    } else if (state == 'mustDo') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StageQuizScreen(
            idQuiz: id,
          ),
        ),
      );
      setState(() {
        _futureGetStage = getStage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          elevation: 0,
          backgroundColor: const Color(0xFF9C7AFF),
        ),
        backgroundColor: const Color(0xFF9C7AFF),
        body: FutureBuilder(
          future: _futureGetStage,
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
            return Column(
              children: [
                // ignore: prefer_const_constructors
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        HexagonalButton(
                          onPressed: () {
                            // show popup
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      'Raih hadiahmu! +${_stage['points_reward_finished']} poin jika selesai stage ini'),
                                );
                              },
                            );
                          },
                          color: const Color.fromARGB(255, 218, 170, 13),
                          outlineColor: Colors.white,
                          child: const Center(
                            child: Icon(
                              Icons.question_mark,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          right: -40,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CustomPaint(
                              size: const Size(40, 2),
                              painter: HorizontalLinePainter(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        HexagonalButton(
                          onPressed: () async {
                            onClickQuiz(_stage['Quiz'][0]['id'], 0);
                          },
                          color: generateColor(0),
                          outlineColor: Colors.white,
                          child: const Center(
                            child: Text(
                              "1",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          right: -40,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CustomPaint(
                              size: const Size(40, 2),
                              painter: HorizontalLinePainter(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    HexagonalButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StageMateriScreen(
                              stageId: _stage['id'],
                              videoId: _stage['materi']['videoLink'],
                            ),
                          ),
                        );
                      },
                      color: const Color(0xFFDA94FA),
                      outlineColor: Colors.white,
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Image.asset(
                              'lib/assets/images/lamp.png',
                              width: 30,
                            ),
                            const Text(
                              'AYO CEK MATERI',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                for (int index = 1; index < _stage['quizCount']; index++) ...[
                  // LAST ROW (with claim hadiah)
                  if (index + 1 == _stage['quizCount']) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 125,
                        ),
                        quizButtonVertical(index, context),
                        const SizedBox(
                          width: 40,
                        ),
                        // Claim hadiah
                        claimHadiah(context),
                      ],
                    ),
                  ] else
                    quizButtonVertical(index, context),
                  const SizedBox(height: 40),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Stack claimHadiah(BuildContext context) {
    final claimable = _stage['quizCount'] == _stage['finished'];
    final notClaimed = !_stage['rewardClaimed'];
    final claimed = !notClaimed;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        HexagonalButton(
          onPressed: () {
            if (notClaimed && claimable) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.white,
                    title: const Text(
                      'Klaim Hadiah mu!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    content: const Text(
                      'Selamat! Anda telah memenangkan hadiah. Klik klaim untuk menerima hadiah Anda.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          'Batal',
                          style: TextStyle(color: Colors.grey),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Klaim',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          final stageProvider = Provider.of<StageProvider>(
                            context,
                            listen: false,
                          );
                          stageProvider.claimReward(_stage['id']).then(
                            (response) {
                              if (response['reward'] != null) {
                                if (mounted) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Hadiah Anda telah diterima'),
                                    ),
                                  );
                                  setState(() {
                                    _futureGetStage = getStage();
                                  });
                                }
                              } else {
                                if (mounted) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(response['message']),
                                      backgroundColor: Colors.purple,
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          color: notClaimed && claimable
              ? const Color.fromARGB(255, 17, 223, 93)
              : claimed
                  ? Colors.purple
                  : const Color.fromARGB(255, 71, 71, 71),
          outlineColor: Colors.white,
          child: Center(
            child: notClaimed && !claimable
                ? const Icon(
                    Icons.lock,
                    color: Colors.white,
                  )
                : claimed
                    ? Image.asset(
                        'lib/assets/images/gift-claimed.png',
                        width: 30,
                      )
                    : Image.asset(
                        'lib/assets/images/gift.png',
                        width: 30,
                      ),
          ),
        ),
        Positioned.fill(
          left: -40,
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomPaint(
              size: const Size(40, 2),
              painter: HorizontalLinePainter(),
            ),
          ),
        ),
      ],
    );
  }

  Stack quizButtonVertical(int index, BuildContext context) {
    final state = stateQuiz(index);
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        HexagonalButton(
          onPressed: () async {
            onClickQuiz(_stage['Quiz'][index]['id'], index);
          },
          color: generateColor(index),
          outlineColor: Colors.white,
          child: Center(
            child: state == 'locked'
                ? const Icon(
                    Icons.lock,
                    size: 30,
                    color: Colors.white,
                  )
                : Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        Positioned.fill(
          top: -40,
          child: Align(
            alignment: Alignment.topCenter,
            child: CustomPaint(
              size: const Size(2, 40),
              painter: HorizontalLinePainter(),
            ),
          ),
        ),
      ],
    );
  }
}

class HorizontalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white // Ubah warna garis di sini
      ..strokeWidth = size.height;

    final start = Offset(0, size.height / 2);
    final end = Offset(size.width, size.height / 2);

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class HexagonalButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final Color outlineColor;
  final Widget child;
  final double size;
  final double outlineWidth;

  const HexagonalButton({
    required this.onPressed,
    required this.color,
    required this.outlineColor,
    required this.child,
    this.size = 80.0,
    this.outlineWidth = 4.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipPath(
            clipper: HexagonClipper(),
            child: Container(
              width: size + outlineWidth,
              height: size + outlineWidth,
              color: outlineColor,
            ),
          ),
          ClipPath(
            clipper: HexagonClipper(),
            child: Container(
              width: size,
              height: size,
              color: color,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    // final sideLength = width / 2;

    path.moveTo(width * 0.5, 0);
    path.lineTo(width, height * 0.25);
    path.lineTo(width, height * 0.75);
    path.lineTo(width * 0.5, height);
    path.lineTo(0, height * 0.75);
    path.lineTo(0, height * 0.25);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
