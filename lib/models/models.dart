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
  final String id;
  final String title;
  final String category;
  final String description;
  final DateTime deadline;
  final String time;
  final String iconType; // 'project', 'report', etc.
  final bool isCompleted;
  final String? tag;
  final Color? borderColor;
  final List<SubTask> subTasks;
  final bool hasAttachment;
  final String? reminderSetting;
  final String? attachmentUrl;
  final String? attachmentFileName;
  final DateTime? submittedAt;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.deadline,
    required this.time,
    required this.iconType,
    this.isCompleted = false,
    this.tag,
    this.borderColor,
    this.subTasks = const [],
    this.hasAttachment = false,
    this.reminderSetting,
    this.attachmentUrl,
    this.attachmentFileName,
    this.submittedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? category,
    String? description,
    DateTime? deadline,
    String? time,
    String? iconType,
    bool? isCompleted,
    String? tag,
    Color? borderColor,
    List<SubTask>? subTasks,
    bool? hasAttachment,
    String? reminderSetting,
    String? attachmentUrl,
    String? attachmentFileName,
    DateTime? submittedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      time: time ?? this.time,
      iconType: iconType ?? this.iconType,
      isCompleted: isCompleted ?? this.isCompleted,
      tag: tag ?? this.tag,
      borderColor: borderColor ?? this.borderColor,
      subTasks: subTasks ?? this.subTasks,
      hasAttachment: hasAttachment ?? this.hasAttachment,
      reminderSetting: reminderSetting ?? this.reminderSetting,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      attachmentFileName: attachmentFileName ?? this.attachmentFileName,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }
}
