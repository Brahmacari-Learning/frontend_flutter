import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/screens/detail_sloka_screen.dart';

class SearchSlokaScreen extends StatefulWidget {
  final List<dynamic> slokas;
  const SearchSlokaScreen({super.key, required this.slokas});

  @override
  State<SearchSlokaScreen> createState() => _SearchSlokaScreenState();
}

class _SearchSlokaScreenState extends State<SearchSlokaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Sloka'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.slokas.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        'BAB ${widget.slokas[index]['numberBab']}: SLOKA ${widget.slokas[index]['number']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        widget.slokas[index]['babTitle'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailSlokaScreen(
                              bab: widget.slokas[index]['numberBab'],
                              sloka: widget.slokas[index]['number'],
                            ),
                          ),
                        );
                      },
                    );
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
