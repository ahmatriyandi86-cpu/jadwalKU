import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/models.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?>? onChanged;

  const TaskListItem({super.key, required this.task, this.onChanged});

  @override
  Widget build(BuildContext context) {
    Color getTagColor() {
      if (task.tag == 'Mendesak') return Colors.red[50]!;
      if (task.tag == 'Penting') return Colors.orange[50]!;
      if (task.tag == 'Biasa') return Colors.blue[50]!;
      if (task.tag == 'Selesai') return Colors.grey[200]!;
      return Colors.grey[100]!;
    }

    Color getTagTextColor() {
      if (task.tag == 'Mendesak') return Colors.red[700]!;
      if (task.tag == 'Penting') return Colors.orange[700]!;
      if (task.tag == 'Biasa') return Colors.blue[700]!;
      if (task.tag == 'Selesai') return Colors.grey[600]!;
      return Colors.grey[600]!;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: task.isCompleted ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          if (!task.isCompleted)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Border
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: task.borderColor ?? (task.isCompleted ? Colors.grey : AppColors.primary),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          
          // Checkbox
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: task.isCompleted,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              side: BorderSide(color: Colors.grey[400]!),
              activeColor: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          
          // Main Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: task.isCompleted ? Colors.grey[500] : const Color(0xFF1E3A5F),
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    if (task.tag != null)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: getTagColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          task.tag!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: getTagTextColor(),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      task.deadline,
                      style: TextStyle(
                        fontSize: 12, 
                        color: task.isCompleted ? Colors.grey[400] : Colors.grey[600],
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (task.category.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Icon(Icons.book_outlined, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          task.category,
                          style: TextStyle(
                            fontSize: 12, 
                            color: task.isCompleted ? Colors.grey[400] : Colors.grey[600],
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
