import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/popups/presensi_popup.dart';
import 'package:vedanta_frontend/src/providers/hadiah_provider.dart';
import 'package:vedanta_frontend/src/providers/user_provider.dart';
import 'package:vedanta_frontend/src/utils.dart';

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
                  _MisiTab(user: user, context: context),
                  // Lencana
                  const _LencanaTab(),
                  //Tukar
                  _TukarTab(user: user),
                ],
              ),
            ),
          );
        });
  }
}

class _MisiTab extends StatelessWidget {
  _MisiTab({
    required this.user,
    required this.context,
  });

  final Map<String, dynamic> user;
  final BuildContext context;

  List<Map<String, dynamic>> misi = [
    {
      "title": "Selesaikan 10 kuis",
      "progress": 2,
      "total": 10,
    },
    {
      "title": "Absen 15 Hari",
      "progress": 2,
      "total": 15,
    },
    {
      "title": "Baca 5 Doa",
      "progress": 5,
      "total": 5,
    }
  ];

  @override
  Widget build(BuildContext context) {
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PresensiPopup(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.62,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text("3/20",
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
                  "Misi",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                Column(
                  children: [
                    for (int i = 0; i < misi.length; i++)
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
                                  child: Text(
                                    misi[i]['title'],
                                    style: const TextStyle(
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
                                      child: Text(
                                          "${misi[i]['progress']}/${misi[i]['total']}",
                                          style: const TextStyle(
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

class _LencanaTab extends StatefulWidget {
  const _LencanaTab();

  @override
  State<_LencanaTab> createState() => _LencanaTabState();
}

class _LencanaTabState extends State<_LencanaTab> {
  // final List<Map<String, dynamic>> _lencana = [

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HadiahProvider>(context, listen: false);
    return FutureBuilder(
        future: provider.getLencana(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('An error occurred'));
          }
          final lencana = snapshot.data!['badges'];
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < lencana.length; i++)
                        Opacity(
                          opacity: lencana[i]['has'] ? 1 : 0.5,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 15, left: 20, right: 20),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            // width: 345,
                            decoration: BoxDecoration(
                              color: lencana[i]['has']
                                  ? HexColor(lencana[i]['color'])
                                  : Colors.grey,
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
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(
                                          3), // Border width
                                      decoration: const BoxDecoration(
                                        color:
                                            Color(0xFFFF8504), // Border color
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundImage: NetworkImage(
                                            'https://cdn.hmjtiundiksha.com/${lencana[i]['image']}'),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 170),
                                          child: Text(
                                            lencana[i]['name'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 200),
                                          child: Text(
                                            lencana[i]['description'],
                                            style: const TextStyle(
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
                                  ],
                                ),
                                lencana[i]['has']
                                    ? Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 50, left: 10),
                                          child: Image.asset(
                                            fit: BoxFit.fill,
                                            'lib/assets/images/icons/star.png',
                                            width: 22,
                                            height: 22,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

class _TukarTab extends StatefulWidget {
  final Map<String, dynamic> user;
  const _TukarTab({required this.user});

  @override
  State<_TukarTab> createState() => _TukarTabState();
}

class _TukarTabState extends State<_TukarTab> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HadiahProvider>(context);

    return FutureBuilder(
        future: provider.getHadiah(),
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
          final gifts = snapshot.data!['gifts'];
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < gifts.length; i++)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 47, 147, 223),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.all(3), // Border width
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFF8504), // Border color
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          'https://cdn.hmjtiundiksha.com/${gifts[i]['thumbnail']}'),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 140),
                                        child: Text(
                                          "${gifts[i]['name']}",
                                          style: const TextStyle(
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
                                          Text(
                                            '${gifts[i]['prize']}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  backgroundColor:
                                      widget.user['points'] > gifts[i]['prize']
                                          ? const Color(0xFFF1C40F)
                                          : const Color.fromARGB(
                                              255, 175, 198, 216),
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
                                    fontWeight: FontWeight.w900,
                                  ),
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
        });
  }
}
