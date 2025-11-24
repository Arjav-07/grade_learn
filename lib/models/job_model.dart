import 'package:flutter/material.dart';

// Helper function to convert hex string to Color object
Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse(hexCode) | 0xFF000000);
}

// Helper function to convert string name to IconData object (Basic check)
IconData iconDataFromString(String iconName) {
  if (iconName == 'Icons.business_center_outlined') {
    return Icons.business_center_outlined;
  } else if (iconName == 'Icons.hourglass_bottom_outlined') {
    return Icons.hourglass_bottom_outlined;
  } else if (iconName == 'Icons.trending_up') {
    return Icons.trending_up;
  }
  return Icons.error; // Default fallback icon
}


// --- Updated Data Model for a Job Card and Details ---
class JobCardData {
  final int id;
  final String jobTitle;
  final String company;
  final String location;
  final String salary;
  final String duration;
  final String? tagText;
  final IconData? tagIcon;
  final Color cardColor;
  final Color textColor;

  // Detail Page Fields
  final String typeChipText;
  final Color typeChipColor;
  final String stipendValue;
  final String applicantsValue;
  final String description;
  final List<String> aboutContent;
  final List<String> skillsRequired;


  JobCardData({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.salary,
    required this.duration,
    this.tagText,
    this.tagIcon,
    required this.cardColor,
    required this.textColor,
    // Detail Page
    required this.typeChipText,
    required this.typeChipColor,
    required this.stipendValue,
    required this.applicantsValue,
    required this.description,
    required this.aboutContent,
    required this.skillsRequired,
  });

  // Factory constructor to create a JobCardData object from a JSON map
  factory JobCardData.fromJson(Map<String, dynamic> json) {
    return JobCardData(
      id: json['id'],
      jobTitle: json['jobTitle'],
      company: json['company'],
      location: json['location'],
      salary: json['salary'],
      duration: json['duration'],
      tagText: json['tagText'],
      tagIcon: iconDataFromString(json['tagIcon']),
      cardColor: colorFromHex(json['cardColorHex']),
      textColor: colorFromHex(json['textColorHex']),
      // Detail Page fields
      typeChipText: json['typeChipText'],
      typeChipColor: colorFromHex(json['typeChipColorHex']),
      stipendValue: json['stipendValue'],
      applicantsValue: json['applicantsValue'],
      description: json['description'],
      aboutContent: List<String>.from(json['aboutContent']),
      skillsRequired: List<String>.from(json['skillsRequired']),
    );
  }
}