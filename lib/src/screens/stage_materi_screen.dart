import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/chat_provider.dart';
import 'package:vedanta_frontend/src/providers/stage_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shimmer/shimmer.dart';

class StageMateriScreen extends StatefulWidget {
  final int stageId;
  final String videoId;
  const StageMateriScreen({
    super.key,
    required this.stageId,
    required this.videoId,
  });

  @override
  State<StageMateriScreen> createState() => _StageMateriScreenState();
}

class _StageMateriScreenState extends State<StageMateriScreen> {
  Future<void> _futureMateri = Future.value();
  Map<String, dynamic> _materi = {};
  bool _isPlayerReady = false;
  bool _faktaMenarikLoading = false;

  String faktaMenarik = '';

  late YoutubePlayerController _controller;

  Future<void> _getMateri() async {
    final provider = Provider.of<StageProvider>(context, listen: false);
    final materi = await provider.getMateri(widget.stageId);
    setState(() {
      _materi = materi;
    });
  }

  @override
  void initState() {
    super.initState();
    _futureMateri = _getMateri();

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false, // Disable autoPlay
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        // Additional state changes if needed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.purple[400],
        onReady: () {
          setState(() {
            _isPlayerReady = true;
          });
        },
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Materi"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: const Color(0xFF9C7AFF),
          ),
          backgroundColor: const Color(0xFF9C7AFF),
          body: FutureBuilder(
            future: _futureMateri,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 28, right: 28),
                      child: player,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _materi['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _materi['description'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _faktaMenarikLoading = true;
                                  });

                                  final chatProvider =
                                      Provider.of<ChatProvider>(
                                    context,
                                    listen: false,
                                  );

                                  final response = await chatProvider.quickChat(
                                      'Berikan fakta menarik dari materi ${_materi['title']}. Dimana ${_materi['description']}');
                                  setState(() {
                                    faktaMenarik = response['text'];
                                    _faktaMenarikLoading = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFB95A92),
                                ),
                                child: const Text(
                                  'Fakta Menarik',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (_faktaMenarikLoading) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Avatar
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(1000),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 90.0,
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
                          ],
                          if (faktaMenarik.isNotEmpty &&
                              !_faktaMenarikLoading) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image.asset('lib/assets/images/ganabot.png'),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16.0),
                                    child: MarkdownBody(
                                      data: faktaMenarik,
                                      styleSheet: MarkdownStyleSheet(
                                        p: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
