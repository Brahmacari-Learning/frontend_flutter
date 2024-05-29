import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/alarm_povider.dart';
import 'package:vedanta_frontend/src/screens/alarm_create_screen.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            color: Colors.purple, // Warna pink untuk back button
          ),
          bottom: const TabBar(
            labelColor: Colors.purple,
            unselectedLabelColor: Color.fromARGB(255, 96, 96, 96),
            indicatorColor: Colors.purple,
            tabs: [
              Tab(text: "Mandiri"),
              Tab(text: "Tugas"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MandiriTabAlarm(),
            TugasTabAlarm(),
          ],
        ),
      ),
    );
  }
}

class TugasTabAlarm extends StatelessWidget {
  const TugasTabAlarm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Tab 1'),
    );
  }
}

class MandiriTabAlarm extends StatefulWidget {
  const MandiriTabAlarm({
    super.key,
  });

  @override
  State<MandiriTabAlarm> createState() => _MandiriTabAlarmState();
}

class _MandiriTabAlarmState extends State<MandiriTabAlarm> {
  Future<void> _futureAllAlarm = Future.value();
  List<Map<String, dynamic>> _allAlarms = [];

  @override
  void initState() {
    super.initState();
    _futureAllAlarm = _getAlarmList();
  }

  Future<void> _getAlarmList() async {
    // Add your logic here
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    final response = await alarmProvider.getAlarm();

    setState(() {
      _allAlarms.clear();
      for (var i = 0; i < response['alarms'].length; i++) {
        _allAlarms.add(response['alarms'][i]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to AlarmCreate
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AlarmCreateScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.alarm,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Set Alarm',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
