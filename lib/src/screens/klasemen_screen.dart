import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/widgets/avatar_widget.dart';
import 'package:vedanta_frontend/src/widgets/button_option_full_width.dart';

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
      body: KlasemenContent(),
    );
  }
}

class KlasemenContent extends StatelessWidget {
  KlasemenContent({super.key});

  final List<Map<String, dynamic>> data = [
    {
      "image":
          "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/197911142/original/043a07c41cad114ab97c5cf4722d50aa66baee3a/make-a-cute-avatar-for-you.jpeg",
      "name": "Yudhi",
      "score": 425,
    },
    {
      "image":
          "https://i.pinimg.com/474x/ca/3a/5b/ca3a5b2d77af1c1ba032ebe69815029f.jpg",
      "name": "Pastika Febriana",
      "score": 413,
    },
    {
      "image":
          "https://hybrid.co.id/wp-content/uploads/2016/12/Backpacking-Android-Apps-Mac-Wallpapers-on-Market-1858872426.jpeg",
      "name": "Marino",
      "score": 387,
    },
    {
      "image": null,
      "name": "Mahardika",
      "score": 325,
    },
    {
      "image":
          "https://cdn.hmjtiundiksha.com/uploads/vedanta/profile-picture/665091551f43e.jpeg",
      "name": "Andre Kusuma",
      "score": 212,
    },
    {
      "image": null,
      "name": "Yudhi",
      "score": 43,
    },
    {
      "image": null,
      "name": "Leo",
      "score": 43,
    },
    {
      "image": null,
      "name": "Juniarta",
      "score": 43,
    },
    {
      "image": null,
      "name": "Satya",
      "score": 43,
    },
    {
      "image": null,
      "name": "Yoga",
      "score": 12,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(data[1]['image']),
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
                            '${data[1]['score']}pt',
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
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(data[0]['image']),
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
                          '${data[0]['score']}pt',
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
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(data[2]['image']),
                    ),
                  ),
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
                            '${data[2]['score']}pt',
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
                          for (int i = 3; i < data.length; i++) ...[listItem(i)]
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
                    child: listItem(
                      4,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Padding listItem(int i) {
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
              AvatarWidget(avatarUrl: data[i]['image'], name: data[i]['name']),
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
            child: Text('${data[i]['score']}pt'),
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
