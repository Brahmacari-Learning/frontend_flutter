import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/widgets/alarm_tugas_tab.dart';
import 'package:vedanta_frontend/src/services/auth_wraper.dart';
import 'package:vedanta_frontend/src/widgets/alarm_mandiri_tab.dart';

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
