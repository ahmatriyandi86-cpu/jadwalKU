import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../models/models.dart';
import '../widgets/schedule_card.dart';
import '../widgets/task_card.dart';
import '../providers/schedule_provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<Task> tasks = [
    Task(
      title: 'AI Project',
      category: 'Kecerdasan Buatan',
      deadline: 'Besok',
      time: '23:59 WIB',
      iconType: 'project',
      isCompleted: true, // Example of completed task
    ),
    Task(
      title: 'Laporan Basis Data',
      category: 'Basis Data I',
      deadline: '3 Hari',
      time: '',
      iconType: 'report',
      isCompleted: false,
    ),
  ];

  late DateTime _selectedDate;
  late List<DateTime> _weekDates;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _weekDates = _generateCurrentWeek(_selectedDate);
  }

  List<DateTime> _generateCurrentWeek(DateTime date) {
    // Find the start of the week (Monday)
    int daysFromMonday = date.weekday - 1;
    DateTime monday = date.subtract(Duration(days: daysFromMonday));
    
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context) {
    final completedTasksCount = tasks.where((t) => t.isCompleted).length;
    final totalTasksCount = tasks.length;

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
              children: [
                TextSpan(text: '${_getGreeting()}, Ryandi '),
                const TextSpan(text: '👋', style: TextStyle(fontSize: 24)),
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
          Consumer<ScheduleProvider>(
            builder: (context, scheduleProvider, _) {
              final todaySchedules = scheduleProvider.todaySchedules;
              final scheduleCount = todaySchedules.length;
              
              return Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'TUGAS SELESAI',
                      '$completedTasksCount/$totalTasksCount',
                      AppColors.darkBlueCard,
                      Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'KULIAH HARI INI',
                      '$scheduleCount Sesi',
                      AppColors.lightBlueCard,
                      AppColors.primary,
                    ),
                  ),
                ],
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          // Schedule Section
          _buildSectionHeader('Jadwal Hari Ini'),
          const SizedBox(height: 12),
          Consumer<ScheduleProvider>(
            builder: (context, scheduleProvider, _) {
              final todaySchedules = scheduleProvider.todaySchedules;
              if (todaySchedules.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('Tidak ada jadwal kuliah hari ini'),
                  ),
                );
              }
              return Column(
                children: todaySchedules.map((s) => ScheduleCard(schedule: s)).toList(),
              );
            },
          ),
          
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
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM yyyy').format(_selectedDate),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = _selectedDate.subtract(const Duration(days: 7));
                        _weekDates = _generateCurrentWeek(_selectedDate);
                      });
                    },
                    icon: Icon(Icons.chevron_left, color: AppColors.primary, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = _selectedDate.add(const Duration(days: 7));
                        _weekDates = _generateCurrentWeek(_selectedDate);
                      });
                    },
                    icon: Icon(Icons.chevron_right, color: AppColors.primary, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _weekDates.map((date) {
              final dayName = DateFormat('E').format(date).substring(0, 1).toUpperCase();
              final dayDate = date.day.toString();
              final isToday = date.day == DateTime.now().day && 
                             date.month == DateTime.now().month && 
                             date.year == DateTime.now().year;
              final isSelected = date.day == _selectedDate.day && 
                                date.month == _selectedDate.month && 
                                date.year == _selectedDate.year;

              return _buildDateItem(dayName, dayDate, isSelected: isSelected || isToday);
            }).toList(),
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
              color: textColor.withValues(alpha: 0.8),
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

