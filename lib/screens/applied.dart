import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// --- Brutalist Design Constants ---
const Color kBrutalistBg = Color(0xFFFFFFF9);
const Color kBrutalistYellow = Color(0xFFFDE798);
const Color kBrutalistBlue = Color(0xFFB5D8FF);
const Color kBrutalistPurple = Color(0xFF7A64D8);
const Color kDarkTextColor = Color(0xFF282C35);

// --- 1. Data Model ---
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

  final List<AppliedItem> _appliedCourses = [
    const AppliedItem(
      icon: Icons.code,
      color: Color(0xFFE5883C),
      title: 'FLUTTER FOR BEGINNERS',
      subtitle: 'by Jane Smith',
    ),
    const AppliedItem(
      icon: Icons.data_usage,
      color: Colors.redAccent,
      title: 'ADVANCED DATA SCIENCE',
      subtitle: 'by Stanford University',
    ),
  ];

  final List<AppliedItem> _appliedInternships = [
    const AppliedItem(
      icon: Icons.business_center,
      color: Colors.indigo,
      title: 'FLUTTER DEVELOPER INTERN',
      subtitle: 'at Google',
    ),
    const AppliedItem(
      icon: Icons.computer,
      color: Colors.orange,
      title: 'SOFTWARE ENGINEER INTERN',
      subtitle: 'at Amazon',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const Duration animationDuration = Duration(milliseconds: 350);

    final List<dynamic> allAppliedItems = [
      'COURSES',
      ..._appliedCourses,
      'INTERNSHIPS',
      ..._appliedInternships,
    ];

    return Scaffold(
      backgroundColor: kBrutalistBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            
            // --- BACK BUTTON ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back, size: 28, color: Colors.black),
                    const SizedBox(width: 8),
                    const Text(
                      "BACK",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'APPLIED 📝',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1.1,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: allAppliedItems.length,
                  itemBuilder: (context, index) {
                    final item = allAppliedItems[index];

                    if (item is String) {
                      return _SectionHeader(title: item);
                    }
                    
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
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Colors.black,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// --- Brutalist Applied Item Tile ---
class _AppliedItemTile extends StatelessWidget {
  const _AppliedItemTile({required this.item});
  final AppliedItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: Icon(item.icon, color: item.color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kBrutalistYellow,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}