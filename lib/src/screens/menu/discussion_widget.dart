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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        children: [
          // Search form
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0.3,
                  blurRadius: 8,
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
                      hintText: 'Cari diskusi...',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
                  child: const Icon(
                    Icons.search,
                    color: Color(0xFFB95A92),
                  ),
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
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              discussions[index]['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
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
                            trailing: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.13,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: (discussions[index]['isLiked'])
                                        ? const Icon(Icons.favorite, color: Colors.red)
                                        : const Icon(Icons.favorite_border,
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
                                          const SnackBar(
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
                                  // IconButton(
                                  //   icon: Icon(Icons.delete),
                                  //   onPressed: () async {
                                  //     final response = await discussionProvider
                                  //         .deleteDiscussion(
                                  //             discussions[index]['id']);
                                  //     if (response['error']) {
                                  //       ScaffoldMessenger.of(context)
                                  //           .showSnackBar(
                                  //         SnackBar(
                                  //           content: Text(response['message']),
                                  //           backgroundColor: Colors.red,
                                  //         ),
                                  //       );
                                  //     } else {
                                  //       ScaffoldMessenger.of(context)
                                  //           .showSnackBar(
                                  //         SnackBar(
                                  //           content: Text('Delete success!'),
                                  //           backgroundColor: Colors.green,
                                  //         ),
                                  //       );
                                  //       // Refresh the list of discussions
                                  //       setState(() {});
                                  //     }
                                  //   },
                                  // ),
                                ],
                              ),
                            )
                          ),
                          const Divider(              
                            thickness: 1,
                            indent: 0,
                            endIndent: 0, 
                          ),
                        ],
                      );
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Create discussion success!'),
                  backgroundColor: Colors.green,
                ));

                // Refresh the list of discussions
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              backgroundColor: const Color(0xFFB95A92),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingin berdiskusi tentang suatu hal?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      'Ayo Tanyakan Sesuatu!?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10,),
                Icon(
                  Icons.add_circle_outlined,
                  color: Color(0xFFFFFFFF),
                  size: 50,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
