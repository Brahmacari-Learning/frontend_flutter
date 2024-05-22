import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vedanta_frontend/src/providers/auth_provider.dart';
import 'package:vedanta_frontend/src/providers/theme_provider.dart';

class ProfilWidget extends StatefulWidget {
  const ProfilWidget({super.key});

  @override
  State<ProfilWidget> createState() => _ProfilWidgetState();
}

class _ProfilWidgetState extends State<ProfilWidget> {
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
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: _userInfo.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 110,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/images/profil_background.png'), 
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('lib/assets/images/user2.png'),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'John Doe',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF263238),
                              ),
                            ),
                            Text(
                              'Siswa',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF263238),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 50),
                        IconButton(
                          icon: Icon(Icons.edit, color: Color(0xFF263238)),
                          onPressed: () {
                            // Edit profile action
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(
                    color: Color(0xFFDADADA), 
                    thickness: 1,
                    indent: 30,
                    endIndent: 30, 
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            '2+ hours',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF263238),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Waktu Belajar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF898989),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 30),
                      Container(
                        color: Color(0xFFDADADA),
                        width: 1,
                        height: 40,
                      ),
                      SizedBox(width: 30),
                      Column(
                        children: [
                          Text(
                            '20',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF263238),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Lencana',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF898989),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 25, right: 25),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFDADADA),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10), // Radius border
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              child: Image.asset(
                                "lib/assets/images/icons/kelas.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(width: 14),
                            Text(
                              'Kelas',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF263238),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              child: Image.asset(
                                "lib/assets/images/icons/privasi.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(width: 14),
                            Text(
                              'Privasi',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF263238),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 25, right: 25),
                    padding: EdgeInsets.all(20),
                    width: 800,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFDADADA),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10), // Radius border
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Account',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF898A8D),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Switch to Another Accountt',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3E5FAF),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Logout Account',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFB6D64),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}