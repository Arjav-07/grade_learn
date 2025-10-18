// The main widget for the lesson details screen, as shown in the image
import 'package:flutter/material.dart';

class LessonDetailsPage extends StatelessWidget {
  const LessonDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The bottom navigation bar which contains the bookmark icon and start button
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
            _buildLessonsList(),
            // Add some padding at the bottom to ensure content isn't hidden
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Builds the top header section with the purple background
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFEADDFF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            const SizedBox(height: 20),
            _buildCourseIcon(),
            const SizedBox(height: 16),
            _buildBeginnerChip(),
            const SizedBox(height: 8),
            _buildCourseTitle(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Builds the custom app bar with back and share buttons
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.3),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () {
                // In a real app, you would use Navigator.pop(context)
              },
            ),
          ),
          // Page Title
          const Text(
            'Lesson Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          // Share button
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

  // Builds the icon with the two speech bubbles
  Widget _buildCourseIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: const Icon(
        Icons.speaker_notes,
        color: Color(0xFF6750A4),
        size: 40,
      ),
    );
  }

  // Builds the "Beginner" chip
  Widget _buildBeginnerChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF6750A4),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Text(
        'Beginner',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Builds the main course title
  Widget _buildCourseTitle() {
    return const Text(
      'Mastering Everyday\nConversations',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        height: 1.3,
      ),
    );
  }

  // Builds the section with statistics (Lessons, Quizzes, Hours)
  Widget _buildStatsSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatCard(
            icon: Icons.book_outlined,
            value: '20',
            label: 'Lessons',
            color: Color(0xFFD3E5FD),
            iconColor: Color(0xFF00468D),
          ),
          SizedBox(width: 16),
          StatCard(
            icon: Icons.quiz_outlined,
            value: '12',
            label: 'Quizzes',
            color: Color(0xFFFFE8D6),
            iconColor: Color(0xFFC26A00),
          ),
          SizedBox(width: 16),
          StatCard(
            icon: Icons.access_time,
            value: '5.0',
            label: 'Hours',
            color: Color(0xFFF3E5F5),
            iconColor: Color(0xFF6A1B9A),
          ),
        ],
      ),
    );
  }

  // Builds the course description text
  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        'Enhance your daily communication skills with practical lessons and engaging quizzes. Master common phrases, improve pronunciation.',
        style: TextStyle(
          fontSize: 15,
          color: Colors.black54,
          height: 1.5,
        ),
      ),
    );
  }

  // Builds the list of lessons section
  Widget _buildLessonsList() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lessons',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          // A single lesson item
          LessonTile(
            title: 'Greeting & Introducing',
            duration: '5 mins 20 sec',
            isCompleted: true,
          ),
          // You can add more LessonTile widgets here for more lessons
          LessonTile(
            title: 'Ordering Food at a Restaurant',
            duration: '8 mins 10 sec',
            isCompleted: true,
          ),
          LessonTile(
            title: 'Asking for Directions',
            duration: '7 mins 30 sec',
            isCompleted: false,
          ),
          LessonTile(
            title: 'Shopping and Making Purchases',
            duration: '10 mins 05 sec',
            isCompleted: false,
          ),
           LessonTile(
            title: 'Making a Phone Call',
            duration: '6 mins 45 sec',
            isCompleted: false,
          ),
        ],
      ),
    );
  }

  // Builds the fixed bottom bar with bookmark and start button
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        )
      ),
      child: Row(
        children: [
          // Bookmark button
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.bookmark_border, size: 28, color: Colors.black54),
          ),
          const SizedBox(width: 16),
          // Start Lessons button
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
              child: const Text('Start Lessons'),
            ),
          ),
        ],
      ),
    );
  }
}

// A reusable widget for the statistics cards
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

// A reusable widget for a single lesson tile in the list
class LessonTile extends StatelessWidget {
  final String title;
  final String duration;
  final bool isCompleted;

  const LessonTile({
    super.key,
    required this.title,
    required this.duration,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          )
        ]
      ),
      child: Row(
        children: [
          // Icon on the left
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD3E5FD),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.book_outlined, color: Color(0xFF00468D)),
          ),
          const SizedBox(width: 16),
          // Title and duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          // Checkmark icon if completed
          if (isCompleted)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFF6750A4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }
}