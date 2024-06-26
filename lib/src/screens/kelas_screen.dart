import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/class_provider.dart';
import 'package:vedanta_frontend/src/screens/kelas_detail_screen.dart';
import 'package:vedanta_frontend/src/services/auth_wraper.dart';
import 'package:vedanta_frontend/src/widgets/no_internet.dart';

class KelasScreen extends StatefulWidget {
  const KelasScreen({super.key});

  @override
  State<KelasScreen> createState() => _KelasScreenState();
}

class _KelasScreenState extends State<KelasScreen> {
  final TextEditingController _codeController = TextEditingController();
  late Future<void> response;
  Map<String, dynamic> classes = {};

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    response = getClasses();
  }

  Future<void> getClasses() async {
    try {
      final classProvider = Provider.of<ClassProvider>(context, listen: false);
      final response = await classProvider.getClasses();
      setState(() {
        classes = response;
      });
    } catch (e) {
      // Handle error here, e.g., log the error or show a message to the user.
      setState(() {
        classes = {'error': e.toString()};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider class
    final classProvider = Provider.of<ClassProvider>(context);
    return AuthWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Kelas',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.purple, // Warna ungu untuk back button
          ),
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
                return const NoInternet();
              }
              if (classes.isEmpty) {
                return const Center(child: Text('No classes available'));
              }
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: classes['classes'].length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KelasDetailScreen(
                                  id: classes['classes'][index]['id'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 330,
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 20),
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xFFDA94FA),
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    classes['classes'][index]['className'],
                                    style: const TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    classes['classes'][index]['teacherName'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // Code Button
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          // pop up dialog to input code
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Masukkan Kode Kelas'),
                                content: TextField(
                                  controller: _codeController,
                                  decoration: const InputDecoration(
                                    hintText: 'Kode Kelas',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Batal'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final response = await classProvider
                                          .joinClass(_codeController.text);
                                      // Handle response for joinClass
                                      if (response['error'] == true) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(response['message']),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } else {
                                        // refresh page
                                        setState(() {
                                          this.response = getClasses();
                                        });
                                        Navigator.pop(context);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                    ),
                                    child: const Text(
                                      'Masuk',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Masuk Kelas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
