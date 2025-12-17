import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class NavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<IconData> _navBarItems = const [
    FontAwesomeIcons.solidHouse, // Home
    FontAwesomeIcons.magnifyingGlass, // Dashboard/Progress
    FontAwesomeIcons.briefcase, // Favorites/Saved
    FontAwesomeIcons.bookBookmark, // Courses/Content
    FontAwesomeIcons.gear, // Settings
  ];

  final Color _barColor =  Colors.black;
  final Color _unselectedIconColor = const Color(0xFFC0C0C0); 
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      margin: const EdgeInsets.only(
          bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: _barColor,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_navBarItems.length, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: isSelected
                  ? const EdgeInsets.all(
                      12) 
                  : EdgeInsets.zero,
              decoration: BoxDecoration(
                color:
                    isSelected ? Colors.transparent : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _navBarItems[index],
                size: 28,
                color: isSelected ? Colors.white : _unselectedIconColor,
              ),
            ),
          );
        }),
      ),
    );
  }
}

