import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/models.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    Color iconBgColor = task.iconType == 'project' ? const Color(0xFFFFE8E0) : const Color(0xFFE8F0FE);
    Color iconColor = task.iconType == 'project' ? const Color(0xFFD35400) : AppColors.primary;
    IconData iconData = task.iconType == 'project' ? Icons.assignment : Icons.code;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A5F),
                  ),
                ),
                Text(
                  task.category,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: task.deadline == 'Besok' ? const Color(0xFFFFE0E0) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.deadline,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: task.deadline == 'Besok' ? Colors.red[700] : Colors.grey[600],
                  ),
                ),
              ),
              if (task.time.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  task.time,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
