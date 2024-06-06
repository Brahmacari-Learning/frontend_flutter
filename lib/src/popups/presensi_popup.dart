import 'package:flutter/material.dart';

class PresensiPopup extends StatefulWidget {
  const PresensiPopup({super.key});

  @override
  State<PresensiPopup> createState() => _PresensiPopupState();
}

class _PresensiPopupState extends State<PresensiPopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.purple,
            size: 30,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    'lib/assets/images/presensi_harian.png',
                    width: 300,
                  ),
                  Positioned(
                    top: 20,
                    left: -20,
                    child: Image.asset(
                      'lib/assets/images/star.png',
                      // width: 300,
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    right: -20,
                    child: Image.asset(
                      'lib/assets/images/star.png',
                      // width: 300,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Presensi Harian',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Table head hari (sen, sel, rb, kam, jum, sab, min), orange beberapa
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DayHeader(day: 'Mn'),
                          DayHeader(day: 'Sn'),
                          DayHeader(day: 'Sl'),
                          DayHeader(day: 'Rb', color: Colors.grey),
                          DayHeader(day: 'Km', color: Colors.grey),
                          DayHeader(day: 'Jm', color: Colors.grey),
                          DayHeader(day: 'Sb', color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Divider
                      const Divider(),
                      // Table body
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            List.generate(3, (index) => const AttendanceIcon()),
                      ),
                      const SizedBox(height: 8),
                      // Star count text
                      const Text(
                        '+3 Point',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Spacing
              const SizedBox(
                height: 30,
              ),
              // Button claim
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const PresensiPopup();
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 186, 60, 208),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Klaim Reward',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DayHeader extends StatelessWidget {
  final String day;
  final Color color;
  const DayHeader({required this.day, super.key, this.color = Colors.orange});

  @override
  Widget build(BuildContext context) {
    return Text(
      day,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

class AttendanceIcon extends StatelessWidget {
  const AttendanceIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/star.png',
      width: 38,
      height: 38,
    );
  }
}
