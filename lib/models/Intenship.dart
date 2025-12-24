import 'package:flutter/material.dart';

class Internship {
  final String role,
  id,

      company,
      location,
      stipend,
      duration,
      category,
      roledescription,
      companytitle,
      companyinfo,
      companysubtitle,
      applicationreview,
      onlineassessment,
      technicalinterview,
      finalinterview,
      offerextension,
      mail,
      website,
      linkedin;
  final List<String> benifitsperks;
  final Color cardColor;
  final Color textColor;
  final IconData iconData;
  final String type;
  final List<String> skills, keyresponsibilities, qualifications;
  final List<String> responsibilities;

  Internship({
    required this.role,
    required this.company,
    required this.location,
    required this.stipend,
    required this.duration,
    required this.category,
    required this.cardColor,
    required this.textColor,
    required this.iconData,
    required this.type,
    required this.skills,
    required this.responsibilities,
    required this.roledescription,
    required this.keyresponsibilities,
    required this.qualifications,
    required this.benifitsperks,
    required this.companytitle,
    required this.companyinfo,
    required this.companysubtitle,
    required this.applicationreview,
    required this.onlineassessment,
    required this.technicalinterview,
    required this.finalinterview,
    required this.offerextension,
    required this.mail,
    required this.website,
    required this.linkedin, required this.id,
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
      roledescription: '${json['roledescription']?.toString() ?? ''}',
      keyresponsibilities: List<String>.from(json['keyresponsibilities'] ?? []),
      qualifications: List<String>.from(json['qualifications'] ?? []),
      benifitsperks:
          (json['benefitsperks'] as List?)
              ?.map((item) => item.toString())
              .toList() ??
          ["CORE CONCEPTS", "PROBLEM SOLVING", "PRACTICE"],
      companytitle: json['companytitle']?.toString() ?? 'NOT FOUND',
      companyinfo: json['companyinfo']?.toString() ?? 'NOT FOUND',
      companysubtitle: '${json['companysubtitle']?.toString() ?? 'NOT FOUND'}',
      applicationreview:
          '${json['applicationreviewdate']?.toString() ?? 'NOT FOUND'}',
      onlineassessment:
          '${json['onlineassessmentdate']?.toString() ?? 'NOT FOUND'}',
      technicalinterview:
          '${json['technicalinterviewdate']?.toString() ?? 'NOT FOUND'}',
      finalinterview:
          '${json['finalinterviewdate']?.toString() ?? 'NOT FOUND'}',
      offerextension:
          ' ${json['offerextensiondate']?.toString() ?? 'NOT FOUND'}',

      mail: '${json['companymail']?.toString() ?? 'NOT FOUND'}',
      website: '${json['companywebsite']?.toString() ?? 'NOT FOUND'}',
      linkedin: '${json['companylinkedin']?.toString() ?? 'NOT FOUND'}', id: json['id'] ?? '', // Ensure your workshops.json includes an "id" field

    );
  }

  static IconData _getIcon(String? name) {
    if (name == 'code') return Icons.code;
    if (name == 'brush') return Icons.brush;
    return Icons.business;
  }
}
