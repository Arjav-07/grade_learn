import 'package:flutter/material.dart';

// --- 1. Data Model for Type Safety ---
// Using a class instead of a Map prevents runtime errors from typos
// and gives you better autocompletion in your IDE.
class RecentItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;

  const RecentItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
  });
}

// --- Main Page Widget ---
class RecentsPage extends StatefulWidget {
  const RecentsPage({super.key});

  @override
  State<RecentsPage> createState() => _RecentsPageState();
}

class _RecentsPageState extends State<RecentsPage> {
  // State to toggle between courses and internships
  bool _showCourses = true;

  // --- 2. Using the Type-Safe Model ---
  // The data is now a list of RecentItem objects.
  final List<RecentItem> _recentCourses = [
    const RecentItem(
      icon: Icons.design_services,
      color: Color(0xFF6F6AE8),
      title: 'UI/UX Fundamentals',
      subtitle: 'by John Doe',
      status: 'Viewed',
      statusColor: Colors.green,
    ),
    const RecentItem(
      icon: Icons.code,
      color: Color(0xFFE5883C),
      title: 'Flutter for Beginners',
      subtitle: 'by Jane Smith',
      status: 'Applied',
      statusColor: Colors.blue,
    ),
    const RecentItem(
      icon: Icons.cloud,
      color: Colors.cyan,
      title: 'Intro to Cloud Computing',
      subtitle: 'by AWS Academy',
      status: 'Viewed',
      statusColor: Colors.green,
    ),
  ];

  final List<RecentItem> _recentInternships = [
    const RecentItem(
      icon: Icons.business_center,
      color: Colors.indigo,
      title: 'Flutter Developer Intern',
      subtitle: 'at Google',
      status: 'Applied',
      statusColor: Colors.blue,
    ),
    const RecentItem(
      icon: Icons.business,
      color: Colors.teal,
      title: 'Product Manager Intern',
      subtitle: 'at Microsoft',
      status: 'Viewed',
      statusColor: Colors.green,
    ),
    const RecentItem(
      icon: Icons.computer,
      color: Colors.orange,
      title: 'Software Engineer Intern',
      subtitle: 'at Amazon',
      status: 'Applied',
      statusColor: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // --- UI Constants for better maintainability ---
    const Color primaryBackgroundColor = Color(0xFFFFD9C0);
    const Color cardBackgroundColor = Colors.white;
    const BorderRadius topBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(32),
      topRight: Radius.circular(32),
    );

    // Determine which list is currently active
    final activeList = _showCourses ? _recentCourses : _recentInternships;

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        // Simplified AppBar leading icon
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
              'Recents',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  // --- 3. Using the Modular Toggle Button Widget ---
                  child: _CategoryToggleButton(
                    text: '${_recentCourses.length} Courses',
                    isActive: _showCourses,
                    onTap: () => setState(() => _showCourses = true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CategoryToggleButton(
                    text: '${_recentInternships.length} Internships',
                    isActive: !_showCourses,
                    onTap: () => setState(() => _showCourses = false),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: topBorderRadius,
              ),
              // The container's decoration already clips its content,
              // so the ClipRRect widget was redundant.
              child: _buildRecentsList(activeList),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the list view for the recent items.
  Widget _buildRecentsList(List<RecentItem> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text('No recent activity', style: TextStyle(color: Colors.grey)),
      );
    }
    // Using ListView.separated is slightly cleaner for adding dividers.
    return ListView.separated(
      physics: const ClampingScrollPhysics(), // Disables the glow effect
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = items[index];
        // --- 4. Using the Modular Card Widget ---
        return _RecentItemCard(item: item);
      },
    );
  }
}

// --- 5. Extracted Toggle Button Widget ---
// This makes the main build method cleaner and the button reusable.
class _CategoryToggleButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _CategoryToggleButton({
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2D2D2D) : const Color(0xFFFFE5D6),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

// --- 6. Extracted Recent Item Card Widget ---
// Encapsulates the entire card logic into one clean, reusable widget.
class _RecentItemCard extends StatelessWidget {
  final RecentItem item;

  const _RecentItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: Colors.white, size: 24),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.open_in_new, color: Colors.white, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            item.subtitle.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: item.statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    color: item.statusColor, // Removed opacity for better contrast
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}