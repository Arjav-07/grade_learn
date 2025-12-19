import 'package:flutter/material.dart';

class WorkshopData {
  final String title;
  final String instructor;
  final String duration;
  final int seatsLeft;
  final int totalSeats;
  final String date;
  final Color brandColor;
  final String type; // LIVE / UPCOMING / FULL

  WorkshopData({
    required this.title,
    required this.instructor,
    required this.duration,
    required this.seatsLeft,
    required this.totalSeats,
    required this.date,
    required this.brandColor,
    required this.type,
  });
}
