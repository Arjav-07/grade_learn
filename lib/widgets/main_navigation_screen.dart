// main_navigation_screen.dart (or include this in a suitable file)

import 'package:flutter/material.dart';
import 'package:grade_learn/pages/home_page.dart'; // Import your pages
import 'package:grade_learn/pages/skill_page.dart';
import 'package:grade_learn/widgets/navbar.dart';

// You will likely have to replace the placeholder imports below
// with the actual imports for your other pages.
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
  // 0: Home, 1: Dashboard, 2: Favorites, 3: Courses, 4: Settings
  int _selectedIndex = 0;

  // The list of pages corresponding to the NavBar items
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(), // Index 0
    const SkillPage(), // Index 3 (Assuming this is your 'Courses/Content' page)
    const PlaceholderPage(title: 'Dashboard/Progress'), // Index 1
    const PlaceholderPage(title: 'Favorites/Saved'), // Index 2
    const PlaceholderPage(title: 'Settings'), // Index 4
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body displays the currently selected page
      body: Stack(
        children: <Widget>[
          // The current page widget
          _widgetOptions.elementAt(_selectedIndex),

          // The NavBar is always aligned to the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: NavBar(
              selectedIndex: _selectedIndex,
              onTap: _onItemTapped, // This updates the state and rebuilds
            ),
          ),
        ],
      ),
    );
  }
}