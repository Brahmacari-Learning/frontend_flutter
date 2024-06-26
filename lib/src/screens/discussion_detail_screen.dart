import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/discussion_provider.dart';
import 'package:vedanta_frontend/src/screens/discussion_search_screen.dart';
import 'package:vedanta_frontend/src/services/auth_wraper.dart';
import 'package:vedanta_frontend/src/utils.dart';
import 'package:vedanta_frontend/src/widgets/avatar_widget.dart';
import 'package:vedanta_frontend/src/widgets/input_rounded_with_icon_widget.dart';
import 'package:vedanta_frontend/src/widgets/like_icon_widget.dart';

class DetailDiscussionScreen extends StatefulWidget {
  final int id;
  const DetailDiscussionScreen({super.key, required this.id});

  @override
  State<DetailDiscussionScreen> createState() => _DetailDiscussionScreenState();
}

class _DetailDiscussionScreenState extends State<DetailDiscussionScreen> {
  final TextEditingController _komentarController = TextEditingController();
  final TextEditingController _controllerSearch = TextEditingController();
  final FocusNode focusNode = FocusNode();

  int? replyingId;

  @override
  void dispose() {
    _komentarController.dispose();
    _controllerSearch.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(BuildContext context, int replyId) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final discussionProvider =
        Provider.of<DiscussionProvider>(context, listen: false);

    final bool? deleteConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: const Text('Apakah anda yakin ingin menghapus balasan?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (deleteConfirmed == true) {
      final response =
          await discussionProvider.deleteDiscussionReply(widget.id, replyId);
      if (response['error']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.purple,
          ),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Berhasil!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // provider
    final discussionProvider =
        Provider.of<DiscussionProvider>(context, listen: false);

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Detail discussion
    return AuthWrapper(
      child: Scaffold(
        appBar: _detailDiscussionAppBar(
            discussionProvider, context, scaffoldMessenger),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: discussionProvider.getDiscussion(widget.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.4,
                          ),
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      final data = snapshot.data!['discussion'];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profil, nama, waktu diskusi
                          _headerUserInfo(data, context),
                          const SizedBox(height: 10),
                          // Judul dan deskripsi
                          _questionDiscussion(data),
                          const SizedBox(height: 20),
                          // Statistik diskusi (jawaban & like)
                          _questionStats(
                              data, discussionProvider, scaffoldMessenger),
                          const Divider(
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                          ),
                          const SizedBox(height: 20),
                          InputRoundedWithIcon(
                            controller: _komentarController,
                            focusNode: focusNode,
                            icon: Icons.send,
                            label: 'Tulis komentar',
                            onEnter: (value) async {
                              if (replyingId != null) {
                                final response =
                                    await discussionProvider.createReplyToReply(
                                  widget.id,
                                  replyingId!,
                                  _komentarController.text.trim(),
                                );
                                if (response['error'] == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(response['message']),
                                      backgroundColor: Colors.purple,
                                    ),
                                  );
                                } else {
                                  _komentarController.clear();
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  replyingId = null;
                                  setState(() {});
                                }
                              } else {
                                final response =
                                    await discussionProvider.createReply(
                                  widget.id,
                                  _komentarController.text.trim(),
                                );
                                if (response['error'] == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(response['message']),
                                      backgroundColor: Colors.purple,
                                    ),
                                  );
                                } else {
                                  _komentarController.clear();
                                  setState(() {});
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          // Replies with nested replies
                          _listReply(data, discussionProvider, context,
                              scaffoldMessenger),
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

  ListView _listReply(data, DiscussionProvider discussionProvider,
      BuildContext context, ScaffoldMessengerState scaffoldMessenger) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data['replies'].length,
      itemBuilder: (context, index) {
        final reply = data['replies'][index];
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AvatarWidget(
                    avatarUrl: reply['creator']['profilePicture'],
                    name: reply['creator']['name'],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reply['creator']['name'],
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          reply['reply'],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                replyingId = reply['id'];
                                focusNode.requestFocus();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal:
                                              16.0), // Adjust padding as needed
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              replyingId = null;
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Membalas komentar ${reply['creator']['name']}',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    duration: const Duration(hours: 1),
                                  ),
                                );
                              },
                              child: const Text(
                                "Balas",
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () async {
                                _confirmDelete(context, reply['id']);
                              },
                              child: const Text(
                                "Hapus",
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              formatDate(
                                reply['createdAt'],
                              ),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      icon: LikeIconWithCount(
                        isLiked: reply['isLiked'],
                        likesCount: reply['likesCount'],
                      ),
                      onPressed: () async {
                        final response = await discussionProvider.likeReply(
                          widget.id,
                          reply['id'],
                          !reply['isLiked'],
                        );
                        if (response['error']) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(response['message']),
                              backgroundColor: Colors.purple,
                            ),
                          );
                        } else {
                          setState(() {});
                        }
                      })
                ],
              ),
            ),
            // Nested replies (make it different by adding padding)
            _nestedReply(reply),
          ],
        );
      },
    );
  }

  Padding _nestedReply(reply) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reply['replies'].length,
        itemBuilder: (context, index) {
          final nestedReply = reply['replies'][index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarWidget(
                  avatarUrl: nestedReply['creator']['profilePicture'],
                  name: nestedReply['creator']['name'],
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nestedReply['creator']['name'],
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        nestedReply['reply'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            formatDate(nestedReply['createdAt']),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Row _questionStats(data, DiscussionProvider discussionProvider,
      ScaffoldMessengerState scaffoldMessenger) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${data['repliesCount']} Jawaban',
          style: const TextStyle(
              fontSize: 16, color: Colors.purple, fontWeight: FontWeight.w500),
        ),
        IconButton(
          icon: LikeIconWithCount(
            isLiked: data['isLiked'],
            likesCount: data['likesCount'],
          ),
          onPressed: () async {
            final response = await discussionProvider.likeDiscussion(
              widget.id,
              !data['isLiked'],
            );
            if (response['error']) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(response['message']),
                  backgroundColor: Colors.purple,
                ),
              );
            } else {
              setState(() {});
            }
          },
        )
      ],
    );
  }

  Column _questionDiscussion(data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data['title'],
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Row _headerUserInfo(data, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Image Avatar
        Row(
          children: [
            AvatarWidget(
              avatarUrl: data['creator']['profilePicture'],
              name: data['creator']['name'],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.43),
                  child: Text(
                    data['creator']['name'],
                    style: const TextStyle(
                      color: Colors.purple,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const Text(
                  "Online",
                  style: TextStyle(
                    color: Color(0xFF3ABF38),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ],
        ),
        Text(
          formatDate(data['createdAt']),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  AppBar _detailDiscussionAppBar(DiscussionProvider discussionProvider,
      BuildContext context, ScaffoldMessengerState scaffoldMessenger) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 70,
      shadowColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.purple, // Warna pink untuk back button
      ),
      // icon back
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pop(context);
        },
      ),
      title: InputRoundedWithIcon(
        controller: _controllerSearch,
        icon: Icons.search,
        label: 'Cari diskusi...',
        onEnter: (value) async {
          final response = await discussionProvider
              .searchDiscussion(_controllerSearch.text.trim());
          if (response['error']) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(response['message']),
              backgroundColor: Colors.purple,
            ));
          } else {
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
    );
  }
}
