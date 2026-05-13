import 'package:flutter/material.dart';

class Schedule {
  final String title;
  final String time;
  final String location;
  final int sks;
  final String? day;
  final Color? borderColor;
  final String? tag;
  final IconData? locationIcon;

  Schedule({
    required this.title,
    required this.time,
    required this.location,
    required this.sks,
    this.day,
    this.borderColor,
    this.tag,
    this.locationIcon,
  });
}
class Task {
  final String title;
  final String category;
  final String deadline;
  final String time;
  final String iconType; // 'project', 'report', etc.
  final bool isCompleted;
  final String? tag;
  final Color? borderColor;

  Task({
    required this.title,
    required this.category,
    required this.deadline,
    required this.time,
    required this.iconType,
    this.isCompleted = false,
    this.tag,
    this.borderColor,
  });
}
