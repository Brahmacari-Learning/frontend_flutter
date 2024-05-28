import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/class_provider.dart';

class KelasDetailScreen extends StatefulWidget {
  final int id;
  const KelasDetailScreen({super.key, required this.id});

  @override
  State<KelasDetailScreen> createState() => _KelasDetailScreenState();
}

class _KelasDetailScreenState extends State<KelasDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // provider class
    final classProvider = Provider.of<ClassProvider>(context);
    final response = classProvider.classMember(widget.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelas Detail'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: response,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 1,
                  child: const CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Text('An error occurred');
            }
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!['members'].length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 330,
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 20),
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.purple,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.1),
                              offset: const Offset(0, -2),
                              blurRadius: 7,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              snapshot.data!['members'][index]['name'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
