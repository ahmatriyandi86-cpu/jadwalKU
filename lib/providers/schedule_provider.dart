import 'package:flutter/material.dart';
import '../models/models.dart';
import '../core/app_colors.dart';

class ScheduleProvider extends ChangeNotifier {
  final Map<String, List<Schedule>> _allSchedules = {
    'Senin': [
      Schedule(
        title: 'algoritma analisa.',
        time: '07.30-09.10',
        location: 'Lab 2 TI',
        sks: 2,
        day: 'Senin',
        borderColor: AppColors.primary,
        locationIcon: Icons.business,
      ),
    ],
    'Selasa': [
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
    ],
    'Rabu': [
      Schedule(
        title: 'Lanjut Data Dasar Pemrograman.',
        time: '09.10-10.50',
        location: 'Lab 2 TI',
        sks: 3,
        day: 'Rabu',
        borderColor: AppColors.primary,
        locationIcon: Icons.business,
      ),
    ],
    'Kamis': [],
    'Jumat': [
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
    ],
    'Sabtu': [],
    'Ahad': [
      Schedule(
        title: 'Riset Operasi.',
        time: '07.30-09.10',
        location: 'Lab 1 TI',
        sks: 3,
        day: 'Ahad',
        borderColor: AppColors.primary,
        locationIcon: Icons.business,
      ),
    ],
  };

  Map<String, List<Schedule>> get allSchedules => _allSchedules;

  List<Schedule> get todaySchedules {
    int weekday = DateTime.now().weekday;
    String dayName = getDayName(weekday);
    return _allSchedules[dayName] ?? [];
  }

  String getDayName(int weekday) {
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
}
