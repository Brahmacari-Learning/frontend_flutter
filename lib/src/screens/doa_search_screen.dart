import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/screens/doa_detail_screen.dart';
import 'package:vedanta_frontend/src/services/auth_wraper.dart';

class SearchDoaScreen extends StatefulWidget {
  final List<dynamic> doas;
  const SearchDoaScreen({super.key, required this.doas});

  @override
  State<SearchDoaScreen> createState() => _SearchDoaScreenState();
}

class _SearchDoaScreenState extends State<SearchDoaScreen> {
  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cari Doa'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.doas.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text(
                            widget.doas[index]['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            widget.doas[index]['body'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoaDetailScreen(
                                  idDoa: widget.doas[index]['id'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
