import 'package:flutter/material.dart';

class WorkshopData {
  final String id,title, instructor, instructorBio, duration, date, type, description,meetingLink;
  final int seatsLeft, totalSeats;
  final Color brandColor;
  final List<String> topics;

  WorkshopData({
    required this.title, required this.instructor, required this.instructorBio,
    required this.duration, required this.seatsLeft, required this.totalSeats,
    required this.date, required this.brandColor, required this.type,
    required this.description, required this.topics, required this.id, required this.meetingLink,
  });

  factory WorkshopData.fromJson(Map<String, dynamic> json, String documentId) {
  return WorkshopData(
    id: documentId, // Ensure the ID is assigned from the JSON key
    title: json['title'] ?? "",
    instructor: json['instructor'] ?? "",
    instructorBio: json['instructorBio'] ?? "",
    duration: json['duration'] ?? "",
    seatsLeft: json['seatsLeft'] ?? 0,
    totalSeats: json['totalSeats'] ?? 0,
    date: json['date'] ?? "",
    type: json['type'] ?? "UPCOMING",
    brandColor: Color(int.parse((json['brandColor'] ?? "#000000").replaceFirst('#', '0xFF'))),
    description: json['description'] ?? "",
    topics: List<String>.from(json['topics'] ?? []),
    meetingLink: json['meetingLink'] ?? "",
  );
}
}