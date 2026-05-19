import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../models/models.dart';
import '../providers/task_provider.dart';
import '../providers/schedule_provider.dart';
import 'home_tab.dart';
import 'schedule_tab.dart';
import 'tasks_tab.dart';
import 'profile_tab.dart';
import 'task_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    HomeTab(),
    ScheduleTab(),
    const TasksTab(),
    const ProfileTab(),
  ];

  final List<String> _titles = [
    'Beranda',
    'Jadwal',
    'Tugas',
    'Profil',
  ];

  void _showNotificationsBottomSheet(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);

    final urgentTasks = taskProvider.tasks
        .where((t) => !t.isCompleted && t.tag == 'Mendesak')
        .toList();
    final todaySchedules = scheduleProvider.todaySchedules;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.notifications_active, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Pusat Notifikasi 🔔',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A5F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Ringkasan agenda mendesak dan jadwal kuliah hari ini.',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            if (urgentTasks.isEmpty && todaySchedules.isEmpty) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.done_all, color: Colors.green[700], size: 48),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Semua Aman! 🎉',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E3A5F)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tidak ada tugas mendesak atau kelas tersisa hari ini.',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            ] else ...[
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(ctx).size.height * 0.5,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (urgentTasks.isNotEmpty) ...[
                        const Text(
                          'Tugas Mendesak (Tenggat Dekat)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
                        ),
                        const SizedBox(height: 10),
                        ...urgentTasks.map((task) => Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.red[100]!),
                          ),
                          color: const Color(0xFFFFF5F5),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
                              child: const Icon(Icons.assignment_late, color: Colors.red),
                            ),
                            title: Text(
                              task.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E3A5F)),
                            ),
                            subtitle: Text(
                              'Matkul: ${task.category} • Batas: ${task.deadline.day} Mei, ${task.time}',
                              style: TextStyle(fontSize: 11, color: Colors.red[800]),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.red),
                            onTap: () {
                              Navigator.pop(ctx); // Close sheet
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetailScreen(taskId: task.id),
                                ),
                              );
                            },
                          ),
                        )),
                        const SizedBox(height: 16),
                      ],
                      if (todaySchedules.isNotEmpty) ...[
                        const Text(
                          'Jadwal Kuliah Hari Ini',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E3A5F)),
                        ),
                        const SizedBox(height: 10),
                        ...todaySchedules.map((schedule) => Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey[200]!),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: AppColors.lightBlueCard, shape: BoxShape.circle),
                              child: Icon(Icons.class_, color: AppColors.primary),
                            ),
                            title: Text(
                              schedule.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E3A5F)),
                            ),
                            subtitle: Text(
                              'Waktu: ${schedule.time} WIB • Ruang: ${schedule.location}',
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                          ),
                        )),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddScheduleDialog(BuildContext context) {
    final titleController = TextEditingController();
    final lecturerController = TextEditingController();
    final timeController = TextEditingController();
    final locationController = TextEditingController();
    final sksController = TextEditingController(text: '3');
    String selectedDay = 'Senin';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.calendar_month, color: AppColors.primary),
            const SizedBox(width: 10),
            const Text('Tambah Jadwal 📅', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Mata Kuliah', hintText: 'e.g. Pemrograman Mobile'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lecturerController,
                decoration: const InputDecoration(labelText: 'Dosen Pengajar', hintText: 'e.g. Dr. Budi'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedDay,
                decoration: const InputDecoration(labelText: 'Hari'),
                items: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Ahad']
                    .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) selectedDay = val;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Jam Kuliah', hintText: 'e.g. 08.00-09.40'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Ruang / Tautan Kelas', hintText: 'e.g. Lab 1 TI'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: sksController,
                decoration: const InputDecoration(labelText: 'Jumlah SKS'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (titleController.text.trim().isEmpty || timeController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mata Kuliah dan Jam Kuliah harus diisi!')),
                );
                return;
              }
              final schedule = Schedule(
                title: titleController.text.trim(),
                time: timeController.text.trim(),
                location: locationController.text.trim().isNotEmpty ? locationController.text.trim() : 'Kelas Online',
                sks: int.tryParse(sksController.text.trim()) ?? 3,
                day: selectedDay,
                lecturerName: lecturerController.text.trim(),
                borderColor: AppColors.primary,
                locationIcon: Icons.business,
              );
              Provider.of<ScheduleProvider>(context, listen: false).addSchedule(schedule);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Jadwal "${schedule.title}" berhasil ditambahkan!'),
                  backgroundColor: Colors.green[700],
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final categoryController = TextEditingController();
    final descController = TextEditingController();
    final timeController = TextEditingController(text: '23:59 WIB');
    DateTime selectedDate = DateTime.now().add(const Duration(days: 3));
    String selectedTag = 'Biasa';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.assignment, color: AppColors.primary),
              const SizedBox(width: 10),
              const Text('Tambah Tugas 📝', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Judul Tugas', hintText: 'e.g. AI Project'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Kategori / Matkul', hintText: 'e.g. Kecerdasan Buatan'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Deskripsi Tugas'),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tenggat: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setDialogState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      child: const Text('Pilih Tanggal'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Jam Tenggat', hintText: 'e.g. 23:59 WIB'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedTag,
                  decoration: const InputDecoration(labelText: 'Tingkat Prioritas'),
                  items: ['Mendesak', 'Penting', 'Biasa']
                      .map((tag) => DropdownMenuItem(value: tag, child: Text(tag)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() {
                        selectedTag = val;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (titleController.text.trim().isEmpty || categoryController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Judul Tugas dan Kategori harus diisi!')),
                  );
                  return;
                }
                Color borderColor = const Color(0xFF1E3A5F);
                if (selectedTag == 'Mendesak') borderColor = Colors.red[700]!;
                if (selectedTag == 'Penting') borderColor = Colors.brown[700]!;

                final task = Task(
                  id: 'task-${DateTime.now().millisecondsSinceEpoch}',
                  title: titleController.text.trim(),
                  category: categoryController.text.trim(),
                  description: descController.text.trim(),
                  deadline: selectedDate,
                  time: timeController.text.trim(),
                  iconType: 'project',
                  tag: selectedTag,
                  borderColor: borderColor,
                  isCompleted: false,
                  subTasks: [],
                );
                Provider.of<TaskProvider>(context, listen: false).addTask(task);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tugas "${task.title}" berhasil ditambahkan!'),
                    backgroundColor: Colors.green[700],
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickAddOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Tambah Cepat ➕', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              _showAddTaskDialog(context);
            },
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
                  child: const Icon(Icons.assignment, color: Colors.red),
                ),
                const SizedBox(width: 16),
                const Text('Tugas Kuliah Baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              _showAddScheduleDialog(context);
            },
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.lightBlueCard, shape: BoxShape.circle),
                  child: Icon(Icons.calendar_month, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                const Text('Jadwal Kuliah Baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 48,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset(
            'assets/images/uim_logo.png',
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, color: AppColors.primary),
          ),
        ),
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(
            color: _selectedIndex == 1 ? AppColors.primary : AppColors.textPrimary,
            fontWeight: _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        actions: [
          Consumer2<TaskProvider, ScheduleProvider>(
            builder: (context, taskProvider, scheduleProvider, _) {
              final urgentTasksCount = taskProvider.tasks
                  .where((t) => !t.isCompleted && t.tag == 'Mendesak')
                  .length;
              final todaySchedulesCount = scheduleProvider.todaySchedules.length;
              final unreadCount = urgentTasksCount + todaySchedulesCount;

              return Badge(
                label: Text('$unreadCount'),
                isLabelVisible: unreadCount > 0,
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                  onPressed: () => _showNotificationsBottomSheet(context),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: const AssetImage('assets/images/profile_ryandi.jpg'),
              backgroundColor: Colors.grey[200],
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () => _showAddScheduleDialog(context),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Tambah Jadwal',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            )
          : _selectedIndex == 2
              ? FloatingActionButton.extended(
                  onPressed: () => _showAddTaskDialog(context),
                  backgroundColor: AppColors.primary,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Tambah Tugas',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
              : FloatingActionButton(
                  onPressed: () => _showQuickAddOptions(context),
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.add, size: 30, color: Colors.white),
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), activeIcon: Icon(Icons.calendar_month), label: 'Jadwal'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Tugas'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
