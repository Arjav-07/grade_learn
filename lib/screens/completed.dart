import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:ui'; // Needed for the blur effect in the dialog

// --- 1. Data Model for Type Safety ---
class CompletedItem {
  final IconData icon;
  final Color color;
  final String title;
  final String institution;

  const CompletedItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.institution,
  });
}

// --- Main Page Widget ---
class CompletedPage extends StatelessWidget {
  const CompletedPage({super.key});

  // --- 2. Using the Type-Safe Model ---
  final List<CompletedItem> _completedItems = const [
    CompletedItem(
      icon: Icons.school,
      color: Color(0xFF28C6E6),
      title: 'Flutter for Beginners',
      institution: 'Google Developers',
    ),
    CompletedItem(
      icon: Icons.design_services,
      color: Color(0xFFE5883C),
      title: 'UI/UX Fundamentals',
      institution: 'The Design School',
    ),
    CompletedItem(
      icon: Icons.cloud_done,
      color: Colors.blueGrey,
      title: 'Intro to Cloud Computing',
      institution: 'AWS Academy',
    ),
    CompletedItem(
      icon: Icons.analytics,
      color: Colors.redAccent,
      title: 'Advanced Data Science',
      institution: 'Stanford University',
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
    const Duration animationDuration = Duration(milliseconds: 400);

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
            child: Text(
              'Completed',
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
                  itemCount: _completedItems.length,
                  itemBuilder: (context, index) {
                    final item = _completedItems[index];
                    const completionDate = "Oct 18, 2025";

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: animationDuration,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _CompletedItemTile(
                            item: item,
                            completionDate: completionDate,
                          ),
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

// --- 3. UPDATED: Item Tile styled to match the 'Applied' page ---
class _CompletedItemTile extends StatelessWidget {
  const _CompletedItemTile({
    required this.item,
    required this.completionDate,
  });

  final CompletedItem item;
  final String completionDate;

  @override
  Widget build(BuildContext context) {
    // Using a Container inside an InkWell to replicate the exact style
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      // Use Material and InkWell for the ripple effect on a decorated container
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              barrierColor: Colors.black.withOpacity(0.5),
              builder: (_) => BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: _CertificateDialog(
                  courseTitle: item.title,
                  institution: item.institution,
                  date: completionDate,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // Applying the same light black color as the 'Applied' cards
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
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
                          color: Colors.black, // Text color matches
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.institution,
                        style: TextStyle(
                          fontSize: 14,
                          // Subtitle text color matches
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    // Trailing icon background matches
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  // Keeping the certificate icon as it makes sense for this page
                  child: const Icon(Icons.workspace_premium_outlined, color: Colors.black, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- The Certificate Dialog Widget (Unchanged) ---
class _CertificateDialog extends StatelessWidget {
  const _CertificateDialog({
    required this.courseTitle,
    required this.institution,
    required this.date,
  });

  final String courseTitle;
  final String institution;
  final String date;

  @override
  Widget build(BuildContext context) {
    const Color kPrimaryColor = Color(0xFF7A64D8);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F2FF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: kPrimaryColor.withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.workspace_premium, color: Color(0xFFFFC107), size: 50),
            const SizedBox(height: 16),
            const Text(
              'Certificate of Completion',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kPrimaryColor),
            ),
            const SizedBox(height: 8),
            const Text('This certificate is proudly presented to', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text(
              'Your Name', // This should be fetched from user data
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('For successfully completing the course', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 8),
            Text(
              courseTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE5883C)),
            ),
            Text('from $institution', style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Text('Date', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Column(
                  children: const [
                    Text('J. Smith', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                    Text('Instructor', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                  style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}