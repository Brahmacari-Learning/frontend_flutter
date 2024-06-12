import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/stage_provider.dart';
import 'package:vedanta_frontend/src/widgets/avatar_widget.dart';
import 'package:vedanta_frontend/src/widgets/button_option_full_width.dart';
import 'package:vedanta_frontend/src/widgets/no_internet.dart';

class KlasemenScreen extends StatefulWidget {
  final int id;
  const KlasemenScreen({super.key, required this.id});

  @override
  State<KlasemenScreen> createState() => _KlasemenScreenState();
}

class _KlasemenScreenState extends State<KlasemenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C7AFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF9C7AFF),
      body: const KlasemenContent(),
    );
  }
}

class KlasemenContent extends StatefulWidget {
  const KlasemenContent({super.key});

  @override
  State<KlasemenContent> createState() => _KlasemenContentState();
}

class _KlasemenContentState extends State<KlasemenContent> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StageProvider>(context, listen: false);
    return FutureBuilder(
        future: provider.klasemen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const NoInternet();
          }
          final currentUserIndex = snapshot.data!['currentUserIndex'];
          final data = snapshot.data!['klasemen'];
          return Column(
            children: [
              const SizedBox(
                height: 90,
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 330,
                  ),
                  Positioned(
                    left: 5,
                    bottom: 0,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'lib/assets/images/klasemen-block-1.png',
                          width: 180,
                        ),
                        Positioned(
                          top: -90,
                          left: 30,
                          child: AvatarWidget(
                            avatarUrl: data[1]['profilePicture'],
                            name: data[1]['name'],
                            radius: 45,
                          ),
                        ),
                        Positioned(
                          // alignment: Alignment.center,
                          left: 55,
                          child: Transform.rotate(
                            angle: (pi / 180) * -5,
                            child: Column(
                              children: [
                                const Text(
                                  '2',
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${data[1]['points']}pt',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -27,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'lib/assets/images/klasemen-block-2.png',
                          width: 180,
                        ),
                        Positioned(
                          top: -80,
                          child: AvatarWidget(
                            avatarUrl: data[0]['profilePicture'],
                            name: data[0]['name'],
                            radius: 45,
                          ),
                        ),
                        Positioned(
                          child: Column(
                            children: [
                              const Text(
                                '1',
                                style: TextStyle(
                                  fontSize: 105,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${data[0]['points']}pt',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'lib/assets/images/klasemen-block-3.png',
                          width: 190,
                        ),
                        Positioned(
                            top: -90,
                            right: 30,
                            child: AvatarWidget(
                              avatarUrl: data[2]['profilePicture'],
                              name: data[2]['name'],
                              radius: 45,
                            )),
                        Positioned(
                          // alignment: Alignment.center,
                          right: 60,
                          child: Transform.rotate(
                            angle: (pi / 180) * 3,
                            child: Column(
                              children: [
                                const Text(
                                  '3',
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${data[2]['points']}pt',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: -30,
                    child: Image.asset(
                      'lib/assets/images/circle-purple.png',
                    ),
                  ),
                  Positioned(
                    top: -70,
                    left: -30,
                    child: Image.asset(
                      'lib/assets/images/circle-purple.png',
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                for (int i = 3; i < data.length; i++) ...[
                                  listItem(i, data)
                                ]
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 1.0,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: listItem(currentUserIndex, data),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }

  Padding listItem(int i, List<dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '${i + 1}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                width: 20,
              ),
              AvatarWidget(
                  avatarUrl: data[i]['profilePicture'], name: data[i]['name']),
              const SizedBox(
                width: 20,
              ),
              Text(
                '${data[i]['name']}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(300)),
            child: Text('${data[i]['points']}pt'),
          )
        ],
      ),
    );
  }
}

class BelumCukupData extends StatelessWidget {
  const BelumCukupData({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('lib/assets/images/presensi_harian.png', width: 300),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Belum cukup data untuk ditampilkan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: ButtonOptionFullWidth(
              text: "Kembali",
              onClick: () {
                Navigator.pop(context);
              },
              color: const Color(0xFFFF9051),
            ),
          )
        ],
      ),
    );
  }
}
