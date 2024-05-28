import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/gita_provider.dart';
import 'package:vedanta_frontend/src/screens/detail_sloka_screen.dart';
import 'package:vedanta_frontend/src/screens/search_sloka_screen.dart';
import 'package:vedanta_frontend/src/widgets/gita_card_widget.dart';
import 'package:vedanta_frontend/src/widgets/input_rounded_with_icon_widget.dart';

class GitaWidget extends StatefulWidget {
  const GitaWidget({super.key});

  @override
  State<GitaWidget> createState() => _GitaWidgetState();
}

class _GitaWidgetState extends State<GitaWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<dynamic> _babList = [];
  final List<dynamic> _slokaList = [];
  int? _currentBab = 1;
  late Future<void> _futureBabList = Future.value();
  late Future<void> _futureSlokaList = Future.value();
  // late Future<Map<String, dynamic>> _futureBacaanTerakhir = Future.value({});

  @override
  void initState() {
    super.initState();
    _futureBabList = _getBabList();
    _futureSlokaList = _getSlokaList(_currentBab!);
    // _futureBacaanTerakhir = _getBacaanTerakhir();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              InputRoundedWithIcon(
                controller: _controller,
                icon: Icons.search,
                label: 'Search...',
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
                      content: Text('Sloka found'),
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
              FutureBuilder(
                future: gitaProvider.getBacaanTerakhir(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return GitaCardWidget(
                      headerText: 'Bacaan Terakhir',
                      subHeaderText:
                          "BAB ${snapshot.data!['bacaan']['babNumber']} : SLOKA ${snapshot.data!['bacaan']['slokaNumber']}",
                      text: snapshot.data!['bacaan']['babTitle'],
                      buttonText: 'Lanjutkan Membaca',
                    );
                  }
                },
              ),
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
                                      horizontal: 10),
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
                                        _futureSlokaList =
                                            _getSlokaList(value!);
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
                                  _slokaListWidget(_slokaList, (e) => true),
                                  _slokaListWidget(
                                      _slokaList, (e) => e['isLiked'] == true),
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
      List<dynamic> slokaList, bool Function(dynamic value) filter) {
    return FutureBuilder<void>(
      future: _futureSlokaList,
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
          final filtered = _slokaList.where(filter).toList();
          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailSlokaScreen(
                        bab: _currentBab!,
                        sloka: filtered[index]['number'],
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
                  'Sloka ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Bacaan Sloka ${filtered[index]['number']}"),
                trailing: InkWell(
                  onTap: () async {
                    // Add to favorite
                    final gitaProvider =
                        Provider.of<GitaProvider>(context, listen: false);
                    final response = await gitaProvider.likeSloka(
                        _currentBab!, filtered[index]['number']);
                    if (response['error']) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(response['message']),
                        backgroundColor: Colors.red,
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Sloka added to favorite'),
                        backgroundColor: Colors.green,
                      ));
                      setState(() {
                        filtered[index]['isLiked'] = true;
                      });
                    }
                  },
                  child: filtered[index]['isLiked']
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.pinkAccent,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          color: Colors.grey,
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
