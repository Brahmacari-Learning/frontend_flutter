import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/screens/menu/chat_bot_widget.dart';
import 'package:vedanta_frontend/src/screens/menu/doa_page_widget.dart';
import 'package:vedanta_frontend/src/screens/menu/event_widget.dart';
import 'package:vedanta_frontend/src/screens/menu/discussion_widget.dart';
import 'package:vedanta_frontend/src/screens/menu/gita_widget.dart';
import 'package:vedanta_frontend/src/screens/menu/level_widget.dart';
import 'package:vedanta_frontend/src/screens/menu/profile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<Widget> _widgetOptions = <Widget>[
    LevelWidget(),
    ChatBotWidget(),
    DiscussionWidget(),
    GitaWidget(),
    DoaPageWidget(),
    EventWidget(),
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
      key: _scaffoldKey,
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
