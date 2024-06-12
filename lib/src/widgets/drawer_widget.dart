import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/chat_provider.dart';
import 'package:vedanta_frontend/src/widgets/no_internet.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('John Doe'),
            accountEmail: Text('Siswa'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('lib/assets/images/user.png'),
            ),
          ),
          const Text('Session Percakapan'),
          Expanded(
            child: FutureBuilder(
              future: chatProvider.getChatSessions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasError) {
                    return const NoInternet();
                  } else {
                    if (snapshot.data?['sessions'] == null) {
                      return const Center(
                        child: Text('Belum ada sesi percakapan'),
                      );
                    } else {
                      List data = snapshot.data?['sessions'];
                      if (data.isEmpty) {
                        return const Center(
                          child: Text('Belum ada sesi percakapan'),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(data[index]['name']),
                              onTap: () {
                                // chatProvider.setChatSession(data[index]);
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      }
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
