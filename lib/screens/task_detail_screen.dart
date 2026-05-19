import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/app_utils.dart';
import '../models/models.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _linkController = TextEditingController();
  String _uploadedFileName = '';
  bool _isUploading = false;

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  void _simulateFileUpload() {
    setState(() {
      _isUploading = true;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _isUploading = false;
        _uploadedFileName = 'Tugas_${widget.taskId.replaceAll("-", "_")}_Ryandi.pdf';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Dokumen "$_uploadedFileName" terpilih!'),
            ],
          ),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    });
  }

  void _removeUploadedFile() {
    setState(() {
      _uploadedFileName = '';
    });
  }

  void _handleSubmit(Task task, TaskProvider provider) {
    if (_uploadedFileName.isEmpty && _linkController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Lampiran Kosong ⚠️', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Silakan unggah dokumen tugas atau masukkan link tautan pengumpulan (GitHub/Drive) terlebih dahulu.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      return;
    }

    // Call submit in provider
    provider.submitTaskAssignment(
      task.id,
      link: _linkController.text.trim(),
      fileName: _uploadedFileName,
    );

    // Show beautiful success popup
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.stars, color: Colors.green[700], size: 64),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tugas Dikumpulkan! 🎉',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5F),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Selamat! Tugas "${task.title}" telah berhasil dikumpulkan secara otomatis ke sistem. Progres belajarmu telah diperbarui!',
                style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(ctx); // Close dialog
                    Navigator.pop(context); // Go back to screen list
                  },
                  child: const Text(
                    'Kembali ke Daftar Tugas',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCancelSubmission(Task task, TaskProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Batalkan Pengumpulan? ⚠️', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin membatalkan pengumpulan tugas ini? Status tugas akan kembali aktif.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Kembali', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              provider.cancelTaskSubmission(task.id);
              setState(() {
                _uploadedFileName = '';
                _linkController.clear();
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Pengumpulan tugas berhasil dibatalkan.'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: Text('Ya, Batalkan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[700])),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    // Find task
    final task = taskProvider.tasks.firstWhere(
      (t) => t.id == widget.taskId,
      orElse: () => Task(
        id: '',
        title: 'Tugas Tidak Ditemukan',
        category: '',
        description: '',
        deadline: DateTime.now(),
        time: '',
        iconType: '',
      ),
    );

    if (task.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Tugas')),
        body: const Center(child: Text('Tugas tidak ditemukan.')),
      );
    }

    final relativeDeadline = AppUtils.formatRelativeDeadline(task.deadline);
    final isUrgentDate = relativeDeadline.contains('Besok') || relativeDeadline.contains('Hari Ini');

    // WCAG Contrast Priority Tag Colors
    Color tagBgColor;
    Color tagTextColor;
    if (task.isCompleted) {
      tagBgColor = Colors.grey[100]!;
      tagTextColor = Colors.grey[700]!;
    } else if (task.tag == 'Mendesak') {
      tagBgColor = const Color(0xFFFFE0E0);
      tagTextColor = Colors.red[800]!;
    } else if (task.tag == 'Penting') {
      tagBgColor = const Color(0xFFFFF0D0);
      tagTextColor = Colors.brown[800]!;
    } else {
      tagBgColor = const Color(0xFFE8F0FE);
      tagTextColor = AppColors.primary;
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3A5F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Tugas',
          style: TextStyle(
            color: Color(0xFF1E3A5F),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          task.category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: tagBgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          task.isCompleted ? 'Selesai' : (task.tag ?? 'Biasa'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: tagTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A5F),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: 20, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Deadline:',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${task.deadline.day} Mei 2026, ${task.time}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isUrgentDate ? const Color(0xFFFFE0E0) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          relativeDeadline,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isUrgentDate ? Colors.red[700] : Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Description Card
            const Text(
              'Instruksi Tugas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A5F),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                task.description.isNotEmpty ? task.description : 'Tidak ada instruksi tambahan dari dosen.',
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Color(0xFF334A6F),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sub-tasks Section
            if (task.subTasks.isNotEmpty) ...[
              const Text(
                'Tahapan Sub-Tugas (Micro-tasking)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5F),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: task.subTasks.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 20, endIndent: 20),
                  itemBuilder: (context, index) {
                    final subTask = task.subTasks[index];
                    return CheckboxListTile(
                      activeColor: AppColors.primary,
                      title: Text(
                        subTask.title,
                        style: TextStyle(
                          fontSize: 13,
                          color: subTask.isCompleted ? Colors.grey : const Color(0xFF1E3A5F),
                          decoration: subTask.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      value: subTask.isCompleted,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (val) {
                        taskProvider.toggleSubTask(task.id, index, val ?? false);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Submission Section
            const Text(
              'Pengumpulan Tugas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A5F),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Pengumpulan Bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? Colors.green[50]
                          : const Color(0xFFFFF7E6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: task.isCompleted
                            ? Colors.green[100]!
                            : const Color(0xFFFFE8BE),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          task.isCompleted ? Icons.check_circle : Icons.error,
                          color: task.isCompleted ? Colors.green[700] : Colors.orange[700],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.isCompleted ? 'Sudah Dikumpulkan' : 'Belum Dikumpulkan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: task.isCompleted ? Colors.green[800] : Colors.orange[800],
                                ),
                              ),
                              if (task.isCompleted && task.submittedAt != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Dikirim pada ${task.submittedAt!.day} Mei 2026, pukul ${task.submittedAt!.hour.toString().padLeft(2, '0')}:${task.submittedAt!.minute.toString().padLeft(2, '0')} WIB',
                                  style: TextStyle(fontSize: 11, color: Colors.green[700]),
                                ),
                              ] else ...[
                                const SizedBox(height: 4),
                                const Text(
                                  'Segera selesaikan sebelum batas waktu!',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF8C6D32)),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (!task.isCompleted) ...[
                    // File Upload Picker Box
                    const Text(
                      'Pilih Berkas Lampiran',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _isUploading ? null : _simulateFileUpload,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                        ),
                        child: _isUploading
                            ? const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : _uploadedFileName.isNotEmpty
                                ? Row(
                                    children: [
                                      const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _uploadedFileName,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1E3A5F),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.cancel, color: Colors.grey),
                                        onPressed: _removeUploadedFile,
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud_upload, color: AppColors.primary),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Pilih File Dokumen (PDF/Word)',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Link Input Field
                    const Text(
                      'Link Tautan Pengumpulan',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _linkController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'https://github.com/username/project',
                        prefixIcon: const Icon(Icons.link, size: 20),
                        filled: true,
                        fillColor: Colors.grey[50],
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
                          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.send, color: Colors.white),
                        label: const Text(
                          'Kumpulkan Tugas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => _handleSubmit(task, taskProvider),
                      ),
                    ),
                  ] else ...[
                    // Completed Display details
                    const Text(
                      'Lampiran Terkirim:',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                    ),
                    const SizedBox(height: 10),
                    if (task.attachmentFileName != null) ...[
                      ListTile(
                        leading: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                        title: Text(
                          task.attachmentFileName!,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                        ),
                        subtitle: const Text('Dokumen PDF', style: TextStyle(fontSize: 11)),
                        tileColor: Colors.grey[50],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (task.attachmentUrl != null) ...[
                      ListTile(
                        leading: const Icon(Icons.link, color: Colors.blue, size: 32),
                        title: Text(
                          task.attachmentUrl!,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue, decoration: TextDecoration.underline),
                        ),
                        subtitle: const Text('Tautan Web', style: TextStyle(fontSize: 11)),
                        tileColor: Colors.grey[50],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Cancel Submission Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[700],
                          side: BorderSide(color: Colors.red[200]!, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text(
                          'Batalkan Pengumpulan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => _handleCancelSubmission(task, taskProvider),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
