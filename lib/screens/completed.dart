import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// --- Brutalist Design Constants ---
const Color kBrutalistBg = Color(0xFFFFFFF9);
const Color kBrutalistYellow = Color(0xFFFDE798);

class CompletedPage extends StatelessWidget {
  const CompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
                onTap: () => Navigator.pop(context),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 28, color: Colors.black),
                    SizedBox(width: 8),
                    Text("BACK", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'CERTIFICATES 🏆',
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.black, height: 1.1),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // Filter: Only show approved items for the logged-in user
                stream: FirebaseFirestore.instance
                    .collection('applications')
                    .where('userId', isEqualTo: user?.uid)
                    .where('status', isEqualTo: 'approved')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.black));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState();
                  }

                  final docs = snapshot.data!.docs;

                  return AnimationLimiter(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 400),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _CertificateTile(data: data),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.card_membership, size: 80, color: Colors.black26),
          SizedBox(height: 16),
          Text("NO CERTIFICATES EARNED YET.", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black54)),
        ],
      ),
    );
  }
}

class _CertificateTile extends StatelessWidget {
  const _CertificateTile({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final bool isWorkshop = data['type'] == 'workshop';
    final String title = (data['itemTitle'] ?? 'PROGRAM').toString().toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => _showCertificateDialog(context, title),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Brutalist Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isWorkshop ? Colors.teal.withOpacity(0.2) : Colors.purple.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child: Icon(
                    isWorkshop ? Icons.bolt : Icons.school, 
                    color: isWorkshop ? Colors.teal : Colors.purple, 
                    size: 28
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(
                        isWorkshop ? "WORKSHOP COMPLETED" : "INTERNSHIP COMPLETED",
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                // Badge of authenticity
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kBrutalistYellow,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Icon(Icons.verified, color: Colors.black, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCertificateDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kBrutalistBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black, width: 3),
        ),
        title: const Text("VIEW CERTIFICATE", style: TextStyle(fontWeight: FontWeight.w900)),
        content: Text("DO YOU WANT TO DOWNLOAD THE CERTIFICATE FOR $title?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CLOSE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () { /* Add PDF Generation or Download Link here */ },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text("DOWNLOAD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}