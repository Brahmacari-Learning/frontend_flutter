import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/alarm_povider.dart';
import 'package:vedanta_frontend/src/screens/alarm_select_doa_screen.dart';
import 'package:vedanta_frontend/src/services/auth_wraper.dart';

class AlarmCreateScreen extends StatefulWidget {
  const AlarmCreateScreen({super.key});

  @override
  State<AlarmCreateScreen> createState() => _AlarmCreateScreenState();
}

class _AlarmCreateScreenState extends State<AlarmCreateScreen> {
  int hour = 0;
  int minute = 0;
  List<bool> isSelected = [false, false, false, false, false, false, false];
  Map<String, dynamic> selectedDoa = {};

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);

    return AuthWrapper(
      child: Scaffold(
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
            color: Colors.purple,
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
                ),
                const SizedBox(height: 40),
                const Text(
                  "Pilih Doa",
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                ),

                // Doa picker
                InkWell(
                  onTap: () async {
                    dynamic doaFromSelectPage = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const AlarmSelectDoaScreen();
                        },
                      ),
                    );
                    if (doaFromSelectPage == null) return;
                    setState(() {
                      selectedDoa = doaFromSelectPage;
                    });
                  },
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDoa['title'] ?? 'Pilih Doa',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_right_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: selectedDoa.isNotEmpty
                        ? () async {
                            final response = await alarmProvider.createAlarm(
                              hour,
                              minute,
                              1,
                              selectedDoa['id'],
                            );
                            if (response['error'] == true) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Terjadi kesalahan saat menyimpan alarm',
                                    ),
                                  ),
                                );
                              }
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Alarm berhasil disimpan',
                                    ),
                                  ),
                                );
                              }
                              Navigator.pop(context);
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Simpan",
                      style: TextStyle(
                        fontSize: 16,
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

  Widget _numPicker(bool isHour) {
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
