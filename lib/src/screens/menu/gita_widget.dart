import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/widgets/gita_card_widget.dart';

class GitaWidget extends StatefulWidget {
  const GitaWidget({super.key});

  @override
  State<GitaWidget> createState() => _GitaWidgetState();
}

class _GitaWidgetState extends State<GitaWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const GitaCardWidget(
                headerText: 'Bacaan Terakhir',
                subHeaderText: 'BAB 1 : SLOKA 1',
                text: 'Arjuna Visada Yoga',
                buttonText: 'Lanjutkan Membaca',
              ),
              const SizedBox(height: 20),
              // Tab widget
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(
                            text: 'Sloka',
                          ),
                          Tab(
                            text: 'Favorit',
                          ),
                        ],
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.purple,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // List view for sloka
                            ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    // Navigate to sloka detail
                                    Navigator.pushNamed(
                                        context, '/sloka-detail');
                                  },
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'lib/assets/images/order_icon.png'),
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
                                  title: Text('Sloka ${index + 1}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  subtitle: const Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                                  trailing: Icon(Icons.favorite_border,
                                      color: Colors.pinkAccent[100]),
                                );
                              },
                            ),
                            // List view for favorit
                            ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {},
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'lib/assets/images/order_icon.png'),
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
                                  title: Text('Sloka ${index + 1}'),
                                  subtitle: const Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                                  trailing: Icon(Icons.favorite,
                                      color: Colors.pinkAccent[100]),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
