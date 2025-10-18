import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// --- 1. Data Model for Type Safety ---
// Replaces Map<String, dynamic> for safer and cleaner code.
class AppliedItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const AppliedItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });
}

// --- Main Page Widget ---
class AppliedPage extends StatelessWidget {
  AppliedPage({super.key});

  // --- 2. Using the Type-Safe Model ---
  final List<AppliedItem> _appliedCourses = [
    const AppliedItem(
      icon: Icons.code,
      color: Color(0xFFE5883C),
      title: 'Flutter for Beginners',
      subtitle: 'by Jane Smith',
    ),
    const AppliedItem(
      icon: Icons.data_usage,
      color: Colors.redAccent,
      title: 'Advanced Data Science',
      subtitle: 'by Stanford University',
    ),
  ];

  final List<AppliedItem> _appliedInternships = [
    const AppliedItem(
      icon: Icons.business_center,
      color: Colors.indigo,
      title: 'Flutter Developer Intern',
      subtitle: 'at Google',
    ),
    const AppliedItem(
      icon: Icons.computer,
      color: Colors.orange,
      title: 'Software Engineer Intern',
      subtitle: 'at Amazon',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // --- UI Constants for consistent theming ---
    const Color primaryBackgroundColor = Color(0xFFFFD9C0);
    const Color cardBackgroundColor = Colors.white;
    const BorderRadius topBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(32),
      topRight: Radius.circular(32),
    );
    const Duration animationDuration = Duration(milliseconds: 350);

    // Combine both lists to build a single scrollable view
    final List<dynamic> allAppliedItems = [
      'Courses', // Use strings as section headers
      ..._appliedCourses,
      'Internships',
      ..._appliedInternships,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF9093E1).withOpacity(0.9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Text(
              'Applied',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.2,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: topBorderRadius,
              ),
              child: AnimationLimiter(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: allAppliedItems.length,
                  itemBuilder: (context, index) {
                    final item = allAppliedItems[index];

                    // Render the section header
                    if (item is String) {
                      return _SectionHeader(title: item);
                    }
                    
                    // Render the list item tile
                    // Note: The item is cast to AppliedItem here
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: animationDuration,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _AppliedItemTile(item: item as AppliedItem),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Section Header Widget ---
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    // Adjusted padding for the new layout
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF555555),
        ),
      ),
    );
  }
}

// --- 3. Re-themed Applied Item Tile Widget ---
class _AppliedItemTile extends StatelessWidget {
  const _AppliedItemTile({required this.item});
  final AppliedItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05), // Dark card theme
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // Use the item's specific color with some opacity
              color: item.color.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item.icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.black12,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.black,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}