import 'package:flutter/material.dart';
import 'package:grade_learn/pages/skill_page.dart';

class LessonDetailsPage extends StatelessWidget {
  // 1. Accepts the dynamic Course object
  final Course course;
  const LessonDetailsPage({super.key, required this.course});

  // Lesson data (static for the sub-list)
  final List<Map<String, dynamic>> lessonsData = const [
    {
      'title': 'Greeting & Introducing',
      'duration': '5 mins 20 sec',
      'isCompleted': true,
    },
    {
      'title': 'Ordering Food at a Restaurant',
      'duration': '8 mins 10 sec',
      'isCompleted': true,
    },
    {
      'title': 'Asking for Directions',
      'duration': '7 mins 30 sec',
      'isCompleted': false,
    },
    {
      'title': 'Shopping and Making Purchases',
      'duration': '10 mins 05 sec',
      'isCompleted': false,
    },
    {
      'title': 'Making a Phone Call',
      'duration': '6 mins 45 sec',
      'isCompleted': false,
    },
  ];
  
  // NOTE: This color is derived from the course data for theme consistency
  Color get headerColor => course.backgroundColor.withOpacity(0.2); 
  Color get primaryColor => course.iconColor; // Use iconColor as main accent

  @override
  Widget build(BuildContext context) {
    return Container(
      color: headerColor,
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
                _buildLessonsList(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final completedLessons =
        lessonsData.where((lesson) => lesson['isCompleted'] as bool).length;
    final totalLessons = lessonsData.length;
    final progress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          _buildAppBar(context),
          const SizedBox(height: 20),
          _buildCourseIcon(),
          const SizedBox(height: 16),
          _buildBeginnerChip(),
          const SizedBox(height: 8),
          _buildCourseTitle(),
          const SizedBox(height: 16),
          _buildProgressIndicator(progress, completedLessons, totalLessons),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(double progress, int completed, int total) {
    // Ensure the progress bar color is visually distinct
    final Color progressColor = primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              Text(
                '$completed of $total lessons completed',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lessons',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...lessonsData.map((lesson) {
            return LessonTile(
              title: lesson['title'] as String,
              duration: lesson['duration'] as String,
              isCompleted: lesson['isCompleted'] as bool,
              // Pass the primary color for the tile icons
              primaryColor: primaryColor,
            );
          }).toList(),
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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Text(
            'Lesson Details',
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

  Widget _buildCourseIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Icon(
        // ➡️ Dynamic Icon
        course.iconData,
        color: primaryColor,
        size: 40,
      ),
    );
  }

  Widget _buildBeginnerChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // ➡️ Dynamic Color
        color: primaryColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Text(
        // ➡️ Dynamic Category
        course.category.split(' ').first,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCourseTitle() {
    return Text(
      // ➡️ Dynamic Title
      course.title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        height: 1.3,
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Stat 1: Total Lessons (Dynamic from hardcoded list)
          StatCard(
            icon: Icons.book_outlined,
            value: lessonsData.length.toString(),
            label: 'Lessons',
            color: const Color(0xFFD3E5FD),
            iconColor: const Color(0xFF00468D),
          ),
          const SizedBox(width: 16),
          // Stat 2: Quizzes (Static for now)
          const StatCard(
            icon: Icons.quiz_outlined,
            value: '12',
            label: 'Quizzes',
            color: Color(0xFFFFE8D6),
            iconColor: Color(0xFFC26A00),
          ),
          const SizedBox(width: 16),
          // Stat 3: Total Students (Dynamic from course object)
          StatCard(
            icon: Icons.group,
            value: '${course.userCount}+',
            label: 'Students',
            color: const Color(0xFFF3E5F5),
            iconColor: const Color(0xFF6A1B9A),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        // ➡️ Dynamic Description
        'Enhance your skills in **${course.category}** with this course, **${course.title}**. Master common concepts and improve your practical application today.',
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
          )),
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
              child: const Text('Start Lessons'),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable widget for statistics cards
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

// Reusable widget for a single lesson tile
class LessonTile extends StatelessWidget {
  final String title;
  final String duration;
  final bool isCompleted;
  final Color primaryColor;

  const LessonTile({
    super.key,
    required this.title,
    required this.duration,
    this.isCompleted = false,
    this.primaryColor = const Color(0xFF6750A4), // Default color
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
          ]),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // Use a lighter shade of the primary color for background
              color: primaryColor.withOpacity(0.2), 
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(Icons.book_outlined, color: primaryColor), // Primary color icon
          ),
          const SizedBox(width: 16),
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
          if (isCompleted)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: primaryColor, // Completed checkmark uses primary color
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