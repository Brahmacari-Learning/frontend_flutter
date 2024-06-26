import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/popups/presensi_popup.dart';
import 'package:vedanta_frontend/src/providers/hadiah_provider.dart';
import 'package:vedanta_frontend/src/providers/mission_provider.dart';
import 'package:vedanta_frontend/src/providers/user_provider.dart';
import 'package:vedanta_frontend/src/utils.dart';
import 'package:vedanta_frontend/src/widgets/custom_alert.dart';
import 'package:vedanta_frontend/src/widgets/no_internet.dart';

class EventWidget extends StatefulWidget {
  const EventWidget({super.key});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  late Future<void> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _initializeUser();
  }

  Future<void> _initializeUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const NoInternet();
        }

        final userProvider = Provider.of<UserProvider>(context);
        final user = userProvider.user;

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
                _MisiTab(user: user),
                const _LencanaTab(),
                _TukarTab(user: user),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MisiTab extends StatefulWidget {
  final Map<String, dynamic> user;

  const _MisiTab({required this.user});

  @override
  State<_MisiTab> createState() => _MisiTabState();
}

class _MisiTabState extends State<_MisiTab> {
  late Future<Map<String, dynamic>> _futureMissions;
  bool _showNotification = false;
  String _notificationMessage = '';
  bool _notificationCorrect = true;

  @override
  void initState() {
    super.initState();
    _futureMissions = _getMissions();
  }

  void _showCustomNotification(String message, bool correct) {
    setState(() {
      _notificationMessage = message;
      _notificationCorrect = correct;
      _showNotification = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showNotification = false;
      });
    });
  }

  void _showClaimDialog(BuildContext context, Map<String, dynamic> misiItem) {
    final missionProvider =
        Provider.of<MissionProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Klaim Misi'),
          content: Text(
              'Apakah Anda ingin mengklaim misi ${misiItem['displayName']}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await missionProvider.claimMission(misiItem['id']);
                await userProvider.getInfo();
                Navigator.of(context).pop();
                setState(() {
                  _futureMissions = _getMissions();
                });
                _showCustomNotification(
                    'Misi ${misiItem['displayName']} berhasil diklaim.', true);
              },
              child: const Text('Klaim'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getMissions() async {
    final missionProvider =
        Provider.of<MissionProvider>(context, listen: false);
    final response = await missionProvider.getMission();
    if (response['error'] == true) {
      throw Exception(response['message']);
    }

    final missions = List<Map<String, dynamic>>.from(response['mission']);
    return {
      'missions': missions,
      'activeStreak': response['activeStreak'],
      'presenseAvailable': response['presenseAvailable']
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<Map<String, dynamic>>(
          future: _futureMissions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const NoInternet();
            }

            Map<String, dynamic> missionsData = snapshot.data!;
            List<Map<String, dynamic>> misi = missionsData['missions'];

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
                                '${widget.user['points']}',
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
                                '${widget.user['badges']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  missionsData['presenseAvailable']
                                      ? const Text("Ayo Presensi",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.start)
                                      : const Text("Sudah Presensi",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.start),
                                  GestureDetector(
                                      onTap: () async {
                                        if (!missionsData[
                                            'presenseAvailable']) {
                                          _showCustomNotification(
                                              'Sudah Presensi', false);
                                          return;
                                        }
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PresensiPopup(
                                              activeStreak:
                                                  missionsData['activeStreak'],
                                            ),
                                          ),
                                        );
                                        setState(() {
                                          _futureMissions = _getMissions();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.62,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: missionsData[
                                                      'presenseAvailable']
                                                  ? Colors.purple
                                                  : Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "${missionsData['activeStreak']}X",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Image.asset(
                                            'lib/assets/images/icons/time.png',
                                            fit: BoxFit.fill,
                                            width: 60,
                                            height: 60,
                                          )
                                        ],
                                      )),
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
                          const Text(
                            "Misi",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                          Column(
                            children: [
                              for (int i = 0; i < misi.length; i++)
                                GestureDetector(
                                  onTap: () {
                                    if (misi[i]['progress'] ==
                                        misi[i]['maxProgress']) {
                                      _showClaimDialog(context, misi[i]);
                                    } else {
                                      _showCustomNotification(
                                          'Progress Belum Terpenuhi', false);
                                    }
                                  },
                                  child: Container(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          fit: BoxFit.fill,
                                          'lib/assets/images/icons/misi.png',
                                          width: 80,
                                          height: 80,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              constraints: const BoxConstraints(
                                                  maxWidth: 170),
                                              child: Text(
                                                misi[i]['displayName'],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Container(
                                              height: 32,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'lib/assets/images/indikator_misi.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: Center(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 20),
                                                  child: Text(
                                                    "${misi[i]['progress']}/${misi[i]['maxProgress']}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        if (_showNotification)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomNotification(
              message: _notificationMessage,
              correct: _notificationCorrect,
            ),
          ),
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
  late Future<void> _fetchLencanaFuture;
  bool _showNotification = false;
  String _notificationMessage = '';
  bool _notificationCorrect = true;

  void _showCustomNotification(String message, bool correct) {
    setState(() {
      _notificationMessage = message;
      _notificationCorrect = correct;
      _showNotification = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showNotification = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<HadiahProvider>(context, listen: false);
    _fetchLencanaFuture = provider.getLencana();
  }

  void _showClaimDialog(
      BuildContext context, Map<String, dynamic> lencanaItem) {
    final lencanaProvider = Provider.of<HadiahProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Klaim Lencana'),
          content: Text(
              'Apakah Anda ingin mengklaim lencana ${lencanaItem['name']}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                if (!lencanaItem['has']) {
                  await lencanaProvider.lencanaClaim(lencanaItem['id']);
                  Navigator.of(context).pop();
                  setState(() {
                    _showCustomNotification('Lencana Berhasil Di Klaim', true);
                  });
                } else {
                  Navigator.of(context).pop();
                  setState(() {
                    _showCustomNotification('Lencana Sudah di Klaim', false);
                  });
                }
              },
              child: const Text('Klaim'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HadiahProvider>(context);
    return Stack(
      children: [
        FutureBuilder<void>(
          future: _fetchLencanaFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const NoInternet();
            }
            final lencana = provider.lencana['badges'];
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < lencana.length; i++)
                          GestureDetector(
                            onTap: () {
                              if (lencana[i]['progress'] ==
                                  lencana[i]['maxProgress']) {
                                _showClaimDialog(context, lencana[i]);
                              } else if (lencana[i]['has']) {
                                _showCustomNotification(
                                    'Lencana Sudah di Klaim', false);
                              } else {
                                _showCustomNotification(
                                    'Progress Belum Terpenuhi', false);
                              }
                            },
                            child: Opacity(
                              opacity: lencana[i]['has'] ? 1 : 0.5,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 15, left: 20, right: 20),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
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
                                            color: Color(
                                                0xFFFF8504), // Border color
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
                                            if (!lencana[i]['has'])
                                              Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 200),
                                                child: Text(
                                                  'Progress: ${lencana[i]['progress']} / ${lencana[i]['maxProgress']}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (_showNotification)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomNotification(
              message: _notificationMessage,
              correct: _notificationCorrect,
            ),
          ),
      ],
    );
  }
}

class _TukarTab extends StatefulWidget {
  final Map<String, dynamic> user;
  const _TukarTab({required this.user});

  @override
  State<_TukarTab> createState() => _TukarTabState();
}

class _TukarTabState extends State<_TukarTab> {
  late Future<void> _fetchHadiahFuture;
  bool _showNotification = false;
  String _notificationMessage = '';
  bool _notificationCorrect = true;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<HadiahProvider>(context, listen: false);
    _fetchHadiahFuture = provider.getHadiah();
  }

  void _showCustomNotification(String message, bool correct) {
    setState(() {
      _notificationMessage = message;
      _notificationCorrect = correct;
      _showNotification = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showNotification = false;
      });
    });
  }

  void _showClaimDialog(
      BuildContext context, String giftName, int giftId, dynamic status) {
    final provider = Provider.of<HadiahProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tukar Hadiah'),
          content: Text('Apakah Anda yakin ingin menukar hadiah: $giftName?'),
          actions: [
            TextButton(
              onPressed: () async {
                if (status == null) {
                  await provider.giftClaim(giftId);
                  Navigator.of(context).pop();
                  _showCustomNotification(
                      'Hadiah $giftName berhasil diklaim.', true);
                  _showCustomNotification('Hadiah Berhasil Di Tukar', true);
                } else {
                  Navigator.of(context).pop();
                  _showCustomNotification(
                      'Hadiah Sudah Di Tukar, Mohon Tunggu', false);
                }
              },
              child: const Text('Ya'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<void>(
          future: _fetchHadiahFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const NoInternet();
            }
            return Consumer<HadiahProvider>(
              builder: (context, provider, child) {
                final gifts = List<Map<String, dynamic>>.from(
                    provider.hadiah['gifts'] ?? []);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(top: 15, left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < gifts.length; i++)
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 47, 147, 223),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(
                                              3), // Border width
                                          decoration: const BoxDecoration(
                                            color: Color(
                                                0xFFFF8504), // Border color
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
                                              constraints: const BoxConstraints(
                                                  maxWidth: 140),
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
                                      onPressed: () async {
                                        if (widget.user['points'] <
                                            gifts[i]['prize']) {
                                          _showCustomNotification(
                                            'Point Belum Mencukup, Kumpulkan Poin Sebanyaknya',
                                            false,
                                          );
                                        } else {
                                          if (gifts[i]['status'] == null) {
                                            _showClaimDialog(
                                                context,
                                                gifts[i]['name'],
                                                gifts[i]['id'],
                                                gifts[i]['status']);
                                          } else if (gifts[i]['status'] ==
                                              "PENDING") {
                                            _showCustomNotification(
                                              'Hadiah sedang dalam proses klaim. Mohon tunggu.',
                                              false,
                                            );
                                          } else {
                                            _showCustomNotification(
                                              'Hadiah sudah diklaim sebelumnya. Mohon tunggu untuk klaim lagi.',
                                              false,
                                            );
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 20),
                                        backgroundColor: widget
                                                        .user['points'] >=
                                                    gifts[i]['prize'] &&
                                                gifts[i]['status'] == null
                                            ? const Color(0xFFF1C40F)
                                            : gifts[i]['status'] == 'SUCCESS'
                                                ? const Color.fromARGB(
                                                    255, 43, 191, 104)
                                                : const Color.fromARGB(
                                                    255, 175, 198, 216),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        gifts[i]['status'] == null
                                            ? "Tukar"
                                            : gifts[i]['status'] == "PENDING"
                                                ? "Menunggu"
                                                : "Berhasil",
                                        style: const TextStyle(
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
              },
            );
          },
        ),
        if (_showNotification)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomNotification(
              message: _notificationMessage,
              correct: _notificationCorrect,
            ),
          ),
      ],
    );
  }
}
