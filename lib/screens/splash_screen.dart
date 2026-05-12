import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            // Logo Container
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                size: 64,
                color: AppColors.primary,
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack).fadeIn(),
            
            const SizedBox(height: 24),
            
            Text(
              'JadwalKu App',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ).animate().slideY(begin: 0.2, end: 0, duration: 500.ms).fadeIn(),
            
            const SizedBox(height: 8),
            
            Text(
              'Manajemen Akademik Terpadu',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                letterSpacing: 0.5,
              ),
            ).animate().slideY(begin: 0.2, end: 0, delay: 200.ms, duration: 500.ms).fadeIn(),
            
            const Spacer(flex: 2),
            
            // Loading Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      backgroundColor: Color(0xFFE8F0FE),
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'MEMUAT DATA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms),
            
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
