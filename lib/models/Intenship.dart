import 'package:flutter/material.dart';

class Internship {
  final String id, role, company, location, stipend, duration, category, type;
  final String roledescription, companytitle, companyinfo, companysubtitle;
  final String applicationreview, onlineassessment, technicalinterview, finalinterview, offerextension;
  final String mail, website, linkedin;
  final List<String> skills, keyresponsibilities, qualifications, benefitsperks;
  final Color cardColor, textColor;
  final IconData iconData;

  Internship({
    required this.id, required this.role, required this.company, required this.location,
    required this.stipend, required this.duration, required this.category, required this.type,
    required this.cardColor, required this.textColor, required this.iconData,
    required this.skills, required this.keyresponsibilities, required this.qualifications,
    required this.benefitsperks, required this.roledescription, required this.companytitle,
    required this.companyinfo, required this.companysubtitle, required this.applicationreview,
    required this.onlineassessment, required this.technicalinterview, required this.finalinterview,
    required this.offerextension, required this.mail, required this.website, required this.linkedin,
  });

  factory Internship.fromJson(Map<String, dynamic> json) {
    Color parseHex(String? hex) => Color(int.parse(hex!.replaceFirst('#', '0xFF')));
    
    return Internship(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? 'REMOTE',
      stipend: json['stipend'] ?? 'N/A',
      duration: json['duration'] ?? 'N/A',
      category: json['category'] ?? 'GENERAL',
      type: json['type'] ?? 'REMOTE',
      cardColor: parseHex(json['cardColor']),
      textColor: parseHex(json['textColor']),
      iconData: json['iconName'] == 'brush' ? Icons.brush : Icons.code,
      skills: List<String>.from(json['skills'] ?? []),
      keyresponsibilities: List<String>.from(json['keyresponsibilities'] ?? []),
      qualifications: List<String>.from(json['qualifications'] ?? []),
      benefitsperks: List<String>.from(json['benefitsperks'] ?? []),
      roledescription: json['roledescription'] ?? '',
      companytitle: json['companytitle'] ?? '',
      companyinfo: json['companyinfo'] ?? '',
      companysubtitle: json['companysubtitle'] ?? '',
      applicationreview: json['applicationreviewdate'] ?? '1-2 WEEKS',
      onlineassessment: json['onlineassessmentdate'] ?? '3-5 DAYS',
      technicalinterview: json['technicalinterviewdate'] ?? '1 WEEK',
      finalinterview: json['finalinterviewdate'] ?? '1 WEEK',
      offerextension: json['offerextensiondate'] ?? '1-9 WEEKS',
      mail: json['companymail'] ?? '',
      website: json['companywebsite'] ?? '',
      linkedin: json['companylinkedin'] ?? '',
    );
  }
}