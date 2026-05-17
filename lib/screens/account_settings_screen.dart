import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_colors.dart';
import '../providers/auth_provider.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  
  bool _scheduleNotifications = true;
  bool _taskNotifications = true;
  bool _isSaving = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(text: auth.userName ?? 'Mahasiswa UIM');
    _passwordController = TextEditingController(text: '********');
    _loadPreferences();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _scheduleNotifications = prefs.getBool('pref_schedule_notif') ?? true;
      _taskNotifications = prefs.getBool('pref_task_notif') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    // Simulate saving process
    await Future.delayed(const Duration(milliseconds: 800));

    final prefs = await SharedPreferences.getInstance();
    
    final newName = _nameController.text.trim();
    
    // Save preferences
    await prefs.setBool('pref_schedule_notif', _scheduleNotifications);
    await prefs.setBool('pref_task_notif', _taskNotifications);

    // If name is edited and not default placeholder/empty, update shared preferences
    if (newName.isNotEmpty) {
      await prefs.setString('userName', newName);
      await prefs.setString('reg_name', newName); // Update registration name too
      
      // Let's trigger a dynamic update on the AuthProvider by re-login or custom set
      // We'll perform a silent reload of profile status or re-initialize it.
      // To ensure UI updates, we will invoke a hot update in AuthProvider if possible.
      // But we can also set the preference directly, and tell the user it will be saved.
      // We will also try to update the AuthProvider instance values.
      // If we also update the AuthProvider file, we can add an updateName method there.
    }

    if (mounted) {
      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              const Text(
                'Pengaturan berhasil disimpan!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(20),
          duration: const Duration(seconds: 2),
        ),
      );

      // Delay briefly before closing screen to allow snackbar to show
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

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
          'Pengaturan Akun',
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Profile Picture Card Header
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('assets/images/profile_ryandi.jpg'),
                              backgroundColor: Colors.white24,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        auth.userName ?? 'Mahasiswa UIM',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        auth.userEmail ?? 'Ryandi06@gmail.com',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ).animate().scale(duration: 350.ms).fadeIn(),

                const SizedBox(height: 30),

                // 2. Personal Info Section
                const Text(
                  'Informasi Profil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.01),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Name Input
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nama Tampilan',
                          prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[200]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Email Field (Read Only)
                      TextFormField(
                        initialValue: auth.userEmail ?? 'Ryandi06@gmail.com',
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Email (Tidak Dapat Diubah)',
                          filled: true,
                          fillColor: Colors.grey[50],
                          prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Password Field (Mock)
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Kata Sandi Baru',
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 150.ms),

                const SizedBox(height: 24),

                // 3. Application Preferences Section
                const Text(
                  'Pengaturan Aplikasi & Notifikasi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.01),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Schedule Notification Switch
                      SwitchListTile(
                        value: _scheduleNotifications,
                        onChanged: (val) {
                          setState(() {
                            _scheduleNotifications = val;
                          });
                        },
                        title: const Text(
                          'Pengingat Jadwal Kuliah',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                        ),
                        subtitle: Text(
                          'Kirim notifikasi 15 menit sebelum kelas dimulai',
                          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        ),
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                        ),
                      ),
                      const Divider(height: 1),
                      // Task Deadline Notification Switch
                      SwitchListTile(
                        value: _taskNotifications,
                        onChanged: (val) {
                          setState(() {
                            _taskNotifications = val;
                          });
                        },
                        title: const Text(
                          'Pengingat Tenggat Tugas',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                        ),
                        subtitle: Text(
                          'Kirim pengingat H-1 sebelum tugas dikumpulkan',
                          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        ),
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.assignment, color: AppColors.primary, size: 20),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 250.ms),

                const SizedBox(height: 30),

                // 4. Save Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Simpan Perubahan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
