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
  final String? lecturerName;
  final bool isOnline;
  final String? link;
  final String? quizDetails;

  Schedule({
    required this.title,
    required this.time,
    required this.location,
    required this.sks,
    this.day,
    this.borderColor,
    this.tag,
    this.locationIcon,
    this.lecturerName,
    this.isOnline = false,
    this.link,
    this.quizDetails,
  });
}

class SubTask {
  final String title;
  final bool isCompleted;

  SubTask({
    required this.title,
    this.isCompleted = false,
  });

  SubTask copyWith({String? title, bool? isCompleted}) {
    return SubTask(
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class Task {
  final String title;
  final String category;
  final DateTime deadline;
  final String time;
  final String iconType; // 'project', 'report', etc.
  final bool isCompleted;
  final String? tag;
  final Color? borderColor;
  final List<SubTask> subTasks;
  final bool hasAttachment;
  final String? reminderSetting;

  Task({
    required this.title,
    required this.category,
    required this.deadline,
    required this.time,
    required this.iconType,
    this.isCompleted = false,
    this.tag,
    this.borderColor,
    this.subTasks = const [],
    this.hasAttachment = false,
    this.reminderSetting,
  });

  Task copyWith({
    String? title,
    String? category,
    DateTime? deadline,
    String? time,
    String? iconType,
    bool? isCompleted,
    String? tag,
    Color? borderColor,
    List<SubTask>? subTasks,
    bool? hasAttachment,
    String? reminderSetting,
  }) {
    return Task(
      title: title ?? this.title,
      category: category ?? this.category,
      deadline: deadline ?? this.deadline,
      time: time ?? this.time,
      iconType: iconType ?? this.iconType,
      isCompleted: isCompleted ?? this.isCompleted,
      tag: tag ?? this.tag,
      borderColor: borderColor ?? this.borderColor,
      subTasks: subTasks ?? this.subTasks,
      hasAttachment: hasAttachment ?? this.hasAttachment,
      reminderSetting: reminderSetting ?? this.reminderSetting,
    );
  }
}
