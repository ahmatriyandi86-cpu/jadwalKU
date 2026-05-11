import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const JadwalKuApp());
}

class JadwalKuApp extends StatelessWidget {
  const JadwalKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JadwalKu App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
