//Packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Screens
import '../../../controller/auth_provider.dart';
import '../../../helper/router/router_path.dart';
import '../../../helper/router/routing_helper.dart';
import '../../../services/locater.dart';
import '../chats/chat_screen.dart';
import '../users/users_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentScreen = 0;
  final List<Widget> _pages = const [ChatScreen(), UsersScreen()];

  void currentIndex(int value) {
    setState(() {
      _currentScreen = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_currentScreen],
        bottomNavigationBar: BottomNavigationBar(
            onTap: currentIndex,
            currentIndex: _currentScreen,
            items: const [
              BottomNavigationBarItem(
                label: "Chats",
                icon: Icon(
                  Icons.chat_bubble_sharp,
                ),
              ),
              BottomNavigationBarItem(
                label: "Users",
                icon: Icon(
                  Icons.supervised_user_circle_sharp,
                ),
              )
            ]),
      ),
    );
  }
}
