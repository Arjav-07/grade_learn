import 'package:flutter/material.dart';

// --- 1. Data Model for Type Safety ---
// Renamed to reflect its use in the watchlist.
class WatchlistItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;

  const WatchlistItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
  });
}

// --- Main Page Widget (Renamed) ---
class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  // State to toggle between courses and internships
  bool _showCourses = true;

  // --- 2. Data lists renamed for clarity ---
  final List<WatchlistItem> _watchlistedCourses = [
    const WatchlistItem(
      icon: Icons.design_services,
      color: Color(0xFF6F6AE8),
      title: 'UI/UX Fundamentals',
      subtitle: 'by John Doe',
      status: 'Viewed',
      statusColor: Colors.green,
    ),
    const WatchlistItem(
      icon: Icons.code,
      color: Color(0xFFE5883C),
      title: 'Flutter for Beginners',
      subtitle: 'by Jane Smith',
      status: 'Applied',
      statusColor: Colors.blue,
    ),
    const WatchlistItem(
      icon: Icons.cloud,
      color: Colors.cyan,
      title: 'Intro to Cloud Computing',
      subtitle: 'by AWS Academy',
      status: 'Viewed',
      statusColor: Colors.green,
    ),
  ];

  final List<WatchlistItem> _watchlistedInternships = [
    const WatchlistItem(
      icon: Icons.business_center,
      color: Colors.indigo,
      title: 'Flutter Developer Intern',
      subtitle: 'at Google',
      status: 'Applied',
      statusColor: Colors.blue,
    ),
    const WatchlistItem(
      icon: Icons.business,
      color: Colors.teal,
      title: 'Product Manager Intern',
      subtitle: 'at Microsoft',
      status: 'Viewed',
      statusColor: Colors.green,
    ),
    const WatchlistItem(
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
    // --- UI Constants ---
    const Color primaryBackgroundColor = Color(0xFFFFD9C0);
    const Color cardBackgroundColor = Colors.white;
    const BorderRadius topBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(32),
      topRight: Radius.circular(32),
    );

    // Determine which list is currently active
    final activeList =
        _showCourses ? _watchlistedCourses : _watchlistedInternships;

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
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
            // --- UI TEXT UPDATED ---
            child: Text(
              'Watchlisted',
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
                  child: _CategoryToggleButton(
                    text: '${_watchlistedCourses.length} Courses',
                    isActive: _showCourses,
                    onTap: () => setState(() => _showCourses = true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CategoryToggleButton(
                    text: '${_watchlistedInternships.length} Internships',
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
              // --- Method Renamed ---
              child: _buildWatchlist(activeList),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the list view for the watchlisted items.
  Widget _buildWatchlist(List<WatchlistItem> items) {
    if (items.isEmpty) {
      // --- UI TEXT UPDATED ---
      return const Center(
        child:
            Text('Nothing watchlisted yet', style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = items[index];
        // --- Card Widget Renamed ---
        return _WatchlistItemCard(item: item);
      },
    );
  }
}

// --- Extracted Toggle Button Widget ---
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

// --- Extracted Watchlist Item Card Widget (Renamed) ---
class _WatchlistItemCard extends StatelessWidget {
  final WatchlistItem item;

  const _WatchlistItemCard({required this.item});

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
                child: const Icon(Icons.open_in_new,
                    color: Colors.white, size: 18),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: item.statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    color: item.statusColor,
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