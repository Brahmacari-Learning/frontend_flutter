import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/screens/alarm_select_doa_screen.dart';

class AlarmCreateScreen extends StatefulWidget {
  const AlarmCreateScreen({super.key});

  @override
  State<AlarmCreateScreen> createState() => _AlarmCreateScreenState();
}

class _AlarmCreateScreenState extends State<AlarmCreateScreen> {
  int hour = 0;
  int minute = 0;
  List<bool> isSelected = [false, false, false, false, false, false, false];
  dynamic selectedDoa;

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
                        selectedDoa != null
                            ? selectedDoa['title']
                            : 'Pilih Doa',
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
                  onPressed: () async {
                    if (selectedDoa == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pilih Doa terlebih dahulu'),
                        ),
                      );
                      return;
                    }

                    // await Provider.of<AlarmProvider>(context, listen: false)
                    //     .setAlarm(
                    //         hour: hour,
                    //         minute: minute,
                    //         doa: selectedDoa['title'],
                    //         id: selectedDoa['id']);
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
        fontWeight: FontWeight.w700,
      ),
      itemWidth: 90,
      itemHeight: 60,
      haptics: true,
      onChanged: (val) {
        setState(() {
          if (isHour) {
            hour = val;
          } else {
            minute = val;
          }
        });
      },
    );
  }
}
