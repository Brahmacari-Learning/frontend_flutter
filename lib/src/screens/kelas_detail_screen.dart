import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/class_provider.dart';
import 'package:vedanta_frontend/src/screens/kelas_quiz_result_screen.dart';
import 'package:vedanta_frontend/src/screens/stage_quiz_screen.dart';
import 'package:vedanta_frontend/src/services/auth_wraper.dart';
import 'package:vedanta_frontend/src/widgets/avatar_widget.dart';

class KelasDetailScreen extends StatefulWidget {
  final int id;
  const KelasDetailScreen({super.key, required this.id});

  @override
  State<KelasDetailScreen> createState() => _KelasDetailScreenState();
}

class _KelasDetailScreenState extends State<KelasDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // provider class
    final classProvider = Provider.of<ClassProvider>(context);

    return AuthWrapper(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Detail Kelas',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.purple, // Warna pink untuk back button
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            bottom: const TabBar(
              labelColor: Colors.purple,
              unselectedLabelColor: Color.fromARGB(255, 96, 96, 96),
              indicatorColor: Colors.purple,
              tabs: [
                Tab(text: "Tugas"),
                Tab(text: "Anggota"),
              ],
            ),
          ),
          body: TabBarView(children: [
            _TugasTab(id: widget.id),
            _ListSiswa(provider: classProvider, id: widget.id),
          ]),
        ),
      ),
    );
  }
}

class _TugasTab extends StatefulWidget {
  final int id;

  const _TugasTab({required this.id});

  @override
  State<_TugasTab> createState() => _TugasTabState();
}

class _TugasTabState extends State<_TugasTab> {
  Future<void> _futureTugas = Future.value();
  Map<String, dynamic> tugas = {};

  Future<void> _getTugas() async {
    final provider = Provider.of<ClassProvider>(context, listen: false);
    final result = await provider.allTugas(widget.id);
    setState(() {
      tugas = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _futureTugas = _getTugas();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureTugas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            child: const CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Text('An error occurred');
        }

        if (tugas.isEmpty) {
          return const Center(
            child: Text('Tugas belum found'),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Daftar Quiz",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                for (var i = 0; i < tugas['quizzes'].length; i++) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tugas['quizzes'][i]['title'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          if (tugas['quizzes'][i]['userQuizResult'].length >
                              0) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            KelasQuizResultScreen(
                                          idKelas: widget.id,
                                          idQuiz: tugas['quizzes'][i]['id'],
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 209, 209, 209),
                                  ),
                                  child: const Text(
                                    "Lihat Hasil",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 27, 27, 27)),
                                  ),
                                ),
                              ],
                            )
                          ] else ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StageQuizScreen(
                                          idQuiz: tugas['quizzes'][i]['id'],
                                        ),
                                      ),
                                    );
                                    setState(() {
                                      _futureTugas = _getTugas();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 209, 209, 209),
                                  ),
                                  child: const Text(
                                    "Mulai",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 27, 27, 27)),
                                  ),
                                ),
                              ],
                            )
                          ]
                        ],
                      ),
                    ),
                  )
                ],
                const Text(
                  "Daftar Tugas Doa",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                for (var i = 0; i < tugas['allHomeworkDoa'].length; i++) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    child: Text(
                      tugas['allHomeworkDoa'][i]['doa']['title'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ListSiswa extends StatefulWidget {
  final ClassProvider provider;
  final int id;

  const _ListSiswa({
    required this.provider,
    required this.id,
  });

  @override
  _ListSiswaState createState() => _ListSiswaState();
}

class _ListSiswaState extends State<_ListSiswa> {
  Future<void> _refreshList() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.provider.classMember(widget.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            child: const CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Text('An error occurred');
        }
        var members = snapshot.data!['members'];
        return RefreshIndicator(
          onRefresh: _refreshList,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 330,
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 20),
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.1),
                              offset: const Offset(0, -2),
                              blurRadius: 7,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                AvatarWidget(
                                    avatarUrl: members[index]['profilePicture'],
                                    name: members[index]['name']),
                                const SizedBox(width: 10),
                                Text(
                                  members[index]['name'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
