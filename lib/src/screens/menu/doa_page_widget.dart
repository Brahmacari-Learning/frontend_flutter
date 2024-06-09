import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/doa_provider.dart';
import 'package:vedanta_frontend/src/screens/alarm_screen.dart';
import 'package:vedanta_frontend/src/screens/doa_detail_screen.dart';
import 'package:vedanta_frontend/src/screens/doa_search_screen.dart';
import 'package:vedanta_frontend/src/utils.dart';
import 'package:vedanta_frontend/src/widgets/gita_card_widget.dart';
import 'package:vedanta_frontend/src/widgets/input_rounded_with_icon_widget.dart';
import 'package:vedanta_frontend/src/widgets/like_icon_widget.dart';

class DoaPageWidget extends StatefulWidget {
  const DoaPageWidget({super.key});

  @override
  State<DoaPageWidget> createState() => _DoaPageWidgetState();
}

class _DoaPageWidgetState extends State<DoaPageWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<dynamic> _doaList = [];
  final List<dynamic> _favoriteDoaList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _futureDoaList = _getDoaList();
      _futureLikedDoaList = _getLikedDoaList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late Future<void> _futureDoaList = Future.value();
  late Future<void> _futureLikedDoaList = Future.value();

  Future<void> _getLikedDoaList() async {
    final DoaProvider doaProvider =
        Provider.of<DoaProvider>(context, listen: false);
    final response = await doaProvider.getLikedDoas();
    setState(() {
      _favoriteDoaList.clear();
      for (var i = 0; i < response['doas'].length; i++) {
        _favoriteDoaList.add(response['doas'][i]);
      }
    });
  }

  Future<void> _getDoaList() async {
    final DoaProvider doaProvider =
        Provider.of<DoaProvider>(context, listen: false);
    final response = await doaProvider.getDoa();
    setState(() {
      _doaList.clear();
      for (var i = 0; i < response['doas'].length; i++) {
        _doaList.add(response['doas'][i]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final DoaProvider doaProvider =
        Provider.of<DoaProvider>(context, listen: false);
    final ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(context);

    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Center(
          child: Column(
            children: [
              InputRoundedWithIcon(
                controller: _controller,
                icon: Icons.search,
                label: 'Cari doa sehari-hari...',
                onEnter: (value) async {
                  final response =
                      await doaProvider.searchDoa(_controller.text.trim());
                  if (response['error']) {
                    scaffoldMessenger.showSnackBar(SnackBar(
                      content: Text(response['message']),
                      backgroundColor: Colors.purple,
                    ));
                  } else {
                    scaffoldMessenger.showSnackBar(const SnackBar(
                      content: Text('Doa ditemukan!'),
                      backgroundColor: Colors.green,
                    ));
                    // navigate to detail sloka screen
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchDoaScreen(
                          doas: response['doas'],
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 40),

              GitaCardWidget(
                headerText: greeting(),
                subHeaderText: "Kawal Harimu",
                text: "Dengan Doa",
                buttonText: 'Jadwalkan Doa',
                onPress: () {
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AlarmScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Tab widget
              Expanded(
                child: FutureBuilder<void>(
                  future: _futureDoaList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            const TabBar(
                              tabs: [
                                // Dropdown menu for bab
                                Tab(
                                  text: 'Doa',
                                ),
                                Tab(
                                  text: 'Favorit',
                                ),
                              ],
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Color(0xFFB95A92),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  // List view for sloka
                                  _doaListWidget(_futureDoaList, _doaList,
                                      scaffoldMessenger, false),
                                  _doaListWidget(
                                      _futureLikedDoaList,
                                      _favoriteDoaList,
                                      scaffoldMessenger,
                                      true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<void> _doaListWidget(
    Future<void> futureDoaList,
    List<dynamic> doaList,
    ScaffoldMessengerState scaffoldMessenger,
    bool likedList,
  ) {
    return FutureBuilder<void>(
      future: futureDoaList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return ListView.builder(
            itemCount: doaList.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoaDetailScreen(
                        idDoa: doaList[index]['id'],
                      ),
                    ),
                  );
                },
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('lib/assets/images/order_icon.png'),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  '${doaList[index]['title']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: InkWell(
                  onTap: () async {
                    if (!mounted) return;
                    // Add to favorite
                    final doaProvider =
                        Provider.of<DoaProvider>(context, listen: false);

                    if (!likedList) {
                      final response = await doaProvider.likeDoa(
                        doaList[index]['id'],
                        !doaList[index]['isLiked'],
                      );
                      if (response['error']) {
                        scaffoldMessenger.showSnackBar(SnackBar(
                          content: Text(response['message']),
                          backgroundColor: Colors.purple,
                        ));
                      } else {
                        setState(() {
                          // _futureSlokaList = _getSlokaList(_currentBab!);
                          doaList[index]['isLiked'] =
                              !doaList[index]['isLiked'];
                          _futureLikedDoaList = _getLikedDoaList();
                        });
                      }
                    } else {
                      final response = await doaProvider.likeDoa(
                        doaList[index]['id'],
                        false,
                      );
                      if (response['error']) {
                        scaffoldMessenger.showSnackBar(SnackBar(
                          content: Text(response['message']),
                          backgroundColor: const Color(0xFFB95A92),
                        ));
                      } else {
                        setState(() {
                          _futureLikedDoaList = _getLikedDoaList();
                          _futureDoaList = _getDoaList();
                        });
                      }
                    }
                  },
                  child: LikeIcon(
                    isLiked: doaList[index]['isLiked'],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
