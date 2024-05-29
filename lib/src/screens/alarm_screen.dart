import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/popups/presensi_popup.dart';
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
  final List<Map<String, dynamic>> _allAlarms = [];

  @override
  void initState() {
    super.initState();
    _futureAllAlarm = _getAlarmList();
  }

  Future<void> _getAlarmList() async {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    final response = await alarmProvider.getAlarm();

    setState(() {
      _allAlarms.clear();
      for (var i = 0; i < response['alarms'].length; i++) {
        _allAlarms.add(response['alarms'][i]);
      }
    });
  }

  void _toggleAlarm(int index) {
    setState(() {
      _allAlarms[index]['active'] = !_allAlarms[index]['active'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: _futureAllAlarm,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: _allAlarms.length,
                    itemBuilder: (context, index) {
                      final alarm = _allAlarms[index];
                      return Card(
                        color: alarm['active']
                            ? Colors.white
                            : Colors.grey.shade300,
                        child: ListTile(
                          title: Text(
                            alarm['jam'],
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            alarm['title'],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          trailing: Switch(
                            value: alarm['active'],
                            onChanged: (value) {
                              _toggleAlarm(index);
                            },
                            activeTrackColor: Colors.purple,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const AlarmCreateScreen(),
                  //   ),
                  // );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PresensiPopup(),
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
      ),
    );
  }
}
