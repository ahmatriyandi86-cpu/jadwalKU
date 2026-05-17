import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'student_data_screen.dart';
import 'transcript_screen.dart';
import 'ukt_payment_screen.dart';
import 'account_settings_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Header
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: const AssetImage('assets/images/profile_ryandi.jpg'),
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      auth.userName ?? 'Mahasiswa',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      auth.userEmail ?? 'NIM: 20241220115',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          // University Identity Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/uim_logo.png',
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.school,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Universitas Islam Madura',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Fakultas Teknik',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Program Studi Informatika',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Menu Items
          _buildMenuItem(Icons.person_outline, 'Data Mahasiswa', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StudentDataScreen()),
            );
          }),
          _buildMenuItem(Icons.book_outlined, 'Transkrip Nilai', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TranscriptScreen()),
            );
          }),
          _buildMenuItem(Icons.payment_outlined, 'Pembayaran UKT', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UktPaymentScreen()),
            );
          }),
          _buildMenuItem(Icons.settings_outlined, 'Pengaturan Akun', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
            );
          }),
          
          const SizedBox(height: 20),
          
          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.red,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Keluar Aplikasi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
    );
  }
}
