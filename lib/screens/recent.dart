import 'package:flutter/material.dart';

// --- Brutalist Design Constants ---
const Color kBrutalistBg = Color(0xFFFFFFF9);
const Color kBrutalistYellow = Color(0xFFFDE798);
const Color kBrutalistBlue = Color(0xFFB5D8FF);
const Color kBrutalistPurple = Color(0xFF7A64D8);
const Color kDarkTextColor = Color(0xFF282C35);

// --- 1. Data Model ---
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

// --- Main Page Widget ---
class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  bool _showCourses = true;

  final List<WatchlistItem> _watchlistedCourses = [
    const WatchlistItem(
      icon: Icons.design_services,
      color: Color(0xFF6F6AE8),
      title: 'UI/UX FUNDAMENTALS',
      subtitle: 'by John Doe',
      status: 'VIEWED',
      statusColor: Colors.green,
    ),
    const WatchlistItem(
      icon: Icons.code,
      color: Color(0xFFE5883C),
      title: 'FLUTTER FOR BEGINNERS',
      subtitle: 'by Jane Smith',
      status: 'APPLIED',
      statusColor: Colors.blue,
    ),
    const WatchlistItem(
      icon: Icons.cloud,
      color: Colors.cyan,
      title: 'INTRO TO CLOUD COMPUTING',
      subtitle: 'by AWS Academy',
      status: 'VIEWED',
      statusColor: Colors.green,
    ),
  ];

  final List<WatchlistItem> _watchlistedInternships = [
    const WatchlistItem(
      icon: Icons.business_center,
      color: Colors.indigo,
      title: 'FLUTTER DEVELOPER INTERN',
      subtitle: 'at Google',
      status: 'APPLIED',
      statusColor: Colors.blue,
    ),
    const WatchlistItem(
      icon: Icons.business,
      color: Colors.teal,
      title: 'PRODUCT MANAGER INTERN',
      subtitle: 'at Microsoft',
      status: 'VIEWED',
      statusColor: Colors.green,
    ),
    const WatchlistItem(
      icon: Icons.computer,
      color: Colors.orange,
      title: 'SOFTWARE ENGINEER INTERN',
      subtitle: 'at Amazon',
      status: 'APPLIED',
      statusColor: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final activeList = _showCourses ? _watchlistedCourses : _watchlistedInternships;

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
                'WATCHLISTED 🔖',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1.1,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- TOGGLE BUTTONS ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _CategoryToggleButton(
                      text: '${_watchlistedCourses.length} COURSES',
                      isActive: _showCourses,
                      onTap: () => setState(() => _showCourses = true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CategoryToggleButton(
                      text: '${_watchlistedInternships.length} INTERNS',
                      isActive: !_showCourses,
                      onTap: () => setState(() => _showCourses = false),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: _buildWatchlist(activeList),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWatchlist(List<WatchlistItem> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text('NOTHING WATCHLISTED YET', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey)),
      );
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) => _WatchlistItemCard(item: items[index]),
    );
  }
}

// --- Neo-Brutalist Toggle Button ---
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2.5),
          boxShadow: isActive ? null : const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

// --- Neo-Brutalist Item Card ---
class _WatchlistItemCard extends StatelessWidget {
  final WatchlistItem item;
  const _WatchlistItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: Icon(item.icon, color: item.color, size: 24),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kBrutalistBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: const Icon(Icons.open_in_new, color: Colors.black, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            item.subtitle.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.black,
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
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    color: item.statusColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1),
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