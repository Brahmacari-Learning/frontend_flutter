import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/auth_provider.dart';
import 'package:vedanta_frontend/src/providers/user_provider.dart';
import 'package:vedanta_frontend/src/screens/profile_detail_screen.dart';
import 'package:vedanta_frontend/src/screens/kelas_screen.dart';
import 'package:vedanta_frontend/src/widgets/avatar_widget.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>> _getUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await userProvider.getInfo();
    return response['user'];
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.8,
                child: const CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(child: Text('An error occurred'));
            }
            final user = snapshot.data!;
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'lib/assets/images/profil_background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AvatarWidget(
                          avatarUrl: user['profilePicture'] != null
                              ? 'https://cdn.hmjtiundiksha.com/${user['profilePicture']}'
                              : null,
                          name: user['name'],
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['name'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                user['email'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DetailProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1, indent: 30, endIndent: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${user['points']}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Poin',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey,
                        ),
                        Column(
                          children: [
                            Text(
                              '${user['badges']}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Lencana',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFFDADADA), width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const KelasScreen(),
                              ),
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFFDADADA), width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pengaturan',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    "Keluar",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  content: const Text(
                                      "Apakah Anda Yakin Ingin Keluar dari Akun ini?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        await authProvider.logout();
                                        Navigator.of(context)
                                            .pushReplacementNamed('/login');
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 157, 157, 157),
                                      ),
                                      child: const Text(
                                        "Ya",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 147, 52, 230),
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
                            'Keluar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFFB6D64),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        'lib/assets/images/support_by.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
