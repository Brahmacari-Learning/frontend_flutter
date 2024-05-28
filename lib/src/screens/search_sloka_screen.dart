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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.slokas.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(
                        'BAB ${widget.slokas[index]['numberBab']}: SLOKA ${widget.slokas[index]['number']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            widget.slokas[index]['content'] ?? '',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.slokas[index]['translationIndo'] ?? '',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
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
