import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:time_manager_mobile/index/authentification.dart';
import 'package:time_manager_mobile/index/time_manager.dart';
import 'package:time_manager_mobile/index/home.dart';
import 'package:time_manager_mobile/index/profile.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginSignupPage(), //MyBottomNavigationBar(),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    const PageProfile(),
    const PageHome(),
    PageTimeManager(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 145, 188, 194),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: GNav(
                backgroundColor: const Color.fromARGB(255, 145, 188, 194),
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: const Color.fromARGB(255, 92, 153, 163),
                gap: 8,
                onTabChange: onTabTapped,
                selectedIndex: _currentIndex,
                padding: const EdgeInsets.all(16),
                tabs: const [
                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
                    iconSize: 25,
                  ),
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                    iconSize: 25,
                  ),
                  GButton(
                    icon: Icons.timer,
                    text: 'Time',
                    iconSize: 25,
                  ),
                ]),
          ),
        ));
  }
}
