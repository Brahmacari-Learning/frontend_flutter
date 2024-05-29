import 'package:flutter/material.dart';

class AlarmCreateScreen extends StatefulWidget {
  const AlarmCreateScreen({super.key});

  @override
  State<AlarmCreateScreen> createState() => _AlarmCreateScreenState();
}

class _AlarmCreateScreenState extends State<AlarmCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alarm Doa',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.purple, // Warna pink untuk back button
        ),
      ),
    );
  }
}
