import 'package:flutter/material.dart';
import 'package:grade_learn/pages/chatwelcome_page.dart';
import 'package:grade_learn/pages/home_page.dart'; 
import 'package:grade_learn/pages/internship_page.dart';
import 'package:grade_learn/pages/profile.dart';
import 'package:grade_learn/pages/course_page.dart.dart';
import 'package:grade_learn/widgets/navbar.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({Key? key, required this.title}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: Center(
        child: Text(title, style: const TextStyle(fontSize: 30)),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(), // Index 0
    const SkillPage(), // Index 1 
    const InternshipPage(), // Index 2
    const ChatWelcome(), // Index 3
    const ProfileApp(), // Index 4
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _widgetOptions.elementAt(_selectedIndex),
          Align(
            alignment: Alignment.bottomCenter,
            child: NavBar(
              selectedIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}