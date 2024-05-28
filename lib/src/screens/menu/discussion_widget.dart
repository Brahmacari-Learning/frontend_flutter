import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/discussion_provider.dart';
import 'package:vedanta_frontend/src/screens/detail_discussion_screen.dart';
import 'package:vedanta_frontend/src/screens/search_discussion_screen.dart';
import 'package:vedanta_frontend/src/widgets/input_rounded_with_icon_widget.dart';
import 'package:vedanta_frontend/src/widgets/like_icon_widget.dart';

class DiscussionWidget extends StatefulWidget {
  const DiscussionWidget({super.key});

  @override
  State<DiscussionWidget> createState() => _DiscussionWidgetState();
}

class _DiscussionWidgetState extends State<DiscussionWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // provider
    final discussionProvider =
        Provider.of<DiscussionProvider>(context, listen: false);
    // Search form and list of discussions
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        children: [
          InputRoundedWithIcon(
            controller: _controller,
            icon: Icons.search,
            label: 'Cari diskusi...',
            onEnter: (value) async {
              final response = await discussionProvider
                  .searchDiscussion(_controller.text.trim());
              if (response['error']) {
                scaffoldMessenger.showSnackBar(SnackBar(
                  content: Text(response['message']),
                  backgroundColor: Colors.red,
                ));
              } else {
                scaffoldMessenger.showSnackBar(const SnackBar(
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
                  final discussions = snapshot.data!['discussions'];
                  return ListView.builder(
                    itemCount: discussions.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailDiscussionScreen(
                                  id: discussions[index]['id']),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.73,
                                      ),
                                      child: Text(
                                        discussions[index]['title'],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    Text(discussions[index]['creator']['name']),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${discussions[index]['repliesCount']} Jawaban",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFB95A92),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                IconButton(
                                  icon: LikeIconWithCount(
                                    isLiked: discussions[index]['isLiked'],
                                    likesCount: discussions[index]
                                        ['likesCount'],
                                  ),
                                  onPressed: () async {
                                    final response =
                                        await discussionProvider.likeDiscussion(
                                            discussions[index]['id'],
                                            !discussions[index]['isLiked']);
                                    if (response['error']) {
                                      scaffoldMessenger.showSnackBar(
                                        SnackBar(
                                          content: Text(response['message']),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else {
                                      scaffoldMessenger.showSnackBar(
                                        const SnackBar(
                                          content: Text('Success!'),
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
                              ],
                            ),
                            const Divider(
                              thickness: 1,
                              indent: 0,
                              endIndent: 0,
                            ),
                          ],
                        ),
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
                scaffoldMessenger.showSnackBar(SnackBar(
                  content: Text(response['message']),
                  backgroundColor: Colors.red,
                ));
              } else {
                scaffoldMessenger.showSnackBar(const SnackBar(
                  content: Text('Create discussion success!'),
                  backgroundColor: Colors.green,
                ));

                // Refresh the list of discussions
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              backgroundColor: const Color.fromARGB(238, 142, 56, 142),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(
                  width: 10,
                ),
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
