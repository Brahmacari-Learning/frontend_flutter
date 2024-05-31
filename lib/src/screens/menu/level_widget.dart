import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vedanta_frontend/src/providers/stage_provider.dart';
import 'package:vedanta_frontend/src/screens/stage_screen.dart';

class LevelWidget extends StatefulWidget {
  const LevelWidget({super.key});

  @override
  State<LevelWidget> createState() => _LevelWidgetState();
}

class _LevelWidgetState extends State<LevelWidget> {
  Map<String, dynamic> _userInfo = {};
  List<dynamic> stages = [];

  Future<void> _futureGetStage = Future.value();

  Future<void> getStages() async {
    final provider = Provider.of<StageProvider>(context, listen: false);
    final stages = await provider.getStages();

    print(stages['stage']);

    setState(() {
      this.stages = stages['stage'];
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _futureGetStage = getStages();
  }

  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      setState(() {
        _userInfo = payload;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: _futureGetStage,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return DefaultTabController(
            length: stages.length,
            initialIndex: 0,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      200, // Adjust the height as needed
                  child: TabBarView(
                    children: List<Widget>.generate(stages.length, (int index) {
                      return Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              color: Colors.purple,
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
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '/ ${stages[index]['quizCount']}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                      value: stages[index]['finished'] == 0
                                          ? 0
                                          : double.parse(
                                                  stages[index]['finished']) /
                                              stages[index]['quizCount'],
                                      backgroundColor: Colors.deepPurple,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        Colors.purpleAccent,
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StageScreen(
                                              idStage: stages[index]['id'],
                                              title: stages[index]['title'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        stages[index]['finished'] > 0
                                            ? 'LIHAT PROGRESS'
                                            : 'AYO MAIN',
                                        style: const TextStyle(
                                          letterSpacing: 3,
                                          color: Colors.purple,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
