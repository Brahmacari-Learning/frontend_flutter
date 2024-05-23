import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/auth_provider.dart';
import 'package:vedanta_frontend/src/providers/theme_provider.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    // return Scaffold(
    //   body: Center(
    //       child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       const Text('Profile Page'),
    //       ElevatedButton(
    //         onPressed: () async {
    //           await authProvider.logout();
    //           Navigator.of(context).pushReplacementNamed('/login');
    //         },
    //         child: const Text('Logout'),
    //       ),
    //       ElevatedButton(
    //         onPressed: () {
    //           themeProvider.toggleTheme();
    //         },
    //         child: const Text('Toggle Theme'),
    //       ),
    //     ],
    //   )),
    // );
    return Scaffold(
      body: Center(
        child: Column(
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
                        ),
                      ),
                      Text(
                        'Siswa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 50),
                  IconButton(
                    icon: Icon(Icons.edit,),
                    onPressed: () {
                      
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(              
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
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Waktu Belajar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 30),
                Container(
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
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Lencana',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
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
                    'Setting',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      // color: Color(0xFF898A8D),
                    ),
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      themeProvider.toggleTheme();
                    },
                    child: Text(
                      'Switch to themes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3E5FAF),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Keluar"),
                            content: Text("Apakah Anda Ingin Keluar dari Akun ini"),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await authProvider.logout();
                                  Navigator.of(context).pushReplacementNamed('/login');
                                },
                                child: Text(
                                  "Iya",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFFEB4105),
                                )),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Tidak",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFF01B0B7),
                                )
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Logout Account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFB6D64),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}
