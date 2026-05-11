class Schedule {
  final String title;
  final String time;
  final String location;
  final int sks;

  Schedule({
    required this.title,
    required this.time,
    required this.location,
    required this.sks,
  });
}

class Task {
  final String title;
  final String category;
  final String deadline;
  final String time;
  final String iconType; // 'project', 'report', etc.

  Task({
    required this.title,
    required this.category,
    required this.deadline,
    required this.time,
    required this.iconType,
  });
}
