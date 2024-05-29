import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/discussion_provider.dart';
import 'package:vedanta_frontend/src/screens/create_discussion.dart';
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
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _discussions = [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _loadDiscussions();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreDiscussions();
      }
    });
  }

  Future<void> _loadDiscussions() async {
    setState(() {
      _isLoading = true;
    });

    final discussionProvider =
        Provider.of<DiscussionProvider>(context, listen: false);
    final response = await discussionProvider.getDiscussions(_currentPage);

    if (!response['error']) {
      if (mounted) {
        setState(() {
          _discussions = response['discussions'];
          _hasMoreData = response['discussions'].length ==
              10; // Assume 10 is the page limit
        });
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreDiscussions() async {
    if (!_hasMoreData || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    _currentPage++;
    final discussionProvider =
        Provider.of<DiscussionProvider>(context, listen: false);
    final response = await discussionProvider.getDiscussions(_currentPage);

    if (!response['error']) {
      if (mounted) {
        setState(() {
          _discussions.addAll(response['discussions']);
          _hasMoreData = response['discussions'].length == 10;
        });
      }
    } else {
      _currentPage--; // Revert the page increment if there was an error
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // provider
    final discussionProvider =
        Provider.of<DiscussionProvider>(context, listen: false);
    // Search form and list of discussions
    return SafeArea(
      child: Container(
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
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchDiscussionScreen(
                        discussions: response['discussions'],
                      ),
                    ),
                  );
                  setState(() {
                    _isLoading = true;
                    _currentPage = 1;
                    _discussions.clear();
                    _loadDiscussions();
                  });
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            // List of discussions
            Expanded(
              child: _isLoading && _discussions.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _discussions.length + (_hasMoreData ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _discussions.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final discussion = _discussions[index];
                        return InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailDiscussionScreen(
                                    id: discussion['id']),
                              ),
                            );
                            setState(() {
                              _isLoading = true;
                              _currentPage = 1;
                              _discussions.clear();
                              _loadDiscussions();
                            });
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.73,
                                        ),
                                        child: Text(
                                          discussion['title'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Text(discussion['creator']['name']),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${discussion['repliesCount']} Jawaban",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFB95A92),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  IconButton(
                                    icon: LikeIconWithCount(
                                      isLiked: discussion['isLiked'],
                                      likesCount: discussion['likesCount'],
                                    ),
                                    onPressed: () async {
                                      final response = await discussionProvider
                                          .likeDiscussion(discussion['id'],
                                              !discussion['isLiked']);
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
                                          discussion['isLiked'] =
                                              !discussion['isLiked'];
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
                    ),
            ),
            // Create new discussion
            ElevatedButton(
              onPressed: () async {
                // navigate to create discussion screen
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateDiscussionScreen(),
                  ),
                );
                // refresh list of discussions
                setState(() {
                  _isLoading = true;
                  _currentPage = 1;
                  _discussions.clear();
                  _loadDiscussions();
                });
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
