import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// --- Brutalist Design Constants ---
const Color kBrutalistBg = Color(0xFFFFFFF9);
const Color kBrutalistYellow = Color(0xFFFDE798);

class AppliedPage extends StatelessWidget {
  const AppliedPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 28, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      "BACK",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.1),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'RECENT ACTIVITY ⚡',
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.black, height: 1.1),
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: _buildRecentPerformanceSection(),
            ),
          ],
        ),
      ),
    );
  }

  // --- RECENT DATA LOGIC ---
  Widget _buildRecentPerformanceSection() {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      // Fetches the most recent enrollments for the current user
      stream: FirebaseFirestore.instance
          .collection('applications')
          .where('userId', isEqualTo: user?.uid)
          .orderBy('appliedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyActivityCard();
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            final String status = (data['status'] ?? 'pending').toString().toUpperCase();
            final bool isWorkshop = data['type'] == 'workshop';
            
            // UI mapping based on application type and status
            return _AppliedItemTile(
              title: (data['itemTitle'] ?? 'APPLICATION').toString().toUpperCase(),
              subtitle: "Status: $status • ${data['type'] ?? 'General'}",
              icon: isWorkshop ? Icons.bolt : Icons.work_outline,
              color: status == 'APPROVED' ? Colors.green : Colors.orange,
              statusLabel: status,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyActivityCard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history_toggle_off, size: 80, color: Colors.black26),
          const SizedBox(height: 16),
          const Text(
            "NO RECENT ACTIVITY FOUND.",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

// --- Brutalist Item Tile ---
class _AppliedItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String statusLabel;

  const _AppliedItemTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 400),
      child: SlideAnimation(
        verticalOffset: 30,
        child: FadeInAnimation(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black, width: 2.5),
              boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: color),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: kBrutalistYellow, shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2)),
                  child: const Icon(Icons.arrow_forward, color: Colors.black, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}