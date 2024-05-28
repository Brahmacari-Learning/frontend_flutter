import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/auth_provider.dart';
import 'package:vedanta_frontend/src/providers/theme_provider.dart';
import 'package:vedanta_frontend/src/providers/user_provider.dart';
import 'package:vedanta_frontend/src/screens/detail_profile_screen.dart';
import 'package:vedanta_frontend/src/screens/kelas_screen.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final response = userProvider.getInfo();
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
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 110,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/profil_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            FutureBuilder(
                future: response,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 1,
                      child: const CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text('An error occurred');
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            'https://vedanta-pro.vercel.app/api/user/update-profile-picture'),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!['user']['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            snapshot.data!['user']['email'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      // SizedBox(width: 50),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DetailProfileScreen()),
                          );
                        },
                      ),
                    ],
                  );
                }),
            const SizedBox(height: 20),
            const Divider(
              thickness: 1,
              indent: 30,
              endIndent: 30,
            ),
            const Row(
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
                SizedBox(
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
              margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFDADADA),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10), // Radius border
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const KelasScreen()),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(
                            "lib/assets/images/icons/kelas.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          'Kelas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Image.asset(
                          "lib/assets/images/icons/privasi.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
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
              margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
              padding: const EdgeInsets.all(20),
              width: 800,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFDADADA),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10), // Radius border
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Setting',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      // color: Color(0xFF898A8D),
                    ),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      themeProvider.toggleTheme();
                    },
                    child: const Text(
                      'Switch to themes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3E5FAF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Keluar"),
                            content: const Text(
                                "Apakah Anda Ingin Keluar dari Akun ini"),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    await authProvider.logout();
                                    Navigator.of(context)
                                        .pushReplacementNamed('/login');
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFFEB4105),
                                  ),
                                  child: const Text("Iya",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ))),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFF01B0B7),
                                ),
                                child: const Text(
                                  "Tidak",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
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
        )),
      ),
    );
  }
}
