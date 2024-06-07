import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/helper/alarm_helper.dart';
import 'package:vedanta_frontend/src/providers/alarm_povider.dart';
import 'package:vedanta_frontend/src/services/auth_wraper.dart';

class AlarmCreateScreenTugas extends StatefulWidget {
  final int doaId;
  final int tugasId;
  const AlarmCreateScreenTugas(
      {super.key, required this.doaId, required this.tugasId});

  @override
  State<AlarmCreateScreenTugas> createState() => _AlarmCreateScreenTugasState();
}

class _AlarmCreateScreenTugasState extends State<AlarmCreateScreenTugas> {
  int hour = 0;
  int minute = 0;
  List<bool> isSelected = [false, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);

    return AuthWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Alarm Doa Tugas',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.purple, // Warna ungu untuk back button
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Picker
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
                ),
                const SizedBox(height: 10),
                const Text(
                  "Ulangi",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ToggleButtons(
                  borderColor: Colors.grey,
                  selectedBorderColor: Colors.purple,
                  fillColor: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  selectedColor: Colors.purple,
                  color: Colors.grey,
                  isSelected: isSelected,
                  onPressed: (int index) {
                    setState(() {
                      isSelected[index] = !isSelected[index];
                    });
                  },
                  constraints: BoxConstraints(
                    minWidth: (MediaQuery.of(context).size.width - 49) / 7,
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: Text("Sen"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: Text("Sel"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: Text("Rab"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: Text("Kam"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: Text("Jum"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: Text("Sab"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: Text("Min"),
                    ),
                  ],
                ), // Ulangi

                const SizedBox(height: 40),
                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await alarmProvider.createAlarmForTugas(
                        hour,
                        minute,
                        convertUlangiDoa(isSelected),
                        widget.doaId,
                        widget.tugasId,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Jadwalkan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
      infiniteLoop: true,
      zeroPad: true,
      itemWidth: 80,
      itemHeight: 100,
      textStyle: const TextStyle(fontSize: 40, color: Colors.grey),
      selectedTextStyle:
          const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      onChanged: (value) {
        setState(() {
          if (isHour) {
            hour = value;
          } else {
            minute = value;
          }
        });
      },
    );
  }
}
