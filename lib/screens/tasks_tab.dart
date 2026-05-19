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
      deadline: DateTime(2026, 5, 20), // Tomorrow
      time: '23:59 WIB',
      iconType: 'project',
      tag: 'Mendesak',
      borderColor: Colors.red[700],
      isCompleted: false,
      hasAttachment: true,
      subTasks: [
        SubTask(title: 'Cari Dataset & Data Cleaning', isCompleted: true),
        SubTask(title: 'Preprocessing Data & Model Architecture Design', isCompleted: false),
        SubTask(title: 'Melatih Model Neural Networks', isCompleted: false),
        SubTask(title: 'Susun Laporan & Evaluasi Model', isCompleted: false),
      ],
    ),
    Task(
      title: 'Database Schema Design',
      category: 'Basis Data II',
      deadline: DateTime(2026, 5, 22), // 3 Days from now
      time: '18:00 WIB',
      iconType: 'project',
      tag: 'Penting',
      borderColor: Colors.brown[700],
      isCompleted: false,
      hasAttachment: true,
      subTasks: [
        SubTask(title: 'Analisis Entitas & Hubungan', isCompleted: true),
        SubTask(title: 'Normalisasi 1NF ke 3NF', isCompleted: false),
        SubTask(title: 'Menggambar Entity Relationship Diagram (ERD)', isCompleted: false),
      ],
    ),
    Task(
      title: 'UI Design - High Fidelity',
      category: 'Interaksi Manusia & Komputer',
      deadline: DateTime(2026, 5, 25), // 6 Days from now
      time: '13:00 WIB',
      iconType: 'project',
      tag: 'Biasa',
      borderColor: AppColors.primary,
      isCompleted: false,
      hasAttachment: false,
      subTasks: [
        SubTask(title: 'Membuat Wireframe Layout', isCompleted: true),
        SubTask(title: 'Menentukan Palette Warna & Tipografi', isCompleted: true),
        SubTask(title: 'Membuat Komponen UI & Prototyping', isCompleted: false),
      ],
    ),
    Task(
      title: 'Research Paper Review',
      category: 'Metodologi Penelitian',
      deadline: DateTime(2026, 5, 15), // Past
      time: '10:00 WIB',
      iconType: 'report',
      tag: 'Selesai',
      borderColor: Colors.grey,
      isCompleted: true,
      hasAttachment: true,
      subTasks: [
        SubTask(title: 'Membaca Paper Utama', isCompleted: true),
        SubTask(title: 'Merangkum Kontribusi Paper', isCompleted: true),
        SubTask(title: 'Menyusun Laporan Ulasan Kritis', isCompleted: true),
      ],
    ),
  ];

  List<Task> get _sortedTasks {
    final sorted = List<Task>.from(_tasks);
    sorted.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      int getWeight(String? tag) {
        if (tag == 'Mendesak') return 3;
        if (tag == 'Penting') return 2;
        if (tag == 'Biasa') return 1;
        return 0;
      }
      int weightA = getWeight(a.tag);
      int weightB = getWeight(b.tag);
      if (weightA != weightB) {
        return weightB.compareTo(weightA);
      }
      return a.deadline.compareTo(b.deadline);
    });
    return sorted;
  }

  void _showStatsBottomSheet(int completed, int total, int percentage) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final remaining = total - completed;
        String motivationalMsg = '';
        if (percentage == 100) {
          motivationalMsg = 'Luar biasa! Semua tugas minggu ini telah diselesaikan dengan sempurna! Pertahankan performa luar biasa ini! 🏆✨';
        } else if (percentage >= 70) {
          motivationalMsg = 'Kerja bagus! Kamu sudah menyelesaikan sebagian besar tugas. Tinggal sedikit lagi untuk mencapai 100%! Terus melangkah! 💪🚀';
        } else if (percentage >= 40) {
          motivationalMsg = 'Bagus! Progresmu terus bertumbuh. Luangkan sedikit waktu lagi untuk menyelesaikan sisanya. Kamu pasti bisa! 🎯';
        } else {
          motivationalMsg = 'Ayo mulai ambil langkah pertamamu hari ini! Selesaikan sub-tugas kecil untuk membangun momentum belajarmu! ⏳🌟';
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Analisis Progres Belajar 📊',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5F),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: CircularProgressIndicator(
                          value: percentage / 100,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatRow(Icons.check_circle, 'Selesai', '$completed Tugas', Colors.green[700]!),
                      const SizedBox(height: 12),
                      _buildStatRow(Icons.pending_actions, 'Aktif', '$remaining Tugas', AppColors.primary),
                      const SizedBox(height: 12),
                      _buildStatRow(Icons.assignment, 'Total', '$total Tugas', Colors.grey[600]!),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                ),
                child: Text(
                  motivationalMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalTasks = _tasks.length;
    final completedTasks = _tasks.where((t) => t.isCompleted).length;
    final remainingTasks = totalTasks - completedTasks;
    final percentage = totalTasks > 0 ? (completedTasks / totalTasks * 100).round() : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Card (Clickable)
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _showStatsBottomSheet(completedTasks, totalTasks, percentage),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
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
                        Text(
                          '$percentage%',
                          style: const TextStyle(
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
            ),
          ),
          const SizedBox(height: 20),
          
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Tugas Aktif', '$remainingTasks'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Selesai', '$completedTasks'),
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
          
          // List Tugas (Sorted automatically)
          ..._sortedTasks.map((task) {
            return TaskListItem(
              task: task,
              onChanged: (val) {
                setState(() {
                  int index = _tasks.indexOf(task);
                  final isDone = val == true;
                  final newSubTasks = task.subTasks.map((s) => s.copyWith(isCompleted: isDone)).toList();
                  _tasks[index] = task.copyWith(
                    isCompleted: isDone,
                    tag: isDone ? 'Selesai' : (task.tag == 'Selesai' ? 'Biasa' : task.tag),
                    borderColor: isDone ? Colors.grey : (task.tag == 'Mendesak' ? Colors.red[700] : (task.tag == 'Penting' ? Colors.brown[700] : AppColors.primary)),
                    subTasks: newSubTasks,
                  );
                });
              },
              onTaskChanged: (updatedTask) {
                setState(() {
                  int index = _tasks.indexOf(task);
                  final allSubTasksCompleted = updatedTask.subTasks.isNotEmpty &&
                      updatedTask.subTasks.every((s) => s.isCompleted);
                  
                  _tasks[index] = updatedTask.copyWith(
                    isCompleted: allSubTasksCompleted ? true : updatedTask.isCompleted,
                    tag: allSubTasksCompleted ? 'Selesai' : (updatedTask.tag == 'Selesai' ? 'Biasa' : updatedTask.tag),
                    borderColor: allSubTasksCompleted ? Colors.grey : (updatedTask.tag == 'Mendesak' ? Colors.red[700] : (updatedTask.tag == 'Penting' ? Colors.brown[700] : AppColors.primary)),
                  );
                });
              },
            );
          }),
              
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
