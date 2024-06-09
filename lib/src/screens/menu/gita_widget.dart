import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/gita_provider.dart';
import 'package:vedanta_frontend/src/screens/sloka_detail_screen.dart';
import 'package:vedanta_frontend/src/screens/sloka_search_screen.dart';
import 'package:vedanta_frontend/src/widgets/gita_card_widget.dart';
import 'package:vedanta_frontend/src/widgets/input_rounded_with_icon_widget.dart';
import 'package:vedanta_frontend/src/widgets/like_icon_widget.dart';
import 'package:vedanta_frontend/src/widgets/shimmer_widget.dart';

class GitaWidget extends StatefulWidget {
  const GitaWidget({super.key});

  @override
  State<GitaWidget> createState() => _GitaWidgetState();
}

class _GitaWidgetState extends State<GitaWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<dynamic> _babList = [];
  final List<dynamic> _slokaList = [];
  final List<dynamic> _favoriteSlokaList = [];
  int? _currentBab = 1;
  late Future<void> _futureBabList = Future.value();
  late Future<void> _futureSlokaList = Future.value();
  late Future<void> _futureFavoriteSlokaList = Future.value();
  Future<Map<String, dynamic>>? _futureBacaanTerakhir;

  @override
  void initState() {
    super.initState();
    setState(() {
      _futureBabList = _getBabList();
      _futureSlokaList = _getSlokaList(_currentBab!);
      _futureBacaanTerakhir = _getBacaanTerakhir();
      _futureFavoriteSlokaList = _getFavoriteSlokaList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getFavoriteSlokaList() async {
    final gitaProvider = Provider.of<GitaProvider>(context, listen: false);
    final response = await gitaProvider.getFavoriteSlokas();
    setState(() {
      _favoriteSlokaList.clear();
      for (var i = 0; i < response['slokas'].length; i++) {
        _favoriteSlokaList.add(response['slokas'][i]);
      }
    });
  }

  Future<Map<String, dynamic>> _getBacaanTerakhir() async {
    final gitaProvider = Provider.of<GitaProvider>(context, listen: false);
    return gitaProvider.getBacaanTerakhir();
  }

  Future<void> _getBabList() async {
    final gitaProvider = Provider.of<GitaProvider>(context, listen: false);
    final response = await gitaProvider.getGita();
    setState(() {
      _babList.clear();
      for (var i = 0; i < response['babs'].length; i++) {
        _babList.add(response['babs'][i]);
      }
    });
  }

  Future<void> _getSlokaList(int bab) async {
    final gitaProvider = Provider.of<GitaProvider>(context, listen: false);
    final response = await gitaProvider.getGitaSlokas(bab);
    setState(() {
      _slokaList.clear();
      for (var i = 0; i < response['slokas'].length; i++) {
        _slokaList.add(response['slokas'][i]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gitaProvider = Provider.of<GitaProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

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
                label: 'Cari Sloka...',
                onEnter: (value) async {
                  final response =
                      await gitaProvider.searchSlokas(_controller.text.trim());
                  if (response['error']) {
                    scaffoldMessenger.showSnackBar(SnackBar(
                      content: Text(response['message']),
                      backgroundColor: const Color(0xFFB95A92),
                    ));
                  } else {
                    scaffoldMessenger.showSnackBar(const SnackBar(
                      content: Text('Sloka ditemukan!'),
                      backgroundColor: Colors.green,
                    ));
                    // navigate to detail sloka screen
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchSlokaScreen(
                          slokas: response['gitas'],
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 40),
              _futureBacaanTerakhir != null
                  ? FutureBuilder(
                      future: _futureBacaanTerakhir,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CustomShimmerWidget(
                              width: double.infinity,
                              height: 180,
                              roundedRadius: 10);
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return snapshot.data!['bacaan'] != null
                              ? GitaCardWidget(
                                  headerText: 'Bacaan Terakhir',
                                  subHeaderText:
                                      "BAB ${snapshot.data!['bacaan']['babNumber']} : SLOKA ${snapshot.data!['bacaan']['slokaNumber']}",
                                  text: snapshot.data!['bacaan']['babTitle'],
                                  buttonText: 'Lanjutkan Membaca',
                                  onPress: () {
                                    if (!context.mounted) return;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailSlokaScreen(
                                          bab: snapshot.data!['bacaan']
                                              ['babNumber'],
                                          sloka: snapshot.data!['bacaan']
                                              ['slokaNumber'],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox();
                        }
                      },
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              // Tab widget
              Expanded(
                child: FutureBuilder<void>(
                  future: _futureBabList,
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
                            TabBar(
                              tabs: [
                                // Dropdown menu for bab
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: DropdownButton<int>(
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    underline: Container(),
                                    value: _currentBab,
                                    items: _babList.map((e) {
                                      return DropdownMenuItem<int>(
                                        value: _babList.indexOf(e) + 1,
                                        child: Text('BAB ${e['number']}'),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _currentBab = value;
                                        setState(() {
                                          _futureBabList = _getBabList();
                                          _futureSlokaList =
                                              _getSlokaList(_currentBab!);
                                          _futureFavoriteSlokaList =
                                              _getFavoriteSlokaList();
                                        });
                                      });
                                    },
                                  ),
                                ),
                                const Tab(
                                  text: 'Favorit',
                                ),
                              ],
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: const Color(0xFFB95A92),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  // List view for sloka
                                  _slokaListWidget(
                                    _futureSlokaList,
                                    _slokaList,
                                    scaffoldMessenger,
                                  ),
                                  _slokaListWidget(
                                    _futureFavoriteSlokaList,
                                    _favoriteSlokaList,
                                    scaffoldMessenger,
                                  ),
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

  FutureBuilder<void> _slokaListWidget(
    Future<void> futureSlokaList,
    List<dynamic> slokaList,
    ScaffoldMessengerState scaffoldMessenger,
  ) {
    return FutureBuilder<void>(
      future: futureSlokaList,
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
            itemCount: slokaList.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailSlokaScreen(
                        bab: _currentBab!,
                        sloka: slokaList[index]['number'],
                      ),
                    ),
                  );
                  setState(() {
                    _futureBacaanTerakhir = _getBacaanTerakhir();
                  });
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
                  'Sloka ${slokaList[index]['number']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: slokaList[index]['numberBab'] != null
                    ? Text("Bacaan Bab ${slokaList[index]['numberBab']}")
                    : Text("Bacaan Sloka ${slokaList[index]['number']}"),
                trailing: InkWell(
                  onTap: () async {
                    if (!mounted) return;
                    // Add to favorite
                    final gitaProvider =
                        Provider.of<GitaProvider>(context, listen: false);

                    if (slokaList[index]['numberBab'] == null) {
                      final response = await gitaProvider.likeSloka(
                        _currentBab!,
                        slokaList[index]['number'],
                        !slokaList[index]['isLiked'],
                      );
                      if (response['error']) {
                        scaffoldMessenger.showSnackBar(SnackBar(
                          content: Text(response['message']),
                          backgroundColor: Colors.purple,
                        ));
                      } else {
                        setState(() {
                          // _futureSlokaList = _getSlokaList(_currentBab!);
                          slokaList[index]['isLiked'] =
                              !slokaList[index]['isLiked'];
                          _futureFavoriteSlokaList = _getFavoriteSlokaList();
                        });
                      }
                    } else {
                      final response = await gitaProvider.likeSloka(
                        slokaList[index]['numberBab'],
                        slokaList[index]['number'],
                        false,
                      );
                      if (response['error']) {
                        scaffoldMessenger.showSnackBar(SnackBar(
                          content: Text(response['message']),
                          backgroundColor: const Color(0xFFB95A92),
                        ));
                      } else {
                        setState(() {
                          _futureFavoriteSlokaList = _getFavoriteSlokaList();
                          _futureSlokaList = _getSlokaList(_currentBab!);
                        });
                      }
                    }
                  },
                  child: LikeIcon(
                    isLiked: slokaList[index]['isLiked'],
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
