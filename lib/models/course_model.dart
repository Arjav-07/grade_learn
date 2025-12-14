import 'package:flutter/material.dart';

class Course {
  final String id; // Added ID for reliable comparison
  final String title;
  final String category;
  final IconData iconData;
  final Color backgroundColor;
  final Color iconColor;
  final int userCount;
  final String instructor;

  const Course({
    required this.id,
    required this.title,
    required this.category,
    required this.iconData,
    required this.backgroundColor,
    required this.iconColor,
    required this.userCount,
    required this.instructor,
  });

  // Example Course Data
  static final sampleCourse = Course(
    id: 'spanish_conv_101',
    title: 'Mastering Spanish Conversation',
    category: 'Language Intermediate',
    iconData: Icons.language,
    backgroundColor: const Color(0xFFC3B0E5), // Purple-ish
    iconColor: const Color(0xFF6750A4),
    userCount: 3450,
    instructor: 'Dr. Isabella Rossi',
  );
}