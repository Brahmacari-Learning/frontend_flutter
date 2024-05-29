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
              Image.asset(
                'lib/assets/images/presensi_harian.png',
                width: 300,
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
                padding: const EdgeInsets.all(16.0),
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
                          DayHeader(day: 'Sen'),
                          DayHeader(day: 'Sel'),
                          DayHeader(day: 'Rab'),
                          DayHeader(day: 'Kam'),
                          DayHeader(day: 'Jum'),
                          DayHeader(day: 'Sab'),
                          DayHeader(day: 'Min'),
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
                        '+3 Points',
                        style: TextStyle(
                          fontSize: 16,
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 182, 69, 202),
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
  const DayHeader({required this.day, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      day,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
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
      width: 32,
      height: 32,
    );
  }
}
