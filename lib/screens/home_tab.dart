import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/models.dart';
import '../widgets/schedule_card.dart';
import '../widgets/task_card.dart';

class HomeTab extends StatelessWidget {
  final List<Schedule> schedules = [
    Schedule(
      title: 'Struktur Data',
      time: '08:00 - 10:00',
      location: 'Lab Komputer 3',
      sks: 3,
    ),
  ];

  final List<Task> tasks = [
    Task(
      title: 'AI Project',
      category: 'Kecerdasan Buatan',
      deadline: 'Besok',
      time: '23:59 WIB',
      iconType: 'project',
    ),
    Task(
      title: 'Laporan Basis Data',
      category: 'Basis Data I',
      deadline: '3 Hari',
      time: '',
      iconType: 'report',
    ),
  ];

  HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Section
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              children: const [
                TextSpan(text: 'Halo, Ryandi '),
                TextSpan(text: '👋', style: TextStyle(fontSize: 24)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Semangat belajarnya hari ini!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Calendar Widget
          _buildCalendar(),
          
          const SizedBox(height: 24),
          
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'TUGAS SELESAI',
                  '12/15',
                  AppColors.darkBlueCard,
                  Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'KULIAH HARI INI',
                  '3 Sesi',
                  AppColors.lightBlueCard,
                  AppColors.primary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Schedule Section
          _buildSectionHeader('Jadwal Hari Ini'),
          const SizedBox(height: 12),
          ...schedules.map((s) => ScheduleCard(schedule: s)),
          
          const SizedBox(height: 32),
          
          // Tasks Section
          _buildSectionHeader('Deadline Tugas'),
          const SizedBox(height: 12),
          ...tasks.map((t) => TaskCard(task: t)),
          
          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Oktober 2023',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Row(
                children: [
                  Icon(Icons.chevron_left, color: AppColors.primary, size: 20),
                  const SizedBox(width: 16),
                  Icon(Icons.chevron_right, color: AppColors.primary, size: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateItem('S', '25'),
              _buildDateItem('S', '26'),
              _buildDateItem('R', '1'),
              _buildDateItem('K', '2'),
              _buildDateItem('J', '3', isSelected: true),
              _buildDateItem('S', '4'),
              _buildDateItem('M', '5'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(String day, String date, {bool isSelected = false}) {
    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? AppColors.primary : Colors.grey[400],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColor.withOpacity(0.8),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Lihat Semua',
            style: TextStyle(fontSize: 13, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
