import 'package:flutter/material.dart';

class WorkshopData {
  final String title, instructor, instructorBio, duration, date, type, description;
  final int seatsLeft, totalSeats;
  final Color brandColor;
  final List<String> topics;

  WorkshopData({
    required this.title, required this.instructor, required this.instructorBio,
    required this.duration, required this.seatsLeft, required this.totalSeats,
    required this.date, required this.brandColor, required this.type,
    required this.description, required this.topics,
  });

  factory WorkshopData.fromJson(Map<String, dynamic> json) {
  return WorkshopData(
    title: json['title'] ?? "",
    instructor: json['instructor'] ?? "",
    duration: json['duration'] ?? "",
    seatsLeft: json['seatsLeft'] ?? 0,
    totalSeats: json['totalSeats'] ?? 0,
    date: json['date'] ?? "",
    type: json['type'] ?? "UPCOMING",
    // This is the most common crash point: parsing the color string
    brandColor: Color(int.parse(json['brandColor'].replaceFirst('#', '0xFF'))),
    description: json['description'] ?? "",
    topics: List<String>.from(json['topics'] ?? []), instructorBio: json['instructorBio'] ?? "",
  );
}
}


