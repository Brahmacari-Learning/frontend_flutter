import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/widgets/level_widget.dart';
import 'package:vedanta_frontend/src/widgets/profile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    LevelWidget(),
    Text('Search Page'),
    Text('Profile Page'),
    Text('Settings Page'),
    Text('Notifications Page'),
    Text('Messages Page'),
    ProfileWidget(),
  ];

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/images/icons/lamp.png',
                width: 24, height: 24),
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/images/icons/robot.png',
                width: 24, height: 24),
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/images/icons/qna.png',
                width: 24, height: 24),
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/images/icons/book.png',
                width: 24, height: 24),
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/images/icons/hand.png',
                width: 24, height: 24),
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/images/icons/gift.png',
                width: 24, height: 24),
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/images/icons/user.png',
                width: 24, height: 24),
            label: '', // No label
          ),
        ],
        selectedItemColor: Colors.purple[400],
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      backgroundColor: Colors.purple[400],
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              fit: BoxFit.fill,
              'lib/assets/images/user.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Siswa",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.logout),
          //   onPressed: () async {
          //     await authProvider.logout();
          //     Navigator.of(context).pushReplacementNamed('/login');
          //   },
          // ),

          // Notification button with image
          Row(
            children: [
              Image.asset(
                fit: BoxFit.fill,
                'lib/assets/images/star.png',
                width: 24,
                height: 24,
              ),
              const Text(
                '25',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Image.asset(
                fit: BoxFit.fill,
                'lib/assets/images/medal.png',
                width: 24,
                height: 24,
              ),
              const Text(
                '4',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: Image.asset(
              fit: BoxFit.fill,
              'lib/assets/images/notification.png',
              width: 18,
              height: 18,
            ),
          )

          // IconButton(
          //   icon: Icon(themeProvider.themeData.brightness == Brightness.light
          //       ? Icons.dark_mode
          //       : Icons.light_mode),
          //   onPressed: () {
          //     themeProvider.toggleTheme();
          //   },
          // ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
