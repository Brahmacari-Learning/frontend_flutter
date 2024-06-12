import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/stage_provider.dart';
import 'package:vedanta_frontend/src/providers/user_provider.dart';
import 'package:vedanta_frontend/src/screens/stage_screen.dart';
import 'package:vedanta_frontend/src/widgets/avatar_widget.dart';
import 'package:vedanta_frontend/src/widgets/no_internet.dart';

class LevelWidget extends StatefulWidget {
  const LevelWidget({super.key});

  @override
  State<LevelWidget> createState() => _LevelWidgetState();
}

class _LevelWidgetState extends State<LevelWidget> {
  late Future<Map<String, dynamic>> stagesFuture;
  late Future<Map<String, dynamic>> userFuture;

  @override
  void initState() {
    super.initState();
    stagesFuture = getStages();
    userFuture = _getUserInfo();
  }

  Future<Map<String, dynamic>> getStages() async {
    final provider = Provider.of<StageProvider>(context, listen: false);
    final s = await provider.getStages();
    return s;
  }

  Future<Map<String, dynamic>> _getUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await userProvider.getInfo();
    return response['user'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([stagesFuture, userFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const NoInternet();
        }

        final stagesData = snapshot.data![0];
        final userData = snapshot.data![1];
        final stages = stagesData['stage'];
        final initialUnlockedIndex = stagesData['lastUnlockedIndex'];
        final user = userData;

        return Scaffold(
          backgroundColor: Colors.purple[400],
          appBar: AppBar(
            title: Row(
              children: [
                AvatarWidget(
                  avatarUrl: user['profilePicture'],
                  name: user['name'],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      "Siswa",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  Image.asset(
                    fit: BoxFit.fill,
                    'lib/assets/images/star.png',
                    width: 24,
                    height: 24,
                  ),
                  Text(
                    '${user['points']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Image.asset(
                    fit: BoxFit.fill,
                    'lib/assets/images/medal.png',
                    width: 24,
                    height: 24,
                  ),
                  Text(
                    '${user['badges']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                DefaultTabController(
                  length: stages.length,
                  initialIndex: initialUnlockedIndex,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: TabBarView(
                          children:
                              List<Widget>.generate(stages.length, (int index) {
                            return Container(
                              color: stages[index]['locked']
                                  ? Colors.grey.shade700
                                  : Colors.transparent,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 50),
                                      Image.network(
                                        stages[index]['image_path'],
                                        height: 200,
                                        fit: BoxFit.fitWidth,
                                      ),
                                      const SizedBox(height: 50),
                                      // Card Stage
                                      Card(
                                        color: stages[index]['locked']
                                            ? const Color.fromARGB(
                                                31, 41, 41, 41)
                                            : Colors.purple,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                stages[index]['title'],
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${stages[index]['finished']}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    '/ ${stages[index]['quizCount']}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromARGB(
                                                          255, 213, 213, 213),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              // progress bar
                                              LinearProgressIndicator(
                                                minHeight: 8,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(4)),
                                                value: stages[index]
                                                            ['finished'] ==
                                                        0
                                                    ? 0
                                                    : double.parse(
                                                            '${stages[index]['finished']}') /
                                                        stages[index]
                                                            ['quizCount'],
                                                backgroundColor: stages[index]
                                                        ['locked']
                                                    ? const Color.fromARGB(
                                                        255, 74, 74, 74)
                                                    : Colors.deepPurple,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  stages[index]['locked']
                                                      ? const Color.fromARGB(
                                                          255, 74, 74, 74)
                                                      : Colors.purpleAccent,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                stages[index]['description'],
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 30),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                ),
                                                onPressed: () {
                                                  if (stages[index]['locked']) {
                                                    return;
                                                  }
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          StageScreen(
                                                        idStage: stages[index]
                                                            ['id'],
                                                        title: stages[index]
                                                            ['title'],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    if (stages[index]
                                                        ['locked']) ...[
                                                      const Icon(
                                                        Icons.lock,
                                                        color: Color.fromARGB(
                                                            255, 74, 74, 74),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      const Text(
                                                        'TERKUNCI',
                                                        style: TextStyle(
                                                          letterSpacing: 3,
                                                          color: Color.fromARGB(
                                                              255, 69, 69, 69),
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ] else ...[
                                                      Text(
                                                        stages[index][
                                                                    'finished'] >
                                                                0
                                                            ? 'LIHAT PROGRES'
                                                            : 'AYO MAIN',
                                                        style: const TextStyle(
                                                          letterSpacing: 3,
                                                          color: Colors.purple,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
