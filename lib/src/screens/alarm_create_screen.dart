import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class AlarmCreateScreen extends StatefulWidget {
  const AlarmCreateScreen({super.key});

  @override
  State<AlarmCreateScreen> createState() => _AlarmCreateScreenState();
}

class _AlarmCreateScreenState extends State<AlarmCreateScreen> {
  int hour = 0;
  int minute = 0;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _numPicker(true),
                    const Text(
                      ":",
                      style: TextStyle(fontSize: 48),
                    ),
                    _numPicker(false),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  NumberPicker _numPicker(bool isHour) {
    return NumberPicker(
      value: isHour ? hour : minute,
      minValue: 0,
      maxValue: isHour ? 23 : 59,
      step: 1,
      textStyle: const TextStyle(
        color: Color.fromARGB(255, 134, 134, 134),
        fontSize: 20,
      ),
      selectedTextStyle: const TextStyle(
        color: Colors.purple,
        fontSize: 48,
      ),
      itemWidth: 90,
      itemHeight: 60,
      haptics: true,
      onChanged: (val) => {
        setState(() {
          isHour ? hour = val : minute = val;
        })
      },
    );
  }
}
