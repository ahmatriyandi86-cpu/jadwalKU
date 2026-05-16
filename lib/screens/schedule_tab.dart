import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/models.dart';
import '../widgets/schedule_card.dart';

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({super.key});

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  bool _isListView = true;

  final List<Schedule> seninSchedules = [
    Schedule(
      title: 'algoritma analisa.',
      time: '07.30-09.10',
      location: 'Lab 2 TI',
      sks: 2,
      day: 'Senin',
      borderColor: AppColors.primary,
      locationIcon: Icons.business,
    ),
  ];

  final List<Schedule> selasaSchedules = [
    Schedule(
      title: 'Pemrograman Mobile.',
      time: '07.30-09.10',
      location: 'Lab 1 TI',
      sks: 3,
      day: 'Selasa',
      borderColor: AppColors.primary,
      locationIcon: Icons.business,
    ),
    Schedule(
      title: 'P. Pemrograman Mobile.',
      time: '09.10-10.50',
      location: 'Lab 1 TI',
      sks: 1,
      day: 'Selasa',
      borderColor: AppColors.primary,
      locationIcon: Icons.business,
    ),
    Schedule(
      title: 'Kecerdasan Buatan.',
      time: '10.00-11.40',
      location: 'Lab 3 TI',
      sks: 3,
      day: 'Selasa',
      borderColor: AppColors.warning,
      tag: '! Kuis',
      locationIcon: Icons.business,
    ),
  ];

  final List<Schedule> rabuSchedules = [
    Schedule(
      title: 'Lanjut Data Dasar Pemrograman.',
      time: '09.10-10.50',
      location: 'Lab 2 TI',
      sks: 3,
      day: 'Rabu',
      borderColor: AppColors.primary,
      locationIcon: Icons.business,
    ),
  ];

  final List<Schedule> jumatSchedules = [
    Schedule(
      title: 'Rekayasa Perangkat Lunak.',
      time: '09.10-10.50',
      location: 'Lab 3 TI',
      sks: 3,
      day: 'Jumat',
      borderColor: AppColors.primary,
      locationIcon: Icons.business,
    ),
    Schedule(
      title: 'Grafika komputer',
      time: '10.00-11.40',
      location: 'Ruang 2 TI',
      sks: 3,
      day: 'Jumat',
      borderColor: AppColors.primary,
      locationIcon: Icons.business,
    ),
  ];

  final List<Schedule> ahadSchedules = [
    Schedule(
      title: 'Riset Operasi.',
      time: '07.30-09.10',
      location: 'Lab 1 TI',
      sks: 3,
      day: 'Ahad',
      borderColor: AppColors.primary,
      locationIcon: Icons.business,
    ),
  ];

  String _getCurrentDay() {
    int weekday = DateTime.now().weekday;
    switch (weekday) {
      case 1: return 'Senin';
      case 2: return 'Selasa';
      case 3: return 'Rabu';
      case 4: return 'Kamis';
      case 5: return 'Jumat';
      case 6: return 'Sabtu';
      case 7: return 'Ahad';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentDay = _getCurrentDay();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // View Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tampilan',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildToggleButton(Icons.view_list, _isListView, () => setState(() => _isListView = true)),
                    _buildToggleButton(Icons.grid_view, !_isListView, () => setState(() => _isListView = false)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          _buildDaySection('Senin', seninSchedules, currentDay == 'Senin'),
          const SizedBox(height: 32),
          _buildDaySection('Selasa', selasaSchedules, currentDay == 'Selasa'),
          const SizedBox(height: 32),
          _buildDaySection('Rabu', rabuSchedules, currentDay == 'Rabu'),
          const SizedBox(height: 32),
          _buildDaySection('Jumat', jumatSchedules, currentDay == 'Jumat'),
          const SizedBox(height: 32),
          _buildDaySection('Ahad', ahadSchedules, currentDay == 'Ahad'),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildToggleButton(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildDaySection(String day, List<Schedule> schedules, bool isToday) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: isToday ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8) : EdgeInsets.zero,
          decoration: isToday ? BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ) : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: isToday ? AppColors.primary : AppColors.primary.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                day,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isToday ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              if (isToday) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Hari Ini',
                    style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20), // Increased spacing between title and cards
        ...schedules.map((s) => ScheduleCard(schedule: s, showSks: false)),
      ],
    );
  }
}
