import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/models.dart';
import '../widgets/schedule_card.dart';

class ScheduleTab extends StatelessWidget {
  final List<Schedule> seninSchedules = [
    Schedule(
      title: 'Struktur Data',
      time: '08:00 - 10:30',
      location: 'Lab Komputer 3',
      sks: 3,
      day: 'Senin',
      borderColor: const Color(0xFF0056B3),
      locationIcon: Icons.business, // using business icon for building/lab
    ),
    Schedule(
      title: 'Pemrograman Mobile',
      time: '13:00 - 15:30',
      location: 'Ruang 402',
      sks: 3,
      day: 'Senin',
      borderColor: const Color(0xFF7BA0FF),
      locationIcon: Icons.business,
    ),
  ];

  final List<Schedule> selasaSchedules = [
    Schedule(
      title: 'Kecerdasan Buatan',
      time: '09:00 - 11:30',
      location: 'Gedung D, R.301',
      sks: 3,
      day: 'Selasa',
      borderColor: const Color(0xFF8B4513), // Brown color
      tag: '! Kuis',
      locationIcon: Icons.business,
    ),
  ];

  final List<Schedule> rabuSchedules = [
    Schedule(
      title: 'Etika Profesi',
      time: '10:00 - 12:00',
      location: 'Daring (Zoom)',
      sks: 2,
      day: 'Rabu',
      borderColor: const Color(0xFF1E3A5F),
      locationIcon: Icons.computer,
    ),
  ];

  ScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDaySection('Senin', seninSchedules),
          const SizedBox(height: 24),
          _buildDaySection('Selasa', selasaSchedules),
          const SizedBox(height: 24),
          _buildDaySection('Rabu', rabuSchedules),
          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildDaySection(String day, List<Schedule> schedules) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              day,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...schedules.map((s) => ScheduleCard(schedule: s, showSks: false)),
      ],
    );
  }
}
