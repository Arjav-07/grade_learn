import 'package:flutter/material.dart';

class Course {
  final String title;
  final String category;
  final int userCount;
  final IconData iconData;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final String difficulty;
  final String timeDuration;
  final String lessonsNo;

  const Course({
    required this.title,
    required this.category,
    required this.userCount,
    required this.iconData,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.difficulty,
    required this.timeDuration,
    required this.lessonsNo,
  });
}
