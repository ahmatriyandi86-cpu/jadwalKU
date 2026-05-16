import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'home_tab.dart';
import 'schedule_tab.dart';
import 'tasks_tab.dart';
import 'profile_tab.dart';

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
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=ferdiansyah'),
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
              onPressed: () {},
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Tambah Jadwal',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            )
          : _selectedIndex == 2
              ? FloatingActionButton.extended(
                  onPressed: () {},
                  backgroundColor: AppColors.primary,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Tambah Tugas',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
              : FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.add, size: 30, color: Colors.white),
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed, // Added to ensure all items are visible properly
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
