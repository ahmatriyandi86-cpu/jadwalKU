import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/app_utils.dart';
import '../models/models.dart';
import '../providers/task_provider.dart';
import '../screens/task_detail_screen.dart';

class TaskListItem extends StatefulWidget {
  final Task task;

  const TaskListItem({
    super.key,
    required this.task,
  });

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  bool _isExpanded = false;

  Color getTagColor() {
    if (widget.task.tag == 'Mendesak') return const Color(0xFFFFEBEE); // Red 50
    if (widget.task.tag == 'Penting') return const Color(0xFFFFF3E0); // Orange 50
    if (widget.task.tag == 'Biasa') return const Color(0xFFE3F2FD); // Blue 50
    if (widget.task.tag == 'Selesai') return const Color(0xFFECEFF1); // BlueGrey 50
    return const Color(0xFFF5F5F5);
  }

  Color getTagTextColor() {
    if (widget.task.tag == 'Mendesak') return const Color(0xFFC62828); // Red 800
    if (widget.task.tag == 'Penting') return const Color(0xFFE65100); // Orange 900
    if (widget.task.tag == 'Biasa') return const Color(0xFF1565C0); // Blue 800
    if (widget.task.tag == 'Selesai') return const Color(0xFF37474F); // BlueGrey 800
    return const Color(0xFF616161);
  }

  Color getBarColor() {
    if (widget.task.isCompleted) return Colors.grey[400]!;
    if (widget.task.tag == 'Mendesak') return const Color(0xFFE53935); // Red 600
    if (widget.task.tag == 'Penting') return const Color(0xFFFB8C00); // Orange 600
    if (widget.task.tag == 'Biasa') return const Color(0xFF1E88E5); // Blue 600
    return AppColors.primary;
  }

  void _showReminderDialog() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    String? selected = widget.task.reminderSetting;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                      const SizedBox(width: 12),
                      const Text(
                        'Atur Pengingat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pilih kapan Anda ingin diingatkan untuk tugas "${widget.task.title}":',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  _buildReminderOption(setModalState, 'Tepat waktu', 'on_time', selected, (val) => selected = val),
                  _buildReminderOption(setModalState, '3 jam sebelum deadline', '3_hours', selected, (val) => selected = val),
                  _buildReminderOption(setModalState, '1 hari sebelum deadline', '1_day', selected, (val) => selected = val),
                  _buildReminderOption(setModalState, '2 hari sebelum deadline', '2_days', selected, (val) => selected = val),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        taskProvider.updateTaskReminder(widget.task.id, selected ?? 'on_time');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.white),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text('Pengingat berhasil disimpan untuk "${widget.task.title}"!'),
                                ),
                              ],
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            backgroundColor: const Color(0xFF2E7D32),
                          ),
                        );
                      },
                      child: const Text('Simpan Pengingat', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReminderOption(
    StateSetter setModalState,
    String label,
    String value,
    String? selected,
    ValueChanged<String?> onSelect,
  ) {
    return RadioListTile<String>(
      title: Text(label, style: const TextStyle(fontSize: 14)),
      value: value,
      groupValue: selected,
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
      onChanged: (val) {
        setModalState(() {
          onSelect(val);
        });
      },
    );
  }

  void _exportToCalendar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Tugas "${widget.task.title}" berhasil diekspor ke Google Calendar!'),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final completedSubTasks = widget.task.subTasks.where((s) => s.isCompleted).length;
    final totalSubTasks = widget.task.subTasks.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: widget.task.isCompleted ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          if (!widget.task.isCompleted)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(taskId: widget.task.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left Border
                    Container(
                      width: 4,
                      height: 52,
                      decoration: BoxDecoration(
                        color: getBarColor(),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Checkbox
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: widget.task.isCompleted,
                        onChanged: (val) {
                          taskProvider.toggleTaskCompletion(widget.task.id, val ?? false);
                        },
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
                                  widget.task.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: widget.task.isCompleted ? Colors.grey[500] : const Color(0xFF1E3A5F),
                                    decoration: widget.task.isCompleted ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ),
                              if (widget.task.tag != null)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: getTagColor(),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    widget.task.tag!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: getTagTextColor(),
                                    ),
                                  ),
                                ),
                              if (totalSubTasks > 0)
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isExpanded = !_isExpanded;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    margin: const EdgeInsets.only(left: 4),
                                    child: Icon(
                                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                                      color: Colors.grey[600],
                                      size: 20,
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
                                AppUtils.formatRelativeDeadline(widget.task.deadline),
                                style: TextStyle(
                                  fontSize: 12, 
                                  color: widget.task.isCompleted ? Colors.grey[400] : Colors.grey[600],
                                  decoration: widget.task.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              if (widget.task.category.isNotEmpty) ...[
                                const SizedBox(width: 16),
                                Icon(Icons.book_outlined, size: 14, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.task.category,
                                    style: TextStyle(
                                      fontSize: 12, 
                                      color: widget.task.isCompleted ? Colors.grey[400] : Colors.grey[600],
                                      decoration: widget.task.isCompleted ? TextDecoration.lineThrough : null,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                              if (widget.task.hasAttachment) ...[
                                const SizedBox(width: 12),
                                Icon(Icons.attach_file, size: 14, color: Colors.grey[500]),
                              ],
                              if (totalSubTasks > 0) ...[
                                const SizedBox(width: 12),
                                Icon(Icons.playlist_add_check, size: 16, color: widget.task.isCompleted ? Colors.grey[400] : AppColors.primary),
                                const SizedBox(width: 2),
                                Text(
                                  '$completedSubTasks/$totalSubTasks',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: widget.task.isCompleted ? Colors.grey[400] : AppColors.primary,
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
                
                // Expandable Section
                if (_isExpanded) ...[
                  const Divider(height: 24, thickness: 1),
                  if (widget.task.subTasks.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sub-tugas (Checklist):',
                          style: TextStyle(
                            fontSize: 12, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xFF1E3A5F),
                          ),
                        ),
                        Text(
                          '$completedSubTasks/$totalSubTasks Selesai',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.task.subTasks.length,
                      itemBuilder: (context, idx) {
                        final sub = widget.task.subTasks[idx];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: InkWell(
                            onTap: () {
                              taskProvider.toggleSubTask(widget.task.id, idx, !sub.isCompleted);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                      value: sub.isCompleted,
                                      onChanged: (val) {
                                        taskProvider.toggleSubTask(widget.task.id, idx, val ?? false);
                                      },
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      side: BorderSide(color: Colors.grey[400]!),
                                      activeColor: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      sub.title,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: sub.isCompleted ? Colors.grey[500] : const Color(0xFF1E3A5F),
                                        decoration: sub.isCompleted ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _showReminderDialog,
                          icon: Icon(
                            widget.task.reminderSetting != null ? Icons.notifications_active : Icons.notifications_active_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          label: Text(
                            widget.task.reminderSetting != null ? 'Reminder Aktif' : 'Atur Pengingat',
                            style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _exportToCalendar,
                          icon: Icon(Icons.calendar_today_outlined, size: 16, color: Colors.green[700]),
                          label: Text(
                            'Ekspor Kalender',
                            style: TextStyle(fontSize: 12, color: Colors.green[700], fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.green.withValues(alpha: 0.3)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
