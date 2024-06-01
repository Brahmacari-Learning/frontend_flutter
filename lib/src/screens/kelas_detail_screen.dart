import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/class_provider.dart';
import 'package:vedanta_frontend/src/services/auth_wraper.dart';
import 'package:vedanta_frontend/src/widgets/avatar_widget.dart';

class KelasDetailScreen extends StatefulWidget {
  final int id;
  const KelasDetailScreen({super.key, required this.id});

  @override
  State<KelasDetailScreen> createState() => _KelasDetailScreenState();
}

class _KelasDetailScreenState extends State<KelasDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // provider class
    final classProvider = Provider.of<ClassProvider>(context);

    return AuthWrapper(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Detail Kelas',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.purple, // Warna pink untuk back button
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            bottom: const TabBar(
              labelColor: Colors.purple,
              unselectedLabelColor: Color.fromARGB(255, 96, 96, 96),
              indicatorColor: Colors.purple,
              tabs: [
                Tab(text: "Tugas"),
                Tab(text: "Anggota"),
              ],
            ),
          ),
          body: TabBarView(children: [
            _TugasTab(id: widget.id),
            _ListSiswa(provider: classProvider, id: widget.id),
          ]),
        ),
      ),
    );
  }
}

class _TugasTab extends StatelessWidget {
  final int id;
  const _TugasTab({required this.id});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _ListSiswa extends StatefulWidget {
  final ClassProvider provider;
  final int id;

  const _ListSiswa({
    required this.provider,
    required this.id,
  });

  @override
  _ListSiswaState createState() => _ListSiswaState();
}

class _ListSiswaState extends State<_ListSiswa> {
  Future<void> _refreshList() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.provider.classMember(widget.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            child: const CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Text('An error occurred');
        }
        var members = snapshot.data!['members'];
        return RefreshIndicator(
          onRefresh: _refreshList,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 330,
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 20),
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.1),
                              offset: const Offset(0, -2),
                              blurRadius: 7,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                AvatarWidget(
                                    avatarUrl: members[index]['profilePicture'],
                                    name: members[index]['name']),
                                const SizedBox(width: 10),
                                Text(
                                  members[index]['name'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
