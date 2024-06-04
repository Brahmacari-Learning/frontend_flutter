import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/chat_provider.dart';
import 'package:vedanta_frontend/src/widgets/bubble_chat_widget.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shimmer/shimmer.dart';

class ChatBotWidget extends StatefulWidget {
  const ChatBotWidget({super.key});

  @override
  State<ChatBotWidget> createState() => _ChatBotWidgetState();
}

class _ChatBotWidgetState extends State<ChatBotWidget> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _chat = [];
  bool _isLoading = false; // Tambahkan variabel _isLoading

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Image.asset(
            fit: BoxFit.fill,
            'lib/assets/images/ganabot.png',
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GaneshaBot',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                "Online",
                style: TextStyle(
                  color: Colors.lightGreenAccent,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      )),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'GaneshBot adalah bot cerdas yang terkoneksi dengan kecerdasan buatan (AI) untuk menyediakan pengalaman interaktif dan responsif kepada pengguna.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Column(
                        children: _chat
                            .map(
                              (e) => BubbleChatWidget(
                                message: e['message'],
                                isUser: e['isUser'],
                                error: e['error'],
                              ),
                            )
                            .toList(),
                      ),
                      if (_isLoading)
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Avatar
                              Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(left: 20),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(1000),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                padding: const EdgeInsets.all(10),
                                margin:
                                    const EdgeInsets.only(left: 10, right: 20),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 50,
                                    height: 50.0,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Gap
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              KeyboardVisibilityBuilder(
                builder: (context, isKeyboardVisible) {
                  if (isKeyboardVisible) {
                    _scrollToBottom();
                  }
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.only(
                      bottom: isKeyboardVisible
                          ? MediaQuery.of(context).viewInsets.bottom
                          : 20,
                      left: 20,
                      right: 20,
                      top: 10,
                    ),
                    color: Colors.transparent,
                    child: Container(
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
                              onTap: () => _scrollToBottom(),
                              onChanged: (value) => _scrollToBottom(),
                              decoration: const InputDecoration(
                                hintText: 'Ketik pesan...',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () async {
                              String message = _controller.text;
                              // Clear the input field
                              _controller.clear();

                              // Add user's message to chat list and update state
                              setState(() {
                                _chat.add({
                                  'message': message,
                                  'isUser': true,
                                  'error': false,
                                });
                                _isLoading = true; // Set _isLoading ke true
                              });

                              _scrollToBottom();

                              // Send message and get response
                              Map<String, dynamic> response =
                                  await chatProvider.quickChat(message);

                              // Add response to chat list and update state
                              setState(() {
                                _isLoading = false; // Set _isLoading ke false
                                if (!response['error']) {
                                  _chat.add({
                                    'message': response['text'],
                                    'isUser': false,
                                    'error': false,
                                  });
                                } else {
                                  _chat.add({
                                    'message': response['text'],
                                    'isUser': false,
                                    'error': true,
                                  });
                                }
                              });

                              // Scroll to bottom
                              _scrollToBottom();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
