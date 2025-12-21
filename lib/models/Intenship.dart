import 'package:flutter/material.dart';

class Internship {
  final String role;
  final String company;
  final String location;
  final String stipend;
  final String duration;
  final String category;
  final Color cardColor;
  final Color textColor;
  final IconData iconData;
  final String type;
  final List<String> skills;
  final List<String> responsibilities;

  Internship({
    required this.role, required this.company, required this.location,
    required this.stipend, required this.duration, required this.category,
    required this.cardColor, required this.textColor, required this.iconData,
    required this.type, required this.skills, required this.responsibilities,
  });

  factory Internship.fromJson(Map<String, dynamic> json) {
    // Helper to parse Hex Strings like "0xFFD3E5FD"
    Color parseColor(String? hex) {
      try {
        return Color(int.parse(hex!.replaceFirst('#', '0xFF')));
      } catch (e) {
        return Colors.blueGrey; // Fallback color
      }
    }

    return Internship(
      role: json['role']?.toString() ?? 'Unknown Role',
      company: json['company']?.toString() ?? 'Unknown Company',
      location: json['location']?.toString() ?? 'Remote',
      stipend: json['stipend']?.toString() ?? 'N/A',
      duration: json['duration']?.toString() ?? 'N/A',
      category: json['category']?.toString() ?? 'General',
      type: json['type']?.toString() ?? 'REMOTE',
      cardColor: parseColor(json['cardColor']),
      textColor: parseColor(json['textColor']),
      iconData: _getIcon(json['iconName']),
      skills: List<String>.from(json['skills'] ?? []),
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
    );
  }

  static IconData _getIcon(String? name) {
    if (name == 'code') return Icons.code;
    if (name == 'brush') return Icons.brush;
    return Icons.business;
  }
}