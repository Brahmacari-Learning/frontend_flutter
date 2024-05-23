import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class BubbleChatWidget extends StatelessWidget {
  final String image;
  final String message;
  final bool isUser;
  final bool error;
  const BubbleChatWidget(
      {super.key,
      required this.message,
      this.image = 'lib/assets/images/ganabot.png',
      this.isUser = false,
      this.error = false});

  @override
  Widget build(BuildContext context) {
    Widget botBubble = Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Image.asset(
              fit: BoxFit.fill,
              image,
              width: 15,
              height: 15,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 10, right: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: MarkdownBody(
              data: message,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          // Gap
        ],
      ),
    );

    Widget userBubble = Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 20, right: 10),
            decoration: BoxDecoration(
              color: Colors.purpleAccent[100],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
            ),
            child: MarkdownBody(
              data: message,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          // Avatar
          // Container(
          //   padding: const EdgeInsets.all(10),
          //   margin: const EdgeInsets.only(right: 20),
          //   decoration: BoxDecoration(
          //     color: Colors.grey[200],
          //     borderRadius: BorderRadius.circular(50),
          //   ),
          //   child: Image.asset(
          //     fit: BoxFit.fill,
          //     image,
          //     width: 15,
          //     height: 15,
          //   ),
          // ),
          // Gap
        ],
      ),
    );

    Widget errorBubble = Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Image.asset(
              fit: BoxFit.fill,
              image,
              width: 15,
              height: 15,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 10, right: 20),
            decoration: BoxDecoration(
              color: Colors.redAccent[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: MarkdownBody(
              data:
                  "*Maaf Terjadi kesalahan, pesan tidak dapat dimuat. Cobalah Beberapa Saat Lagi*",
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          // Gap
        ],
      ),
    );

    if (!error) {
      return isUser ? userBubble : botBubble;
    } else {
      return errorBubble;
    }
  }
}
