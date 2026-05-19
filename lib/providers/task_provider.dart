import 'package:flutter/material.dart';
import '../models/models.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      id: 'task-1',
      title: 'AI Project - Neural Networks',
      category: 'Kecerdasan Buatan',
      description: 'Implementasikan Multi-Layer Perceptron (MLP) untuk klasifikasi gambar dataset MNIST. Tulis laporan komprehensif berisi arsitektur model, grafik learning curve, akurasi pengujian, dan analisis error. Kumpulkan link repository GitHub berisi source code Anda serta laporan dalam format PDF.',
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
      id: 'task-2',
      title: 'Database Schema Design',
      category: 'Basis Data II',
      description: 'Rancang skema database relasional untuk sistem reservasi hotel online. Skema harus memenuhi minimal bentuk normal ketiga (3NF). Gambar ERD lengkap menggunakan notation Crow\'s Foot dan sertakan file DDL SQL (.sql) untuk pembuatan tabel beserta relasi key.',
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
      id: 'task-3',
      title: 'UI Design - High Fidelity',
      category: 'Interaksi Manusia & Komputer',
      description: 'Buatlah rancangan antarmuka aplikasi mobile (high-fidelity prototype) menggunakan Figma dengan tema "Smart Campus App". Desain harus mengikuti panduan Material Design 3, mendukung dark mode, dan memiliki alur prototype interaktif minimal 5 screen utama.',
      deadline: DateTime(2026, 5, 25), // 6 Days from now
      time: '13:00 WIB',
      iconType: 'project',
      tag: 'Biasa',
      borderColor: const Color(0xFF1E3A5F),
      isCompleted: false,
      hasAttachment: false,
      subTasks: [
        SubTask(title: 'Membuat Wireframe Layout', isCompleted: true),
        SubTask(title: 'Menentukan Palette Warna & Tipografi', isCompleted: true),
        SubTask(title: 'Membuat Komponen UI & Prototyping', isCompleted: false),
      ],
    ),
    Task(
      id: 'task-4',
      title: 'Research Paper Review',
      category: 'Metodologi Penelitian',
      description: 'Tulis ulasan kritis (critical review) sebanyak 2-3 halaman mengenai paper penelitian terbaru bertema "AI in Education". Ringkaslah latar belakang masalah, metodologi yang diusulkan, hasil penelitian, serta berikan analisis mengenai kekuatan dan kelemahan paper tersebut.',
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
      attachmentFileName: 'Ryandi_Review_Paper_AI.pdf',
      attachmentUrl: 'https://drive.google.com/file/d/1abc123/view',
      submittedAt: DateTime(2026, 5, 14),
    ),
  ];

  List<Task> get tasks => _tasks;

  List<Task> get sortedTasks {
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

  void toggleSubTask(String taskId, int subTaskIndex, bool value) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      final newSubTasks = List<SubTask>.from(task.subTasks);
      newSubTasks[subTaskIndex] = newSubTasks[subTaskIndex].copyWith(isCompleted: value);

      final allSubTasksCompleted = newSubTasks.isNotEmpty &&
          newSubTasks.every((s) => s.isCompleted);

      _tasks[index] = task.copyWith(
        subTasks: newSubTasks,
        isCompleted: allSubTasksCompleted ? true : task.isCompleted,
        tag: allSubTasksCompleted ? 'Selesai' : (task.tag == 'Selesai' ? 'Biasa' : task.tag),
        borderColor: allSubTasksCompleted ? Colors.grey : _getDefaultBorderColor(task.tag),
      );
      notifyListeners();
    }
  }

  void toggleTaskCompletion(String taskId, bool value) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      final newSubTasks = task.subTasks.map((s) => s.copyWith(isCompleted: value)).toList();
      _tasks[index] = task.copyWith(
        isCompleted: value,
        subTasks: newSubTasks,
        tag: value ? 'Selesai' : (task.tag == 'Selesai' ? 'Biasa' : task.tag),
        borderColor: value ? Colors.grey : _getDefaultBorderColor(task.tag),
      );
      notifyListeners();
    }
  }

  void updateTaskReminder(String taskId, String reminderSetting) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(reminderSetting: reminderSetting);
      notifyListeners();
    }
  }

  void submitTaskAssignment(String taskId, {required String link, required String fileName}) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      final newSubTasks = task.subTasks.map((s) => s.copyWith(isCompleted: true)).toList();
      _tasks[index] = task.copyWith(
        isCompleted: true,
        subTasks: newSubTasks,
        tag: 'Selesai',
        borderColor: Colors.grey,
        attachmentUrl: link.isNotEmpty ? link : null,
        attachmentFileName: fileName.isNotEmpty ? fileName : null,
        submittedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void cancelTaskSubmission(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(
        isCompleted: false,
        tag: 'Biasa',
        borderColor: const Color(0xFF1E3A5F),
        attachmentUrl: null,
        attachmentFileName: null,
        submittedAt: null,
      );
      notifyListeners();
    }
  }

  Color _getDefaultBorderColor(String? tag) {
    if (tag == 'Mendesak') return Colors.red[700]!;
    if (tag == 'Penting') return Colors.brown[700]!;
    return const Color(0xFF1E3A5F);
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }
}
