import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/helper/notification_helper.dart';
import 'package:vedanta_frontend/src/providers/alarm_povider.dart';
import 'package:vedanta_frontend/src/screens/alarm_create_screen.dart';

class MandiriTabAlarm extends StatefulWidget {
  const MandiriTabAlarm({super.key});

  @override
  State<MandiriTabAlarm> createState() => _MandiriTabAlarmState();
}

class _MandiriTabAlarmState extends State<MandiriTabAlarm> {
  Future<void> _futureAllAlarm = Future.value();
  final List<Map<String, dynamic>> _allAlarms = [];
  final List<DateTime> _parsedAlarmTimes = [];

  @override
  void initState() {
    super.initState();
    // _initializeNotification();
    _futureAllAlarm = _getAlarmList();
  }

  // Future<void> _initializeNotification() async {
  //   await NotificationHelper.init();
  // }

  Future<void> _getAlarmList() async {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    final response = await alarmProvider.getAlarm();

    setState(() {
      _allAlarms.clear();
      _parsedAlarmTimes.clear();
      for (var alarm in response['alarms']) {
        _allAlarms.add(alarm);
        final hour = int.parse(alarm['jam'].split(':')[0]);
        final minute = int.parse(alarm['jam'].split(':')[1]);
        final now = DateTime.now();
        final parsedDateTime =
            DateTime(now.year, now.month, now.day, hour, minute);
        _parsedAlarmTimes.add(parsedDateTime);
      }
    });
  }

  void _toggleAlarm(int index) async {
    setState(() {
      _allAlarms[index]['active'] = !_allAlarms[index]['active'];
    });

    try {
      final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
      await alarmProvider.activeToggle(
          _allAlarms[index]['id'], _allAlarms[index]['active']);
    } catch (e) {
      print('Error toggling alarm: $e');
    }

    // Schedule or cancel the notification based on the new status
    if (_allAlarms[index]['active']) {
      print(_allAlarms[index]);
      await NotificationHelper.scheduleNotification(
        _allAlarms[index]['title'],
        "Waktu untuk membaca ${_allAlarms[index]['title']}",
        _parsedAlarmTimes[index],
        _allAlarms[index]['doaId'],
      );
    } else {}
  }

  void _showPopupMenu(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Hapus'),
              onTap: () async {
                Navigator.pop(context);
                final alarmProvider =
                    Provider.of<AlarmProvider>(context, listen: false);
                final alarmId = _allAlarms[index]['id'];
                await alarmProvider.deleteAlarm(alarmId);
                await _getAlarmList();
              },
            ),
          ],
        );
      },
    );
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
                  if (_allAlarms.isEmpty) {
                    // Jika tidak ada doa yang ditambahkan, tampilkan pesan
                    return const Center(
                        child: Text('Belum ada penjadwalan doa'));
                  } else {
                    return ListView.builder(
                      itemCount: _allAlarms.length,
                      itemBuilder: (context, index) {
                        final alarm = _allAlarms[index];
                        return GestureDetector(
                          onLongPress: () {
                            _showPopupMenu(context, index);
                          },
                          child: Card(
                            color: alarm['active']
                                ? Colors.white
                                : Colors.grey.shade300,
                            child: ListTile(
                              title: Text(
                                '${alarm['jam'].split(':')[0].padLeft(2, '0')}:${alarm['jam'].split(':')[1].padLeft(2, '0')}',
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
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AlarmCreateScreen(),
                    ),
                  );
                  setState(() {
                    _futureAllAlarm = _getAlarmList();
                  });
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
                    SizedBox(width: 10),
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
