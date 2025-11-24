import 'package:flutter/material.dart';
class NavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<IconData> _navBarItems = const [
    Icons.home_filled, // Home
    Icons.dashboard_customize_outlined, // Dashboard/Progress
    Icons.star_border, // Favorites/Saved
    Icons.menu_book_outlined, // Courses/Content
    Icons.settings_outlined, // Settings
  ];

  final Color _barColor = const Color(0xFF282C35); 
  final Color _selectedIndicatorColor = const Color(0xFF5A5AD7); 
  final Color _unselectedIconColor = const Color(0xFFC0C0C0); 
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
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
                    isSelected ? _selectedIndicatorColor : Colors.transparent,
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

