import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_colors.dart';
import '../providers/auth_provider.dart';

class StudentDataScreen extends StatelessWidget {
  const StudentDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

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
          'Data Mahasiswa',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. KTM Digital Card (Premium Design)
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF003D82)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background decorative pattern circles
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    
                    // Card Content
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Header: Logo and University Name
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/uim_logo.png',
                                width: 35,
                                height: 35,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.school, color: Colors.white, size: 30),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'UNIVERSITAS ISLAM MADURA',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    Text(
                                      'KTM Digital Mahasiswa',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.2),
                                  border: Border.all(color: Colors.green, width: 0.8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'AKTIF',
                                  style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Middle: Name, NIM, and Photo
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      auth.userName ?? 'Mahasiswa UIM',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'NIM: 20241220115',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontFamily: 'monospace',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Teknik / Informatika',
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Profile Photo
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const CircleAvatar(
                                  radius: 36,
                                  backgroundImage: AssetImage('assets/images/profile_ryandi.jpg'),
                                  backgroundColor: Colors.white24,
                                ),
                              ),
                            ],
                          ),
                          
                          // Footer: QR Code Mock or ID number
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Fakultas Teknik UIM',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'JadwalKu • Integrated System',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).fadeIn(),

              const SizedBox(height: 30),

              // 2. Section Title
              const Text(
                'Detail Informasi Akademik',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(delay: 150.ms),

              const SizedBox(height: 16),

              // 3. Information Cards
              Column(
                children: [
                  _buildDetailTile(Icons.assignment_ind_outlined, 'Nama Lengkap', auth.userName ?? 'Mahasiswa UIM'),
                  _buildDetailTile(Icons.credit_card_outlined, 'Nomor Induk Mahasiswa', '20241220115'),
                  _buildDetailTile(Icons.school_outlined, 'Fakultas / Program Studi', 'Fakultas Teknik / Informatika'),
                  _buildDetailTile(Icons.calendar_today_outlined, 'Tahun Angkatan', '2024 / Genap'),
                  _buildDetailTile(Icons.star_outline, 'Semester Aktif', 'Semester 4'),
                  _buildDetailTile(Icons.person_pin_outlined, 'Dosen Wali', 'Ahmad Triyandi, M.T.'),
                  _buildDetailTile(Icons.email_outlined, 'Email Institusi', auth.userEmail ?? 'Ryandi06@gmail.com'),
                ],
              ).animate().slideY(begin: 0.1, end: 0, delay: 200.ms, duration: 400.ms).fadeIn(),

              const SizedBox(height: 24),

              // 4. Barcode Decorative Card
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_2, color: AppColors.primary, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Presensi Digital UIM',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Simulated Barcode
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(40, (index) {
                        final widths = [1.0, 2.0, 3.0, 4.0];
                        final gaps = [1.0, 2.0, 3.0];
                        final width = widths[index % widths.length];
                        final gap = gaps[index % gaps.length];
                        return Container(
                          width: width,
                          height: 40,
                          margin: EdgeInsets.only(right: gap),
                          color: AppColors.textPrimary.withValues(alpha: 0.8),
                        );
                      }),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '* 20241220115 *',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 350.ms),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
