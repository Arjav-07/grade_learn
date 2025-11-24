import 'package:flutter/material.dart';
import 'package:grade_learn/pages/internship_page.dart';

// Renamed the parameter type to LessonCardData
class InternshipDetailsPage extends StatelessWidget {
  final LessonCardData lessonData;
  const InternshipDetailsPage({super.key, required this.lessonData});

  // --- Constants used in the current design ---
  static const Color themeColor = Color(0xFFD1E5F8);
  static const Color primaryIconColor = Color(0xFF1E5B89);

  // Helper to format the price for the stat card
  String _formatPrice(String price) {
    if (price.toLowerCase() == 'free') {
      return 'FREE';
    }
    // Takes the first part of a price string like '$ 49.99 (one time)' -> '$ 49.99'
    return price.split(' ').sublist(0, 2).join(' ');
  }

  // Helper to format duration for the stat card
  String _formatDuration(String duration) {
    // Takes the first part of a duration string like '10 Hours' -> '10 Hrs'
    if (duration.contains(' ')) {
      return '${duration.split(' ').first} Hrs';
    }
    return duration; 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeColor,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: _buildBottomBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildStatsSection(),
                const SizedBox(height: 24),
                _buildDescription(),
                const SizedBox(height: 24),
                _buildLessonInfoSections(), // Renamed method
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          _buildAppBar(context),
          const SizedBox(height: 20),
          _buildLessonIcon(), // Updated icon
          const SizedBox(height: 16),
          _buildLessonCategoryChip(), // Updated chip
          const SizedBox(height: 8),
          _buildLessonTitle(), // Updated title
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // 2. Dynamic Stats Section (now displaying lesson info)
  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatCard(
            icon: Icons.schedule,
            value: _formatDuration(lessonData.totalDuration), // Duration
            label: 'Total Time',
            color: const Color(0xFFD1E5F8),
            iconColor: primaryIconColor,
          ),
          const SizedBox(width: 16),
          StatCard(
            icon: Icons.attach_money,
            value: _formatPrice(lessonData.price), // Price
            label: 'Price',
            color: const Color(0xFFE8F5E9),
            iconColor: const Color(0xFF2E7D32),
          ),
          const SizedBox(width: 16),
          const StatCard(
            icon: Icons.star_border, // Changed icon
            value: '4.8',
            label: 'Rating',
            color: Color(0xFFFFF3E0),
            iconColor: Color(0xFFE65100),
          ),
        ],
      ),
    );
  }

  // 3. Dynamic Info Sections (now displaying course content)
  Widget _buildLessonInfoSections() {
    // Static placeholder content, but dynamically titled
    const List<String> contentGoals = [
      'Master fundamental concepts of the technology.',
      'Build 5 real-world projects to solidify your knowledge.',
      'Prepare for certification exams in this domain.',
      'Learn best practices from industry experts.',
    ];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoSection(
            title: 'About the Course',
            content: [
              'This **${lessonData.level}** level course is taught by **${lessonData.instructor}** and covers the entire topic of ${lessonData.lessonTitle}. It is designed for hands-on learning.',
            ],
          ),
          const SizedBox(height: 20),
          const _InfoSection(
            title: 'What you will learn',
            content: contentGoals,
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.3),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Text(
            'Course Details', // Updated text
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.3),
            child: IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.black87),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Icon(
        // Dynamic icon from the lesson data
        lessonData.tagIcon ?? Icons.code,
        color: primaryIconColor,
        size: 40,
      ),
    );
  }

  Widget _buildLessonCategoryChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: primaryIconColor,
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
      child: Text(
        // Dynamic tag text
        lessonData.tagText ?? 'Course',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLessonTitle() {
    return Text(
      // Dynamic title: Lesson Title by Instructor
      '${lessonData.lessonTitle}\nby ${lessonData.instructor}',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        height: 1.3,
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        // Dynamic description snippet
        'This **${lessonData.totalDuration}** course is categorized as **${lessonData.level}** level. Start learning ${lessonData.lessonTitle} today!',
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black54,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -1),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.bookmark_border,
                size: 28, color: Colors.black54),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Enroll Now'), // Updated text
            ),
          ),
        ],
      ),
    );
  }
}

// Reused StatCard widget
class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color iconColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reused _InfoSection widget
class _InfoSection extends StatelessWidget {
  final String title;
  final List<String> content;

  const _InfoSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        // Create a bulleted list from the content
        ...content.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("• ", style: TextStyle(fontSize: 16, color: Colors.black54)),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
}