import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/models.dart';
import '../widgets/task_list_item.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  final List<Task> _tasks = [
    Task(
      title: 'AI Project - Neural Networks',
      category: 'Kecerdasan Buatan',
      deadline: '20 Mei',
      time: '',
      iconType: 'project',
      tag: 'Mendesak',
      borderColor: Colors.red[700],
      isCompleted: false,
    ),
    Task(
      title: 'Database Schema Design',
      category: 'Basis Data II',
      deadline: '22 Mei',
      time: '',
      iconType: 'project',
      tag: 'Penting',
      borderColor: Colors.brown[700],
      isCompleted: false,
    ),
    Task(
      title: 'UI Design - High Fidelity',
      category: 'Interaksi Manusia & Komputer',
      deadline: '25 Mei',
      time: '',
      iconType: 'project',
      tag: 'Biasa',
      borderColor: AppColors.primary,
      isCompleted: false,
    ),
    Task(
      title: 'Research Paper Review',
      category: '',
      deadline: '15 Mei',
      time: '',
      iconType: 'report',
      tag: 'Selesai',
      borderColor: Colors.grey,
      isCompleted: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PROGRES MINGGU INI',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.8),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '85%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.show_chart, color: Colors.white, size: 28),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Tugas Aktif', '12'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Selesai', '24'),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Header Daftar Tugas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daftar Tugas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_list, size: 18, color: AppColors.primary),
                label: const Text(
                  'Filter',
                  style: TextStyle(fontSize: 13, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // List Tugas
          ..._tasks.map((task) => TaskListItem(
                task: task,
                onChanged: (val) {
                  setState(() {
                    // This is just a dummy logic to demonstrate toggle
                    int index = _tasks.indexOf(task);
                    _tasks[index] = Task(
                      title: task.title,
                      category: task.category,
                      deadline: task.deadline,
                      time: task.time,
                      iconType: task.iconType,
                      tag: val == true ? 'Selesai' : task.tag,
                      borderColor: val == true ? Colors.grey : task.borderColor,
                      isCompleted: val ?? false,
                    );
                  });
                },
              )),
              
          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
