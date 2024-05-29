import 'package:flutter/material.dart';

class AllAlarmScreen extends StatefulWidget {
  const AllAlarmScreen({super.key});

  @override
  State<AllAlarmScreen> createState() => _AllAlarmScreenState();
}

class _AllAlarmScreenState extends State<AllAlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Alarm Doa',
            style: TextStyle(
              color: Colors.purple,
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
        body: TabBarView(
          children: [
            _mandiriTab(),
            _tugasTab(),
          ],
        ),
      ),
    );
  }

  Widget _mandiriTab() {
    return Column(
      children: [
        Expanded(
          child: ListView(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
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

  Widget _tugasTab() {
    return const Center(
      child: Text('Tab 1'),
    );
  }
}
