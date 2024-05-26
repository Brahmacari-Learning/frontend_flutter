import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/discussion_provider.dart';
import 'package:vedanta_frontend/src/screens/detail_discussion_screen.dart';
import 'package:vedanta_frontend/src/screens/search_discussion_screen.dart';

class DiscussionWidget extends StatefulWidget {
  const DiscussionWidget({super.key});

  @override
  State<DiscussionWidget> createState() => _DiscussionWidgetState();
}

class _DiscussionWidgetState extends State<DiscussionWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // provider
    final discussionProvider =
        Provider.of<DiscussionProvider>(context, listen: false);
    // Search form and list of discussions
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Search form
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
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () async {
                    final response = await discussionProvider
                        .searchDiscussion(_controller.text.trim());
                    if (response['error']) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(response['message']),
                        backgroundColor: Colors.red,
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Search success!'),
                        backgroundColor: Colors.green,
                      ));
                      // navigate to detail sloka screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchDiscussionScreen(
                            discussions: response['discussions'],
                          ),
                        ),
                      );
                    }
                  },
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
          // List of discussions
          Expanded(
            child: FutureBuilder(
              future: discussionProvider.getDiscussions(1),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  print(snapshot.data);
                  final discussions = snapshot.data!['discussions'];
                  return ListView.builder(
                    itemCount: discussions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(discussions[index]['title']),
                          subtitle: Text(discussions[index]['creator']['name']),
                          onTap: () {
                            // Navigate to the detail discussion screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailDiscussionScreen(
                                      id: discussions[index]['id'])),
                            );
                          },
                          // like button
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: (discussions[index]['isLiked'])
                                      ? Icon(Icons.favorite, color: Colors.red)
                                      : Icon(Icons.favorite_border,
                                          color: Colors.red),
                                  onPressed: () async {
                                    final response =
                                        await discussionProvider.likeDiscussion(
                                            discussions[index]['id']);
                                    print(response);
                                    if (response['error']) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(response['message']),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Like success!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      setState(() {
                                        discussions[index]['isLiked'] =
                                            !discussions[index]['isLiked'];
                                      });
                                    }
                                  },
                                ),
                                // Delete button
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    final response = await discussionProvider
                                        .deleteDiscussion(
                                            discussions[index]['id']);
                                    if (response['error']) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(response['message']),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Delete success!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      // Refresh the list of discussions
                                      setState(() {});
                                    }
                                  },
                                ),
                              ],
                            ),
                          ));
                    },
                  );
                }
              },
            ),
          ),
          // Create new discussion
          ElevatedButton(
            onPressed: () async {
              final response = await discussionProvider.createDiscussion(
                  'New Discussion', 'Content of new discussion');
              if (response['error']) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(response['message']),
                  backgroundColor: Colors.red,
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Create discussion success!'),
                  backgroundColor: Colors.green,
                ));

                // Refresh the list of discussions
                setState(() {});
              }
            },
            child: const Text('Create Discussion'),
          ),
        ],
      ),
    );
  }
}
