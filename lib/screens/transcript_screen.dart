import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_colors.dart';

class TranscriptScreen extends StatefulWidget {
  const TranscriptScreen({super.key});

  @override
  State<TranscriptScreen> createState() => _TranscriptScreenState();
}

class _TranscriptScreenState extends State<TranscriptScreen> {
  int _selectedSemester = 3; // Defaults to Semester 3 (last completed)

  // Mock transcript data grouped by semester
  final Map<int, List<Map<String, dynamic>>> _transcriptData = {
    1: [
      {'code': 'INF-101', 'name': 'Pengantar Teknologi Informasi', 'sks': 3, 'grade': 'A', 'points': 4.0},
      {'code': 'INF-102', 'name': 'Dasar-Dasar Pemrograman', 'sks': 4, 'grade': 'A-', 'points': 3.7},
      {'code': 'INF-103', 'name': 'Matematika Diskrit', 'sks': 3, 'grade': 'B+', 'points': 3.3},
      {'code': 'INF-104', 'name': 'Fisika Dasar', 'sks': 2, 'grade': 'A', 'points': 4.0},
      {'code': 'MKU-101', 'name': 'Pendidikan Agama Islam', 'sks': 2, 'grade': 'A', 'points': 4.0},
      {'code': 'MKU-102', 'name': 'Bahasa Indonesia', 'sks': 2, 'grade': 'B', 'points': 3.0},
      {'code': 'MKU-103', 'name': 'Pancasila', 'sks': 2, 'grade': 'A', 'points': 4.0},
    ],
    2: [
      {'code': 'INF-201', 'name': 'Algoritma & Struktur Data', 'sks': 4, 'grade': 'A', 'points': 4.0},
      {'code': 'INF-202', 'name': 'Sistem Operasi', 'sks': 3, 'grade': 'B+', 'points': 3.3},
      {'code': 'INF-203', 'name': 'Arsitektur Komputer', 'sks': 3, 'grade': 'A', 'points': 4.0},
      {'code': 'INF-204', 'name': 'Aljabar Linear', 'sks': 3, 'grade': 'A-', 'points': 3.7},
      {'code': 'INF-205', 'name': 'Pemrograman Berorientasi Objek', 'sks': 4, 'grade': 'A', 'points': 4.0},
      {'code': 'MKU-201', 'name': 'Kewarganegaraan', 'sks': 2, 'grade': 'A', 'points': 4.0},
    ],
    3: [
      {'code': 'INF-301', 'name': 'Sistem Basis Data', 'sks': 4, 'grade': 'A', 'points': 4.0},
      {'code': 'INF-302', 'name': 'Jaringan Komputer', 'sks': 3, 'grade': 'A', 'points': 4.0},
      {'code': 'INF-303', 'name': 'Rekayasa Perangkat Lunak', 'sks': 3, 'grade': 'A-', 'points': 3.7},
      {'code': 'INF-304', 'name': 'Pemrograman Web', 'sks': 4, 'grade': 'A', 'points': 4.0},
      {'code': 'INF-305', 'name': 'Statistika & Probabilitas', 'sks': 3, 'grade': 'B+', 'points': 3.3},
      {'code': 'INF-306', 'name': 'Interaksi Manusia & Komputer', 'sks': 3, 'grade': 'A', 'points': 4.0},
    ],
    4: [
      {'code': 'INF-401', 'name': 'Pemrograman Mobile (Flutter)', 'sks': 4, 'grade': 'Ongoing', 'points': 0.0},
      {'code': 'INF-402', 'name': 'Kecerdasan Buatan', 'sks': 3, 'grade': 'Ongoing', 'points': 0.0},
      {'code': 'INF-403', 'name': 'Analisis & Desain Sistem', 'sks': 3, 'grade': 'Ongoing', 'points': 0.0},
      {'code': 'INF-404', 'name': 'Keamanan Informasi', 'sks': 3, 'grade': 'Ongoing', 'points': 0.0},
      {'code': 'INF-405', 'name': 'Kewirausahaan Teknologi', 'sks': 2, 'grade': 'Ongoing', 'points': 0.0},
      {'code': 'INF-406', 'name': 'Etika Profesi IT', 'sks': 2, 'grade': 'Ongoing', 'points': 0.0},
    ],
  };

  // IPS (GPA per Semester) mock values
  final Map<int, double> _ipsValues = {
    1: 3.71,
    2: 3.81,
    3: 3.84,
    4: 0.0, // Ongoing
  };

  // Total SKS per semester
  int _getSemesterSks(int sem) {
    return _transcriptData[sem]?.fold<int>(0, (sum, item) => sum + (item['sks'] as int)) ?? 0;
  }

  // Calculate Cumulative GPA (IPK)
  double get _cumulativeGpa {
    double totalPoints = 0.0;
    int totalSks = 0;
    
    // Sum semesters 1, 2, 3 (Semester 4 is ongoing)
    for (int i = 1; i <= 3; i++) {
      final list = _transcriptData[i] ?? [];
      for (final item in list) {
        final sks = item['sks'] as int;
        final pts = item['points'] as double;
        totalPoints += (pts * sks);
        totalSks += sks;
      }
    }
    return totalSks == 0 ? 0.0 : double.parse((totalPoints / totalSks).toStringAsFixed(2));
  }

  // Total SKS accumulated (for semesters 1, 2, 3)
  int get _cumulativeSks {
    int total = 0;
    for (int i = 1; i <= 3; i++) {
      total += _getSemesterSks(i);
    }
    return total;
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
      case 'A-':
        return AppColors.success;
      case 'B+':
      case 'B':
        return AppColors.secondary;
      case 'Ongoing':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCourses = _transcriptData[_selectedSemester] ?? [];
    final currentIps = _ipsValues[_selectedSemester] ?? 0.0;
    final currentSks = _getSemesterSks(_selectedSemester);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transkrip Nilai',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. IPK Summary Card (Blue Dashboard Header)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF003D82)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'IPK KUMULATIF',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_cumulativeGpa',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Skala Maksimal: 4.00',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 60,
                  color: Colors.white24,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TOTAL SKS LULUS',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_cumulativeSks',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Dari 144 SKS Kelulusan',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().scale(duration: 350.ms, curve: Curves.easeOut).fadeIn(),

          // 2. Horizontal Semester Filter
          Container(
            height: 45,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              itemBuilder: (context, index) {
                final semesterNum = index + 1;
                final isSelected = _selectedSemester == semesterNum;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSemester = semesterNum;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.grey[200]!,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Semester $semesterNum',
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ).animate().fadeIn(delay: 150.ms),

          // 3. Semester Stats bar (IP and SKS)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedSemester == 4 ? 'Daftar Kelas Semester Ini' : 'Daftar Nilai Semester $_selectedSemester',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$currentSks SKS',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_selectedSemester != 4)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'IPS: $currentIps',
                          style: const TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms),

          // 4. List of Courses
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: ListView.builder(
                key: ValueKey<int>(_selectedSemester),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: currentCourses.length,
                itemBuilder: (context, index) {
                  final course = currentCourses[index];
                  final name = course['name'] as String;
                  final code = course['code'] as String;
                  final sks = course['sks'] as int;
                  final grade = course['grade'] as String;
                  final isOngoing = grade == 'Ongoing';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.015),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Grade Badge / Status
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _getGradeColor(grade).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: isOngoing
                                ? Icon(Icons.sync, color: _getGradeColor(grade), size: 22)
                                : Text(
                                    grade,
                                    style: TextStyle(
                                      color: _getGradeColor(grade),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Course Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    code,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '$sks SKS',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .slideX(begin: 0.05, end: 0, delay: (index * 50).ms, duration: 300.ms)
                  .fadeIn(delay: (index * 50).ms);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
