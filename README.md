# jadwalku
Blueprint Aplikasi
Aplikasi Jadwal Kuliah & Tugas
1. Deskripsi Aplikasi
Aplikasi ini digunakan untuk membantu mahasiswa mengatur:
● Jadwal kuliah
● Tugas
● Deadline
● Reminder kegiatan kampus
Tujuan:
Agar mahasiswa lebih teratur dan tidak lupa jadwal maupun tugas.
2. Target Pengguna
● Mahasiswa
● Pelajar
● Organisasi kampus
3. Fitur Utama
A. Login & Register
Fungsi:
● Masuk akun
● Simpan data pengguna
Fitur:
● Login Email
● Register
● Logout
B. Dashboard
Menampilkan:
● Jadwal hari ini
● Jumlah tugas
● Deadline terdekat
● Kalender mini
C. Jadwal Kuliah
Fitur:
● Tambah mata kuliah
● Hari & jam
● Nama dosen
● Ruangan
● Warna tiap mata kuliah
Contoh:
Mata Kuliah
Hari
Jam
Struktur Data Senin 08:00
Basis Data
Selas
a
10:00
D. Tugas Kuliah
Fitur:
● Tambah tugas
● Deadline
● Status selesai/belum
● Prioritas tugas
Kategori:
● Penting
● Biasa
● Mendesak
E. Notifikasi Reminder
Fungsi:
● Mengingatkan jadwal
● Mengingatkan deadline
Contoh:
“Besok ada deadline tugas Basis Data”
F. Kalender Akademik
Fitur:
● Melihat semua jadwal
● Deadline bulanan
● Event kampus
4. Struktur Halaman Aplikasi
Splash Screen
↓
Login/Register
↓
Dashboard
├── Jadwal Ku
├── Tugas
├── Kalender
├── Notifikasi
└── Profile
5. Blueprint UI Tampilan
A. Splash Screen
+----------------------+
| |
| LOGO APP |
| |
| JadwalKu App |
| |
+----------------------+
B. Login Page
+----------------------+
| LOGIN |
| |
| Email |
| [______________] |
| |
| Password |
| [______________] |
| |
| [ Login ] |
| |
| Register Account |
+----------------------+
C. Dashboard
+----------------------+
| Halo, Ferdiansyah 👋 |
| |
| Jadwal Hari Ini |
| ------------------ |
| Struktur Data |
| 08:00 - 10:00 |
| |
| Deadline Tugas |
| ------------------ |
| AI Project |
| Besok |
| |
| [Tambah Jadwal] |
+----------------------+
D. Halaman Jadwal
+----------------------+
| Jadwal Kuliah |
| |
| Senin |
| - Struktur Data |
| - Pemrograman Mobile |
| |
| Selasa |
| - Basis Data |
| |
| [+ Tambah] |
+----------------------+
E. Halaman Tugas
+----------------------+
| Tugas Kuliah |
| |
| [ ] AI Project |
| Deadline: 20 Mei |
| |
| [✓] UI Design |
| Selesai |
| |
| [+ Tambah Tugas] |
+----------------------+
6. Flowchart Sistem
Mulai
↓
Login/Register
↓
Masuk Dashboard
↓
Pilih Menu
├── Jadwal
├── Tugas
├── Kalender
└── Profile
↓
Simpan Data
↓
Notifikasi Reminder
↓
Selesai
7. Database Sederhana
Tabel User
Field
Type
id
int
nama
varchar
email
varchar
passwor
d
varchar
Tabel Jadwal
Field
Type
id
int
matkul
varchar
hari
varchar
jam
varchar
ruanga
n
varchar
Tabel Tugas
Field
Type
id
int
judul
varchar
deadlin
e
date
status
varchar
8. Teknologi yang Digunakan
Frontend
● Flutter
Backend
● Firebase / SQLite
Database
● Firestore / SQLite
Notifikasi
● Flutter Local Notification
9. Warna UI yang Disarankan
Bagian
Warna
Primary
Biru
Background Putih
Card
Abu muda
Button
Biru tua
10. Struktur Folder Flutter
lib/
├── main.dart
├── screens/
│ ├── login.dart
│ ├── dashboard.dart
│ ├── jadwal.dart
│ ├── tugas.dart
│ └── profile.dart
│
├── models/
├── services/
├── widgets/
└── database/
