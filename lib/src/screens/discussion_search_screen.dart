import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/screens/discussion_detail_screen.dart';
import 'package:vedanta_frontend/src/services/auth_wraper.dart';

class SearchDiscussionScreen extends StatefulWidget {
  final List<dynamic> discussions;
  const SearchDiscussionScreen({super.key, required this.discussions});

  @override
  State<SearchDiscussionScreen> createState() => _SearchDiscussionScreenState();
}

class _SearchDiscussionScreenState extends State<SearchDiscussionScreen> {
  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hasil Pencarian Diskusi'),
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
                    itemCount: widget.discussions.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text(
                            widget.discussions[index]['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            widget.discussions[index]['content'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailDiscussionScreen(
                                  id: widget.discussions[index]['id'],
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
