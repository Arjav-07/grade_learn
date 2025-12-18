import 'package:flutter/material.dart';

class LessonCardData {
  final String lessonTitle;
  final String instructor;
  final String level;
  final String price;
  final String totalDuration;
  final String? tagText;
  final IconData? tagIcon;
  final Color cardColor;
  final Color textColor;

  LessonCardData({
    required this.lessonTitle,
    required this.instructor,
    required this.level,
    required this.price,
    required this.totalDuration,
    this.tagText,
    this.tagIcon,
    required this.cardColor,
    required this.textColor,
  });
}