import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/helper/notification_helper.dart';
import 'package:vedanta_frontend/src/screens/alarm_create_screen.dart';
import 'package:vedanta_frontend/src/services/auth_wraper.dart';

import 'package:vedanta_frontend/src/widgets/mandiri_tab_alarm.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      child: DefaultTabController(
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
              color: Colors.purple,
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
      ),
    );
  }
}

class TugasTabAlarm extends StatelessWidget {
  const TugasTabAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Belum ada penjadwalan'),
    );
  }
}
