import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/user_provider.dart';

class EventWidget extends StatefulWidget {
  const EventWidget({super.key});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  Future<Map<String, dynamic>> _getUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await userProvider.getInfo();
    return response['user'];
  }

  late Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Text('An error occurred');
          }

          user = snapshot.data!;
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.purple,
                elevation: 0,
                toolbarHeight: 0,
                bottom: const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Color.fromARGB(255, 211, 211, 211),
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: "Misi"),
                    Tab(text: "Lencana"),
                    Tab(text: "Tukar"),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  // Rahian
                  _misiTab(context),
                  // Lencana
                  _lencanaTab(),
                  //Tukar
                  _tukarTab(),
                ],
              ),
            ),
          );
        });
  }

  SingleChildScrollView _tukarTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 20; i++)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: 345,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9BD2FC),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, -2),
                          blurRadius: 7,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3), // Border width
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF8504), // Border color
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('lib/assets/images/user2.png'),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 140),
                              child: const Text(
                                "Kalender Bali asdas asdasdas",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  fit: BoxFit.fill,
                                  'lib/assets/images/star.png',
                                  width: 30,
                                  height: 30,
                                ),
                                const Text(
                                  '25',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            backgroundColor: const Color(0xFFF1C40F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Atur radius sudut di sini
                            ),
                          ),
                          child: const Text(
                            "Tukar",
                            style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  SingleChildScrollView _lencanaTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 20; i++)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: 345,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1C40F),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, -2),
                          blurRadius: 7,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3), // Border width
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF8504), // Border color
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                            radius: 35,
                            backgroundImage:
                                AssetImage('lib/assets/images/icons/misi.png'),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 170),
                              child: const Text(
                                "Si Pintar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: const Text(
                                "Menyelesaikan Semua Kuis Pada Map 1 asd ads asd ASZ das aSD",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 50, left: 10),
                          child: Image.asset(
                            fit: BoxFit.fill,
                            'lib/assets/images/icons/star.png',
                            width: 22,
                            height: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Column _misiTab(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 30,
            bottom: 10,
          ),
          width: double.infinity,
          color: Colors.purple,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                right: -30,
                top: 0,
                child: Image.asset(
                  'lib/assets/images/gift-open.png',
                  width: 250,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rahianmu",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        fit: BoxFit.fill,
                        'lib/assets/images/star.png',
                        width: 40,
                        height: 40,
                      ),
                      Text(
                        '${user['points']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        fit: BoxFit.fill,
                        'lib/assets/images/medal.png',
                        width: 40,
                        height: 40,
                      ),
                      Text(
                        '${user['badges']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Presensi Harian",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.62,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text("1/20",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              Image.asset(
                                fit: BoxFit.fill,
                                'lib/assets/images/icons/time.png',
                                width: 60,
                                height: 60,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Expanded(
            child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 20),
                const Text(
                  "Misi Harian",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                Column(
                  children: [
                    for (int i = 0; i < 5; i++)
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFDADADA),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              fit: BoxFit.fill,
                              'lib/assets/images/icons/misi.png',
                              width: 80,
                              height: 80,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 170),
                                  child: const Text(
                                    "Selesaikan 15 Kuis",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  height: 32,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'lib/assets/images/indikator_misi.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      child: const Text("1/ 20",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        )),
      ],
    );
  }
}
