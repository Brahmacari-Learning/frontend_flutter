import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/stage_provider.dart';
import 'package:vedanta_frontend/src/screens/stage_materi_screen.dart';

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
      print(stage);
      _stage = stage;
    });
  }

  @override
  void initState() {
    super.initState();
    _futureGetStage = getStage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          print('Hexagonal button pressed');
                        },
                        color: const Color(0xFF10CCCC),
                        outlineColor: Colors.white,
                        child: Center(
                          child: Image.asset(
                            'lib/assets/images/gift.png',
                            width: 30,
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
                        onPressed: () {
                          print('Hexagonal button pressed');
                        },
                        color: _stage['finished'] == 0
                            ? const Color(0xFFFF9051)
                            : const Color(0xFF10CCCC),
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
                      print(_stage);
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
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    HexagonalButton(
                      onPressed: () {
                        print('Hexagonal button pressed');
                      },
                      color: _stage['finished'] < index + 1
                          ? const Color.fromARGB(255, 141, 110, 231)
                          : _stage['finished'] == index + 1
                              ? const Color(0xFF10CCCC)
                              : const Color.fromARGB(255, 141, 110, 231),
                      outlineColor: Colors.white,
                      child: Center(
                        child: _stage['finished'] >= index + 1
                            ? Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.lock,
                                size: 30,
                                color: Colors.white,
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
                ),
              ],
            ],
          );
        },
      ),
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
    final sideLength = width / 2;

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
