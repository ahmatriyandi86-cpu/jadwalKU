import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/models.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final bool showSks;

  const ScheduleCard({super.key, required this.schedule, this.showSks = true});

  String? _getSessionStatus() {
    try {
      // Very basic parser for "HH:mm - HH:mm"
      final parts = schedule.time.split(' - ');
      if (parts.length != 2) return null;

      final now = DateTime.now();
      final startTimeParts = parts[0].split(':');
      final endTimeParts = parts[1].split(':');

      final start = DateTime(now.year, now.month, now.day, int.parse(startTimeParts[0]), int.parse(startTimeParts[1]));
      final end = DateTime(now.year, now.month, now.day, int.parse(endTimeParts[0]), int.parse(endTimeParts[1]));

      if (now.isAfter(start) && now.isBefore(end)) {
        return 'Sedang Berlangsung';
      } else if (now.isBefore(start)) {
        final diff = start.difference(now).inMinutes;
        if (diff <= 60) {
          return 'Dimulai dlm $diff mnt';
        }
      }
    } catch (e) {
      // ignore
    }
    return null;
  }

  void _showQuizDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.red),
            SizedBox(width: 10),
            Text('Detail Kuis'),
          ],
        ),
        content: Text(schedule.quizDetails ?? 'Tidak ada detail tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = _getSessionStatus();

    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Increased margin
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 80, // Increased height to accommodate lecturer name
            decoration: BoxDecoration(
              color: schedule.borderColor ?? AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        schedule.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                    ),
                    if (schedule.tag != null)
                      GestureDetector(
                        onTap: schedule.tag!.contains('Kuis') ? () => _showQuizDetails(context) : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                            border: schedule.tag!.contains('Kuis') ? Border.all(color: Colors.red.withValues(alpha: 0.2)) : null,
                          ),
                          child: Text(
                            schedule.tag!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[400],
                            ),
                          ),
                        ),
                      )
                    else if (showSks)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'SKS: ${schedule.sks}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                  ],
                ),
                if (schedule.lecturerName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    schedule.lecturerName!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          schedule.time,
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        if (status != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: status == 'Sedang Berlangsung' ? Colors.green[50] : Colors.blue[50],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: status == 'Sedang Berlangsung' ? Colors.green[700] : Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    InkWell(
                      onTap: schedule.isOnline && schedule.link != null
                          ? () {
                              // In a real app, use url_launcher: launchUrl(Uri.parse(schedule.link!));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Membuka Zoom: ${schedule.link}')),
                              );
                            }
                          : null,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            schedule.locationIcon ?? Icons.location_on_outlined,
                            size: 14,
                            color: schedule.isOnline ? AppColors.primary : Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            schedule.location,
                            style: TextStyle(
                              fontSize: 13,
                              color: schedule.isOnline ? AppColors.primary : Colors.grey[600],
                              decoration: schedule.isOnline ? TextDecoration.underline : null,
                              fontWeight: schedule.isOnline ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
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
