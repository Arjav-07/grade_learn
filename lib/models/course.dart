import 'package:flutter/material.dart';

class Course {
  final String id;
  final String logoPath,
      providerName,
      category,
      title,
      difficulty,
      timeDuration,
      lessonsNo,
      about,
      instructorName,
      instructorimg,
      instructorBio;

  final int userCount;
  final int ratingsCount;
  final Color backgroundColor;
  final IconData? iconData;
  final List<dynamic> whatyoulearn;
  final List<dynamic> lessons, skills ;

  Course({
    required this.id,
    required this.logoPath,
    required this.providerName,
    required this.backgroundColor,
    this.iconData,
    required this.category,
    required this.title,
    required this.userCount,
    required this.difficulty,
    required this.timeDuration,
    required this.lessonsNo,
    required this.about,
    required this.lessons,
    required this.ratingsCount,
    required this.skills,
    required this.instructorName,
    required this.instructorBio,
    required this.instructorimg,
    required this.whatyoulearn,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    // This helper extracts the correct IconData based on the category string
    IconData _determineIcon(String cat) {
      String name = cat.toUpperCase();
      if (name.contains('GEOMETRY') || name.contains('MATH'))
        return Icons.calculate;
      if (name.contains('LANGUAGE') || name.contains('SPANISH'))
        return Icons.translate;
      if (name.contains('FLUTTER') || name.contains('CODE'))
        return Icons.developer_mode;
      if (name.contains('FIGMA') || name.contains('DESIGN')) return Icons.brush;
      return Icons.menu_book; // Default icon
    }

    return Course(
      // Ensure these strings match your JSON keys exactly (case-sensitive)
      id: json['course_id']?.toString() ?? json['id']?.toString() ?? '',
      logoPath: json['logoPath']?.toString() ?? 'assets/images/google.png',
      providerName: json['providerName']?.toString() ?? 'GOOGLE',

      // Parses hex string (e.g., "0xFFB5C0FF") into a Color object
      backgroundColor: Color(
        int.parse(json['backgroundColor'] ?? "0xFFFFFFFF"),
      ),

      category: json['category']?.toString() ?? 'GENERAL',
      title: json['title']?.toString() ?? 'UNTITLED COURSE',

      // FIXED: Ensuring numerical data isn't lost
      userCount: json['userCount'] is int
          ? json['userCount']
          : int.tryParse(json['userCount']?.toString() ?? '0') ?? 0,

      // FIXED: If your JSON uses 'duration', this fallback handles it
      timeDuration:
          json['timeDuration']?.toString() ??
          json['duration']?.toString() ??
          '0 HR',

      // FIXED: If your JSON uses 'lessonsCount', this fallback handles it
      lessonsNo:
          json['lessonsNo']?.toString() ??
          json['lessonsCount']?.toString() ??
          '0',

      // FIXED: Addresses the red line error from your earlier screenshot
      about:
          json['about']?.toString() ??
          'No description available for this course.',

      lessons: json['lessons'] is List ? json['lessons'] : [],

      iconData: _determineIcon(json['category']?.toString() ?? ''),
      difficulty: '${json['difficulty']?.toString() ?? 'NOT DEFINED'}',

      ratingsCount: json['ratingsCount'] is int
          ? json['ratingsCount']
          : int.tryParse(json['ratingsCount']?.toString() ?? '0') ?? 0,
      skills:
          (json['skills'] as List?)?.map((item) => item.toString()).toList() ??
          ["CORE CONCEPTS", "PROBLEM SOLVING", "PRACTICE"],
          
      whatyoulearn:
          (json['whatyoulearn'] as List?)
              ?.map((item) => item.toString())
              .toList() ??
          ["CORE CONCEPTS", "PROBLEM SOLVING", "PRACTICE"],

      instructorName: '${json['instructorName']?.toString() ?? 'UNKNOWN'}',
      instructorBio:
          '${json['instructorBio']?.toString() ?? 'NO BIO AVAILABLE.'}',
      instructorimg:
          '${json['instructorimg']?.toString() ?? 'assets/images/instructor.png'}',

      
    );
  }
}
