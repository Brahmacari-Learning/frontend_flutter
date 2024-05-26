import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/discussion_provider.dart';

class DetailDiscussionScreen extends StatefulWidget {
  final int id;
  const DetailDiscussionScreen({super.key, required this.id});

  @override
  State<DetailDiscussionScreen> createState() => _DetailDiscussionScreenState();
}

class _DetailDiscussionScreenState extends State<DetailDiscussionScreen> {
  @override
  Widget build(BuildContext context) {
    // provider
    final discussionProvider =
        Provider.of<DiscussionProvider>(context, listen: false);
    // Detail discussion
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Discussion'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: discussionProvider.getDiscussion(widget.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      final data = snapshot.data!['discussion'];
                      return Column(
                        children: [
                          // Image Avatar
                          if (data['creator']['profilePicture'] != null)
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                data['creator']['profilePicture'],
                              ),
                            )
                          else
                            CircleAvatar(
                              child: Text(
                                data['creator']['name'][0].toUpperCase(),
                              ),
                            ),
                          Text(
                            data['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            data['body'],
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Likes: ${data['likesCount']} | Replies: ${data['repliesCount']}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Created At: ${data['createdAt']}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Creator: ${data['creator']['name']}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Replies Button
                          ElevatedButton(
                            onPressed: () async {
                              final response = await discussionProvider
                                  .createReply(widget.id, 'America Ya..');

                              if (response['error'] == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(response['message']),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Reply created'),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // Refresh the list of discussions
                                setState(() {});
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: const Text('Replies'),
                          ),
                          const SizedBox(height: 20),
                          // Replies with nested replies
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: data['replies'].length,
                            itemBuilder: (context, index) {
                              final reply = data['replies'][index];
                              return Column(
                                children: [
                                  ListTile(
                                    leading: (reply['creator']
                                                ['profilePicture'] !=
                                            null)
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              reply['creator']
                                                  ['profilePicture'],
                                            ),
                                          )
                                        : CircleAvatar(
                                            child: Text(
                                              reply['creator']['name'][0]
                                                  .toUpperCase(),
                                            ),
                                          ),
                                    title: Text(
                                      reply['reply'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Likes: ${reply['likesCount']} | Created At: ${reply['createdAt']} | Creator: ${reply['creator']['name']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    // reply button and like button
                                    trailing: Container(
                                      width: 100,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: (reply['isLiked'])
                                                ? Icon(Icons.favorite,
                                                    color: Colors.red)
                                                : Icon(Icons.favorite_border,
                                                    color: Colors.red),
                                            onPressed: () async {
                                              final response =
                                                  await discussionProvider
                                                      .likeReply(widget.id,
                                                          reply['id']);
                                              print(response);
                                              if (response['error']) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        response['message']),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: const Text(
                                                        'Reply liked'),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                                // Refresh the list of discussions
                                                setState(() {});
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.reply),
                                            onPressed: () async {
                                              final response =
                                                  await discussionProvider
                                                      .createReplyToReply(
                                                          widget.id,
                                                          reply['id'],
                                                          'Reply to reply');
                                              if (response['error']) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        response['message']),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: const Text(
                                                        'Reply created'),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                                // Refresh the list of discussions
                                                setState(() {});
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Nested replies (make it different by adding padding)
                                  Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: reply['replies'].length,
                                      itemBuilder: (context, index) {
                                        final nestedReply =
                                            reply['replies'][index];
                                        return ListTile(
                                          leading: (nestedReply['creator']
                                                      ['profilePicture'] !=
                                                  null)
                                              ? CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    nestedReply['creator']
                                                        ['profilePicture'],
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  child: Text(
                                                    nestedReply['creator']
                                                            ['name'][0]
                                                        .toUpperCase(),
                                                  ),
                                                ),
                                          title: Text(
                                            nestedReply['reply'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'Likes: ${nestedReply['likesCount']} | Created At: ${nestedReply['createdAt']} | Creator: ${nestedReply['creator']['name']}',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
