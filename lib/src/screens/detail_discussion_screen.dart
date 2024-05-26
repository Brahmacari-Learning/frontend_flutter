import 'dart:math';
import 'package:intl/intl.dart';
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
  final TextEditingController _komentarController = TextEditingController();

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy').format(dateTime);
  }
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
                      return Center(
                        child: Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                          child: CircularProgressIndicator()
                        ),
                      );
                    } else {
                      final data = snapshot.data!['discussion'];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Image Avatar
                              Container(
                                child: Row(
                                  children: [
                                    if (data['creator']['profilePicture'] != null)
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          data['creator']['profilePicture'],
                                        ),
                                        radius: 23,
                                      )
                                    else
                                      CircleAvatar(
                                        child: Text(
                                          data['creator']['name'][0].toUpperCase(),
                                        ),
                                      ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.43),
                                          child: Text(
                                            data['creator']['name'],
                                            style: TextStyle(
                                              color: Color(0xFFB95A92),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Text(
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
                              ),
                              Text(
                                formatDate(data['createdAt']),
                                style: TextStyle(
                                  fontSize: 16,
                                  // color: Color(0xFF666666),
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text(
                            data['title'],
                            style: TextStyle(
                              fontSize: 19,
                              // color: Color(0xFF030303),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            data['body'],
                            style: TextStyle(
                              fontSize: 16,
                              // color: Color(0xFF666666),
                              fontWeight: FontWeight.w400
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${data['repliesCount']} Jawaban',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFB95A92),
                                  fontWeight: FontWeight.w500
                                )
                              ),
                              Container(
                                child: Row(
                                  children: [ 
                                    Icon(
                                      Icons.favorite,
                                      color: Color(0xFFB95A92)
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      '${data['likesCount']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFFB95A92),
                                        fontWeight: FontWeight.w500
                                      )
                                    ),
                                  ],
                                )
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(height: 20),
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
                                    controller: _komentarController,
                                    decoration: const InputDecoration(
                                      hintText: 'Tulis komentar',
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
                                        .createReply(widget.id, _komentarController.text.trim());

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
                                      _komentarController.clear();
                                      // Refresh the list of discussions
                                      setState(() {});
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.send,
                                    color: Color(0xFFB95A92),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          // Replies with nested replies
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data['replies'].length,
                            itemBuilder: (context, index) {
                              final reply = data['replies'][index];
                              return Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 7),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        (reply['creator']['profilePicture'] != null)
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
                                        SizedBox(width: 10,),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.6,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                reply['creator']['name'],
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                reply['reply'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      
                                                    },
                                                    child: Text(
                                                      "Balas",
                                                      style: TextStyle(
                                                        color: Color(0xFF666666),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Text(
                                                    formatDate(reply['createdAt']),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
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
                                            Text(
                                              '${reply['likesCount']}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500
                                              )
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  // ListTile(
                                  //   leading: (reply['creator']
                                  //               ['profilePicture'] !=
                                  //           null)
                                  //       ? CircleAvatar(
                                  //           backgroundImage: NetworkImage(
                                  //             reply['creator']
                                  //                 ['profilePicture'],
                                  //           ),
                                  //         )
                                  //       : CircleAvatar(
                                  //           child: Text(
                                  //             reply['creator']['name'][0]
                                  //                 .toUpperCase(),
                                  //           ),
                                  //         ),
                                  //   title: Text(
                                  //     reply['creator']['name'],
                                  //     style: TextStyle(
                                  //       fontSize: 17,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  //   subtitle: Text(
                                  //     reply['reply'],
                                  //     style: TextStyle(
                                  //       fontSize: 16,
                                  //     ),
                                  //   ),
                                  //   // reply button and like button
                                  //   trailing: Container(
                                  //     width: MediaQuery.of(context).size.width * 0.245,
                                  //     child: Column(
                                  //       children: [
                                  //         Row(
                                  //           children: [
                                  //             IconButton(
                                  //               icon: (reply['isLiked'])
                                  //                   ? Icon(Icons.favorite,
                                  //                       color: Colors.red)
                                  //                   : Icon(Icons.favorite_border,
                                  //                       color: Colors.red),
                                  //               onPressed: () async {
                                  //                 final response =
                                  //                     await discussionProvider
                                  //                         .likeReply(widget.id,
                                  //                             reply['id']);
                                  //                 print(response);
                                  //                 if (response['error']) {
                                  //                   ScaffoldMessenger.of(context)
                                  //                       .showSnackBar(
                                  //                     SnackBar(
                                  //                       content: Text(
                                  //                           response['message']),
                                  //                       backgroundColor: Colors.red,
                                  //                     ),
                                  //                   );
                                  //                 } else {
                                  //                   ScaffoldMessenger.of(context)
                                  //                       .showSnackBar(
                                  //                     SnackBar(
                                  //                       content: const Text(
                                  //                           'Reply liked'),
                                  //                       backgroundColor:
                                  //                           Colors.green,
                                  //                     ),
                                  //                   );
                                  //                   // Refresh the list of discussions
                                  //                   setState(() {});
                                  //                 }
                                  //               },
                                  //             ),
                                  //             IconButton(
                                  //               icon: const Icon(Icons.reply),
                                  //               onPressed: () async {
                                  //                 final response =
                                  //                     await discussionProvider
                                  //                         .createReplyToReply(
                                  //                             widget.id,
                                  //                             reply['id'],
                                  //                             'Reply to reply');
                                  //                 if (response['error']) {
                                  //                   ScaffoldMessenger.of(context)
                                  //                       .showSnackBar(
                                  //                     SnackBar(
                                  //                       content: Text(
                                  //                           response['message']),
                                  //                       backgroundColor: Colors.red,
                                  //                     ),
                                  //                   );
                                  //                 } else {
                                  //                   ScaffoldMessenger.of(context)
                                  //                       .showSnackBar(
                                  //                     SnackBar(
                                  //                       content: const Text(
                                  //                           'Reply created'),
                                  //                       backgroundColor:
                                  //                           Colors.green,
                                  //                     ),
                                  //                   );
                                  //                   // Refresh the list of discussions
                                  //                   setState(() {});
                                  //                 }
                                  //               },
                                  //             ),
                                  //           ],
                                  //         ),
                                  //         Text(
                                  //           formatDate(reply['createdAt']),
                                  //           style: TextStyle(
                                  //             fontSize: 5,
                                  //             // color: Color(0xFF666666),
                                  //             fontWeight: FontWeight.w400
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // Nested replies (make it different by adding padding)
                                  Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
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
