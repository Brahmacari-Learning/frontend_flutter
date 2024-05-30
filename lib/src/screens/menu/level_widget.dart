import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vedanta_frontend/src/screens/stage_screen.dart';

class LevelWidget extends StatefulWidget {
  const LevelWidget({super.key});

  @override
  State<LevelWidget> createState() => _LevelWidgetState();
}

class _LevelWidgetState extends State<LevelWidget> {
  Map<String, dynamic> _userInfo = {};

  @override
  void initState() {
    super.initState();
    _getUserInfo();
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _userInfo.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      fit: BoxFit.fitWidth,
                      'lib/assets/images/hero1.png',
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 300,
                    ),
                    // Card Stage
                    Card(
                      color: Colors.purple,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'STAGE 1',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '3 ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '/ 8 Level',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 213, 213, 213),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // progress bar
                            const LinearProgressIndicator(
                              minHeight: 8,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              value: 0.375,
                              backgroundColor: Colors.deepPurple,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.purpleAccent,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Pada Tahapan ini kamu akan belajar banyak terkait sejarah dan dasar agama hindu',
                              textAlign: TextAlign.center,
                              style: TextStyle(
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
                                    builder: (context) => const StageScreen(),
                                  ),
                                );
                              },
                              child: const Text('START',
                                  style: TextStyle(
                                    letterSpacing: 3,
                                    color: Colors.purple,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Text('User ID: ${_userInfo['id']}'),
                    // Text('Email: ${_userInfo['email']}'),
                    // Add more fields as per your JWT payload structure
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
