# Frenooze — Architecture Document

**Nama Proyek:** Frenooze  
**Jenis Aplikasi:** Aplikasi pencatatan dan pengelolaan tidur  
**Platform:** Android  
**Kerangka Kerja:** Flutter  
**Bahasa Utama:** Dart  
**Bahasa Integrasi Android:** Kotlin  
**Arsitektur:** Feature-First + Clean Architecture  
**Pengelolaan State:** BLoC  
**Basis Data:** SQLite + Drift  
**Status:** Perencanaan Arsitektur  
**Versi Dokumen:** 1.0.0

---

## 1. Pendahuluan

### 1.1. Tujuan Dokumen

Dokumen ini menjelaskan rancangan teknis dan struktur internal aplikasi Frenooze sebagai pedoman utama selama proses pengembangan.

Dokumen mencakup:

- Arsitektur aplikasi Flutter.
- Pembagian modul dan tanggung jawab setiap lapisan.
- Struktur direktori proyek.
- Pengelolaan state menggunakan BLoC.
- Pengelolaan basis data lokal.
- Sistem pencatatan waktu dan zona waktu.
- Integrasi Flutter dengan Android menggunakan Kotlin.
- Sistem getaran dan Wake-up Mode.
- Pengelolaan siklus hidup aplikasi.
- Penanganan proses latar belakang Android.
- Sistem ekspor dan impor data.
- Strategi pengujian dan pemeliharaan.

Implementasi harus mengikuti prinsip pemisahan tanggung jawab agar perubahan pada satu fitur tidak menyebabkan regresi pada fitur lainnya.

### 1.2. Prinsip Arsitektur

Frenooze menggunakan prinsip berikut:

1. **Feature-First:** Kode dikelompokkan berdasarkan fitur, bukan hanya berdasarkan jenis berkas.
2. **Separation of Concerns:** Setiap lapisan memiliki tanggung jawab yang jelas.
3. **Offline-First:** Basis data lokal menjadi sumber utama seluruh informasi aplikasi.
4. **Event-Driven:** Sistem bekerja berdasarkan kejadian, bukan proses yang terus berjalan.
5. **Battery Efficient:** Menghindari proses latar belakang yang tidak diperlukan.
6. **Platform-Aware:** Fungsi khusus Android diimplementasikan menggunakan Kotlin.
7. **Data Integrity:** Operasi pencatatan dan perubahan data harus konsisten.
8. **Maintainability:** Struktur kode harus mudah dipahami, diuji, dan dikembangkan.

---

## 2. Gambaran Arsitektur

Frenooze menggunakan arsitektur Feature-First yang dipadukan dengan Clean Architecture.

Pembagian utama terdiri dari tiga lapisan:

### 2.1. Presentation Layer

Bertanggung jawab terhadap seluruh tampilan dan interaksi pengguna.

Komponen:

- Halaman aplikasi.
- Widget.
- BLoC.
- Event.
- State.
- Komponen navigasi.

Presentation Layer tidak boleh berkomunikasi langsung dengan basis data.

### 2.2. Domain Layer

Berisi aturan bisnis utama aplikasi.

Komponen:

- Entity.
- Repository Contract.
- Use Case.
- Aturan validasi.
- Perhitungan durasi tidur.
- Pengelolaan status sesi.
- Aturan zona waktu.

Domain Layer tidak bergantung pada Flutter, SQLite, atau API Android.

### 2.3. Data Layer

Bertanggung jawab terhadap penyimpanan dan pengambilan data.

Komponen:

- Repository Implementation.
- Data Source.
- Database.
- Model.
- Mapper.
- Pengelolaan ekspor dan impor.

Data Layer menjadi penghubung antara Domain Layer dengan sumber penyimpanan.

### 2.4. Platform Layer

Platform Layer merupakan bagian khusus untuk komunikasi dengan sistem Android.

Komponen:

- Kotlin.
- Platform Channel.
- Pengelolaan getaran.
- Pengelolaan layar.
- Informasi waktu perangkat.
- Pengelolaan siklus hidup aplikasi.
- Integrasi notifikasi jika diperlukan.

Platform Layer tidak boleh mengambil alih aturan bisnis utama aplikasi.

---

## 3. Diagram Arsitektur

```text
                    F R E N O O Z E
                           |
                           v
                 PRESENTATION LAYER
             +-------------------------+
             | Dashboard               |
             | Sleep Session UI        |
             | Wake-up Mode UI         |
             | Sleep History UI        |
             | Statistics UI           |
             | Settings UI             |
             +-------------------------+
                           |
                           v
                     BLoC LAYER
             +-------------------------+
             | SleepSessionBloc        |
             | WakeUpBloc              |
             | HistoryBloc             |
             | StatisticsBloc          |
             | SettingsBloc            |
             +-------------------------+
                           |
                           v
                     DOMAIN LAYER
             +-------------------------+
             | Entities                |
             | Repository Contracts   |
             | Use Cases               |
             | Business Rules          |
             | Time Management         |
             +-------------------------+
                      /        \
                     /          \
                    v            v
             DATA LAYER      PLATFORM LAYER
          +-------------+   +----------------+
          | Repositories|   | Platform API   |
          | Data Source |   | Kotlin         |
          | Drift       |   | Vibration      |
          | SQLite      |   | Screen Control |
          +-------------+   | Lifecycle      |
                            +----------------+
```

Komunikasi antarbagian harus mengikuti arah ketergantungan.

Presentation bergantung pada Domain. Data dan Platform mengimplementasikan kebutuhan yang didefinisikan oleh Domain.

Domain tidak boleh mengetahui detail implementasi SQLite maupun Android.

---

## 4. Struktur Direktori Proyek

Struktur proyek dirancang menggunakan pemisahan berdasarkan fitur.

```text
frenooze/
|
|-- android/
|   |-- app/
|   |   |-- src/
|   |   |   |-- main/
|   |   |   |   |-- kotlin/
|   |   |   |   |   |-- com/
|   |   |   |   |   |   |-- frenooze/
|   |   |   |   |   |   |   |-- MainActivity.kt
|   |   |   |   |   |   |   |-- platform/
|   |   |   |   |   |   |   |   |-- VibrationHandler.kt
|   |   |   |   |   |   |   |   |-- ScreenHandler.kt
|   |   |   |   |   |   |   |   |-- TimezoneHandler.kt
|   |   |   |   |   |   |   |   |-- LifecycleHandler.kt
|   |   |   |   |   |   |   |   |-- NotificationHandler.kt
|   |   |   |   |   |   |   |
|   |   |   |   |   |   |   |-- service/
|   |   |   |   |   |   |   |   |-- WakeUpService.kt
|   |   |   |   |
|   |   |   |   |-- AndroidManifest.xml
|   |   |
|   |-- build.gradle.kts
|
|-- lib/
|   |
|   |-- main.dart
|   |-- app.dart
|   |
|   |-- core/
|   |   |
|   |   |-- constants/
|   |   |-- errors/
|   |   |-- extensions/
|   |   |-- utils/
|   |   |-- time/
|   |   |   |-- clock_provider.dart
|   |   |   |-- timezone_service.dart
|   |   |   |-- timestamp_converter.dart
|   |   |
|   |   |-- database/
|   |   |   |-- app_database.dart
|   |   |   |-- database_connection.dart
|   |   |   |-- tables/
|   |   |   |-- migrations/
|   |   |
|   |   |-- platform/
|   |   |   |-- android_bridge.dart
|   |   |   |-- android_platform_api.dart
|   |   |
|   |   |-- theme/
|   |   |-- routing/
|   |   |-- widgets/
|   |
|   |-- features/
|   |   |
|   |   |-- dashboard/
|   |   |   |-- presentation/
|   |   |   |   |-- pages/
|   |   |   |   |-- widgets/
|   |   |   |   |-- bloc/
|   |   |
|   |   |-- sleep_session/
|   |   |   |-- domain/
|   |   |   |   |-- entities/
|   |   |   |   |-- repositories/
|   |   |   |   |-- usecases/
|   |   |   |
|   |   |   |-- data/
|   |   |   |   |-- models/
|   |   |   |   |-- repositories/
|   |   |   |   |-- datasources/
|   |   |   |
|   |   |   |-- presentation/
|   |   |       |-- pages/
|   |   |       |-- widgets/
|   |   |       |-- bloc/
|   |   |
|   |   |-- wake_up/
|   |   |   |-- domain/
|   |   |   |-- data/
|   |   |   |-- presentation/
|   |   |
|   |   |-- sleep_history/
|   |   |   |-- domain/
|   |   |   |-- data/
|   |   |   |-- presentation/
|   |   |
|   |   |-- statistics/
|   |   |   |-- domain/
|   |   |   |-- data/
|   |   |   |-- presentation/
|   |   |
|   |   |-- data_management/
|   |   |   |-- domain/
|   |   |   |-- data/
|   |   |   |-- presentation/
|   |   |
|   |   |-- settings/
|   |       |-- domain/
|   |       |-- data/
|   |       |-- presentation/
|   |
|   |-- shared/
|   |   |-- models/
|   |   |-- enums/
|   |   |-- widgets/
|   |
|   |-- generated/
|
|-- doksli/
|   |-- images/
|   |-- icons/
|   |-- fonts/
|
|-- test/
|   |-- unit/
|   |-- widget/
|   |-- integration/
|   |-- fixtures/
|
|-- integration_test/
|
|-- docs/
|   |-- PRD.md
|   |-- ARCHITECTURE.md
|   |-- DESIGN.md
|
|-- pubspec.yaml
|-- analysis_options.yaml
|-- .gitignore
|-- README.md
```

Struktur tersebut merupakan rancangan direktori target. Direktori atau berkas hanya dibuat ketika diperlukan oleh implementasi.

### 4.1. Tanggung Jawab Direktori Utama

**core/**

Berisi infrastruktur yang digunakan lintas fitur, seperti database, pengelolaan waktu, platform bridge, tema, dan navigasi.

**features/**

Berisi seluruh fitur aplikasi beserta lapisan masing-masing.

**shared/**

Berisi komponen bersama yang tidak memiliki kepemilikan khusus pada satu fitur.

**generated/**

Berisi kode hasil generator seperti kode Drift dan Pigeon. Kode di dalamnya tidak boleh diedit secara manual.

**android/**

Berisi integrasi khusus Android menggunakan Kotlin dan konfigurasi sistem operasi.

**test/**

Berisi pengujian unit, widget, dan integrasi.

**docs/**

Berisi dokumentasi utama proyek.

---

## 5. Arsitektur Modul

### 5.1. Modul Dashboard

Tanggung jawab:

- Menampilkan ringkasan aktivitas tidur.
- Menampilkan status sesi aktif.
- Menampilkan tombol tambah.
- Menampilkan card tindakan tidur.
- Menyediakan navigasi ke fitur lainnya.

Dashboard tidak menghitung durasi tidur secara mandiri.

Seluruh informasi diperoleh melalui Use Case atau state dari modul terkait.

### 5.2. Modul Sleep Session

Modul ini menjadi pusat pengelolaan sesi tidur.

Tanggung jawab:

- Membuat sesi tidur.
- Mengakhiri sesi tidur.
- Memeriksa sesi aktif.
- Mengedit sesi.
- Menghapus sesi.
- Menghitung durasi tidur.
- Memvalidasi data sesi.
- Memulihkan sesi setelah aplikasi dibuka kembali.

Use Case yang disediakan:

- `StartSleepSession`
- `EndSleepSession`
- `GetActiveSleepSession`
- `GetSleepSessionById`
- `GetSleepSessions`
- `UpdateSleepSession`
- `DeleteSleepSession`
- `RecoverActiveSession`

Aturan bisnis sesi tidur harus berada di Domain Layer.

### 5.3. Modul Wake-up

Tanggung jawab:

- Mengaktifkan Wake-up Mode.
- Menjalankan pola getaran.
- Mengatur status Wake-up Mode.
- Menghentikan getaran.
- Mengakhiri Wake-up Mode.
- Memulihkan status mode jika aplikasi dibuka kembali.

Use Case:

- `ActivateWakeUpMode`
- `StartVibration`
- `StopVibration`
- `CloseWakeUpMode`
- `RestoreWakeUpState`

Wake-up Mode tidak bertanggung jawab terhadap penyimpanan waktu bangun. Penyimpanan tersebut merupakan tanggung jawab modul Sleep Session.

### 5.4. Modul Sleep History

Tanggung jawab:

- Mengambil seluruh sesi tidur.
- Menampilkan daftar riwayat.
- Mengurutkan data.
- Memfilter berdasarkan tanggal.
- Membuka detail sesi.
- Mengelola tindakan edit dan hapus.

### 5.5. Modul Statistics

Tanggung jawab:

- Menghitung rata-rata tidur.
- Menghitung total durasi.
- Menghitung rata-rata waktu tidur.
- Menghitung rata-rata waktu bangun.
- Menghitung durasi terlama dan terpendek.
- Mengelompokkan data harian, mingguan, dan bulanan.
- Menyiapkan data untuk visualisasi.

Statistik harus menggunakan sesi selesai yang valid.

Sesi yang belum selesai tidak boleh dianggap sebagai sesi dengan durasi nol.

### 5.6. Modul Data Management

Tanggung jawab:

- Mengekspor data JSON.
- Mengekspor data CSV.
- Mengimpor backup JSON.
- Memvalidasi struktur file.
- Mendeteksi duplikasi.
- Menggabungkan data.
- Mengganti data setelah konfirmasi.

Modul ini harus menggunakan transaksi database untuk proses perubahan data yang melibatkan banyak record.

### 5.7. Modul Settings

Tanggung jawab:

- Mengelola konfigurasi getaran.
- Mengelola preferensi suara.
- Mengelola preferensi tampilan.
- Mengelola preferensi zona waktu.
- Mengelola pengaturan Wake-up Mode.

Pengaturan yang bersifat preferensi pengguna disimpan secara lokal.

---

## 6. Pengelolaan State Menggunakan BLoC

Frenooze menggunakan BLoC untuk memisahkan interaksi antarmuka dari aturan bisnis.

Setiap fitur memiliki BLoC sesuai tanggung jawabnya.

### 6.1. SleepSessionBloc

Menangani:

- Permintaan memulai tidur.
- Permintaan mengakhiri tidur.
- Pemeriksaan sesi aktif.
- Pemulihan sesi.
- Perubahan data sesi.

Contoh event:

```text
SleepSessionEvent
|
|-- LoadActiveSession
|-- StartSleepRequested
|-- EndSleepRequested
|-- UpdateSleepRequested
|-- DeleteSleepRequested
|-- RecoverSessionRequested
```

Contoh state:

```text
SleepSessionState
|
|-- Initial
|-- Loading
|-- Idle
|-- ReadyToSleep
|-- Sleeping
|-- Completing
|-- Success
|-- Failure
```

### 6.2. WakeUpBloc

Menangani:

- Aktivasi Wake-up Mode.
- Permintaan getaran.
- Penghentian getaran.
- Penutupan mode.
- Pemulihan status.

Contoh event:

```text
WakeUpEvent
|
|-- WakeUpModeActivated
|-- VibrationStarted
|-- VibrationStopped
|-- WakeUpModeClosed
|-- WakeUpStateRestored
```

Contoh state:

```text
WakeUpState
|
|-- Initial
|-- Inactive
|-- Activating
|-- Active
|-- Closing
|-- Failure
```

### 6.3. HistoryBloc

Menangani:

- Memuat riwayat.
- Mengubah filter tanggal.
- Mengambil detail.
- Memperbarui daftar setelah perubahan data.

### 6.4. StatisticsBloc

Menangani:

- Memuat statistik.
- Mengubah periode.
- Mengolah ringkasan.
- Memperbarui statistik setelah data berubah.

### 6.5. SettingsBloc

Menangani:

- Membaca pengaturan.
- Mengubah pengaturan.
- Menyimpan preferensi.
- Memperbarui konfigurasi platform.

### 6.6. Aturan Komunikasi BLoC

BLoC tidak boleh saling bergantung secara langsung melalui pemanggilan internal yang berantai.

Jika satu tindakan membutuhkan perubahan pada fitur lain, gunakan Use Case, Repository, atau layanan koordinasi yang jelas.

Contoh:

Ketika SleepSessionBloc menyelesaikan sesi tidur, aplikasi menyimpan data terlebih dahulu, kemudian mengaktifkan Wake-up Mode melalui alur koordinasi yang terpisah.

Dengan demikian, kegagalan Wake-up Mode tidak menyebabkan data sesi tidur hilang.

---

## 7. Sistem State Machine

Frenooze menggunakan state machine untuk memastikan alur sesi berjalan secara konsisten.

### 7.1. Status Sesi

```text
IDLE
  |
  | Pengguna menekan tombol tambah
  v
READY_TO_SLEEP
  |
  | Konfirmasi mulai tidur
  v
SLEEPING
  |
  | Pengguna menekan tombol bangun
  v
COMPLETED
```

Status Wake-up Mode dikelola secara terpisah:

```text
INACTIVE
  |
  | Sesi berhasil diselesaikan
  v
ACTIVE
  |
  | Pengguna menekan tombol close
  v
INACTIVE
```

### 7.2. Aturan Transisi

- IDLE hanya dapat berpindah ke READY_TO_SLEEP.
- READY_TO_SLEEP dapat kembali ke IDLE atau berpindah ke SLEEPING.
- SLEEPING hanya dapat diselesaikan melalui tindakan akhir sesi atau proses koreksi yang sah.
- COMPLETED tidak dapat kembali menjadi SLEEPING secara otomatis.
- Wake-up Mode hanya dapat aktif setelah sesi berhasil disimpan.
- Menutup Wake-up Mode tidak mengubah status sesi.

### 7.3. Validasi Transisi

Setiap transisi harus divalidasi oleh Domain Layer.

Antarmuka tidak boleh menjadi satu-satunya pengaman terhadap transisi yang tidak valid.

---

## 8. Sistem Waktu dan Zona Waktu

Pengelolaan waktu merupakan salah satu bagian paling penting dalam arsitektur Frenooze.

Sistem harus dapat membedakan antara waktu absolut, waktu lokal, dan zona waktu.

### 8.1. Konsep Waktu

Frenooze menggunakan tiga komponen:

**1. Timestamp UTC**

Menjadi acuan waktu absolut untuk penyimpanan dan perhitungan.

**2. Zona Waktu IANA**

Mengidentifikasi aturan zona waktu berdasarkan wilayah.

**3. UTC Offset**

Menyimpan selisih waktu lokal terhadap UTC ketika suatu kejadian dicatat.

Contoh:

| Wilayah | Zona IANA     | UTC Offset |
| ------- | ------------- | ---------- |
| WIB     | Asia/Jakarta  | +07:00     |
| WITA    | Asia/Makassar | +08:00     |
| WIT     | Asia/Jayapura | +09:00     |

Zona waktu tidak boleh disimpan hanya sebagai WIB, WITA, atau WIT karena identitas tersebut merupakan kategori tampilan, bukan identitas wilayah yang lengkap.

### 8.2. Strategi Penyimpanan

Setiap sesi memiliki informasi waktu mulai dan waktu selesai.

Contoh:

```text
Sleep Session
|
|-- started_at_utc
|-- ended_at_utc
|-- start_timezone
|-- end_timezone
|-- start_offset
|-- end_offset
```

Seluruh timestamp disimpan sebagai waktu absolut.

Zona waktu dan offset disimpan sebagai metadata agar informasi lokal ketika pencatatan tetap dapat dipertahankan.

### 8.3. Deteksi Zona Waktu Perangkat

Ketika aplikasi dibuka atau terjadi perubahan zona waktu, sistem harus membaca zona waktu perangkat.

Pada Android, identitas zona waktu dapat diperoleh melalui API sistem.

Contoh identitas:

```text
Asia/Jakarta
Asia/Makassar
Asia/Jayapura
```

Dart harus menggunakan pustaka zona waktu yang mendukung identitas IANA.

Sistem tidak boleh mengasumsikan bahwa seluruh perangkat berada di Indonesia.

Jika zona waktu perangkat tidak dikenali atau tidak tersedia, aplikasi harus menggunakan penanganan cadangan yang aman dan tidak menebak wilayah pengguna.

### 8.4. Perubahan Zona Waktu

Contoh kasus:

1. Pengguna memulai tidur di Banjarmasin.
2. Pengguna berpindah ke wilayah WIB ketika bepergian.
3. Pengguna bangun setelah perangkat berpindah zona waktu.

Sistem harus menyimpan zona waktu ketika mulai dan ketika selesai secara terpisah.

Perubahan zona waktu tidak boleh mengubah timestamp absolut sebelumnya.

Tampilan waktu dapat menggunakan zona waktu yang dipilih pengguna, sementara informasi waktu asli tetap dipertahankan.

### 8.5. Perubahan Jam Manual

Jam sistem dapat diubah secara manual oleh pengguna.

Karena itu, Frenooze harus membedakan:

- Waktu dinding perangkat.
- Waktu monotonik sejak perangkat menyala.
- Waktu absolut yang tersimpan.

Untuk meningkatkan ketahanan perhitungan durasi, sistem dapat menggunakan dua sumber waktu.

**Waktu dinding:**

Digunakan untuk menentukan tanggal dan jam yang ditampilkan.

**Waktu monotonik Android:**

Menggunakan `SystemClock.elapsedRealtime()` untuk mengukur interval sejak perangkat menyala, termasuk ketika perangkat berada dalam kondisi tidur.

Sistem harus menyimpan informasi waktu monotonik dan identitas boot perangkat ketika sesi dimulai.

Jika identitas boot masih sama ketika sesi berakhir, selisih waktu monotonik dapat digunakan sebagai acuan durasi yang lebih tahan terhadap perubahan jam manual.

Jika perangkat mengalami restart selama sesi, nilai monotonik sebelumnya tidak dapat dibandingkan secara langsung dengan nilai setelah restart.

Dalam kondisi tersebut, sistem menggunakan timestamp absolut sebagai alternatif dan dapat menandai hasil perhitungan sebagai berpotensi tidak akurat jika perubahan jam terdeteksi.

### 8.6. Sinkronisasi Waktu

Frenooze tidak memerlukan sinkronisasi waktu melalui internet.

Aplikasi menggunakan waktu sistem perangkat sebagai sumber waktu utama.

Jika jam perangkat tidak akurat, aplikasi harus menyampaikan bahwa akurasi pencatatan mengikuti pengaturan waktu perangkat.

### 8.7. Waktu dan Statistik

Statistik harus menggunakan zona waktu yang konsisten untuk menentukan batas hari, minggu, dan bulan.

Sistem harus membedakan antara:

- Tanggal lokal ketika tidur dimulai.
- Tanggal lokal ketika pengguna bangun.
- Durasi aktual sesi.

Sesi yang melewati tengah malam tidak boleh dihitung sebagai dua sesi berbeda.

Perhitungan durasi harus berdasarkan waktu absolut atau sumber interval monotonik yang valid, bukan selisih angka jam lokal.

---

## 9. Sistem Timer dan Efisiensi Baterai

Frenooze tidak menggunakan timer background yang terus berjalan selama sesi tidur.

### 9.1. Prinsip Kerja

Ketika pengguna memulai sesi:

1. Ambil waktu sistem.
2. Ambil waktu monotonik.
3. Simpan informasi boot perangkat.
4. Simpan data sesi.
5. Hentikan seluruh pekerjaan yang tidak diperlukan.

Selama pengguna tidur, aplikasi tidak melakukan polling berkala hanya untuk memperbarui angka durasi.

Ketika aplikasi dibuka kembali:

1. Ambil waktu terbaru.
2. Ambil informasi waktu monotonik.
3. Validasi kondisi perangkat.
4. Hitung durasi sementara.
5. Perbarui tampilan.

### 9.2. Perbedaan Timer dan Pengukuran Durasi

Timer adalah proses yang terus dijalankan untuk memperbarui waktu.

Pengukuran durasi hanya membutuhkan waktu awal dan waktu akhir.

Frenooze menggunakan pengukuran durasi berbasis timestamp agar lebih hemat baterai.

### 9.3. Ketentuan

- Tidak menggunakan loop setiap detik ketika pengguna tidur.
- Tidak mempertahankan CPU WakeLock selama sesi tidur.
- Tidak menjalankan service hanya untuk menghitung durasi.
- Tidak menggunakan alarm presisi untuk memperbarui angka durasi.
- Menggunakan waktu monotonik untuk interval ketika masih berada dalam boot yang sama.

---

## 10. Integrasi Flutter dan Android

Frenooze menggunakan Kotlin untuk fungsi yang memerlukan akses langsung ke API Android.

### 10.1. Komunikasi Platform

Komunikasi Flutter dan Kotlin menggunakan Pigeon sebagai pilihan utama untuk menghasilkan antarmuka komunikasi yang bertipe.

Kontrak komunikasi harus didefinisikan secara eksplisit.

Contoh kelompok fungsi:

```text
AndroidPlatformApi
|
|-- getDeviceTimezone()
|-- getUtcOffset()
|-- getElapsedRealtime()
|-- getBootCount()
|-- startVibration()
|-- stopVibration()
|-- keepScreenOn()
|-- releaseScreenOn()
|-- getAppLifecycleState()
```

Nama dan bentuk fungsi tersebut merupakan rancangan antarmuka, bukan implementasi final.

### 10.2. Pemisahan Tanggung Jawab

Flutter bertanggung jawab terhadap:

- Tampilan.
- Navigasi.
- Aturan bisnis.
- Penyimpanan sesi.
- Statistik.
- Validasi.
- Pengaturan pengguna.

Kotlin bertanggung jawab terhadap:

- Akses vibrator.
- Akses waktu monotonik Android.
- Informasi boot perangkat.
- Pengelolaan layar.
- API sistem operasi.
- Integrasi notifikasi jika diperlukan.

Kotlin tidak boleh menyimpan aturan bisnis sesi tidur yang sudah menjadi tanggung jawab Dart.

### 10.3. Penanganan Kegagalan Platform

Semua pemanggilan API Android harus memiliki penanganan kegagalan.

Contoh:

- Perangkat tidak memiliki vibrator.
- API tidak tersedia pada versi Android tertentu.
- Izin atau akses khusus tidak diberikan.
- Platform channel mengalami kegagalan.
- Aktivitas aplikasi sudah tidak tersedia.

Kegagalan fungsi getaran tidak boleh menyebabkan data sesi tidur gagal disimpan.

---

## 11. Arsitektur Wake-up Mode Android

Wake-up Mode menggunakan sistem getaran perangkat sebagai mekanisme utama.

### 11.1. Pengelolaan Getaran

Kotlin menggunakan API:

- `VibratorManager` untuk perangkat yang mendukung API tersebut.
- `Vibrator` sebagai mekanisme akses vibrator.
- `VibrationEffect` untuk membuat pola getaran.

Sistem harus mendukung pemeriksaan kemampuan perangkat sebelum menjalankan efek getaran.

### 11.2. Pola Getaran

Pola getaran disimpan sebagai konfigurasi aplikasi.

Contoh konsep:

```text
GETAR
  |
  |-- Getar pendek
  |-- Jeda
  |-- Getar panjang
  |-- Jeda
  |-- Getar pendek
  |
  v
ULANGI
```

Pengulangan efek getaran sebaiknya memanfaatkan mekanisme pengulangan pada API vibrator, bukan membuat loop Dart yang aktif tanpa henti.

### 11.3. Aktivasi Wake-up Mode

Urutan proses:

```text
Pengguna menekan tombol bangun
          |
          v
Simpan waktu bangun
          |
          v
Pastikan sesi selesai
          |
          v
Simpan status Wake-up Mode
          |
          v
Aktifkan antarmuka Wake-up Mode
          |
          v
Aktifkan pola getaran
```

Penyimpanan sesi harus selesai sebelum proses getaran dimulai.

### 11.4. Pengelolaan Layar

Selama Wake-up Mode tampil di depan:

- Aktivitas Android menjaga layar tetap menyala.
- Flutter menampilkan antarmuka Wake-up Mode.
- Getaran dijalankan melalui API Android.
- Pengaturan layar dilepas setelah mode ditutup.

Fitur layar menyala tidak boleh digunakan ketika pengguna sedang berada dalam sesi tidur.

### 11.5. Penghentian Getaran

Ketika pengguna menekan tombol close:

1. Flutter mengirim perintah penghentian.
2. Kotlin membatalkan efek getaran.
3. Sistem melepaskan pengaturan layar.
4. Status Wake-up Mode diperbarui.
5. Pengguna dikembalikan ke dashboard.

Penghentian getaran harus bersifat idempoten. Memanggil perintah berhenti lebih dari sekali tidak boleh menimbulkan kesalahan.

### 11.6. Kondisi Aplikasi Berada di Latar Belakang

Wake-up Mode pada MVP diprioritaskan untuk kondisi ketika aplikasi sedang terlihat dan digunakan.

Jika aplikasi diminimalkan, berpindah ke aplikasi lain, atau aktivitas dihentikan sistem, perilaku getaran harus mengikuti kemampuan dan batasan Android.

Jika diperlukan dukungan yang lebih kuat ketika aplikasi tidak terlihat, implementasi dapat dievaluasi menggunakan mekanisme layanan Android yang sesuai.

Jangan mengasumsikan bahwa layanan latar depan dapat digunakan tanpa batasan. Jenis layanan, izin, notifikasi, serta aturan versi Android harus dipenuhi.

Aplikasi tidak boleh membuat layanan latar depan hanya untuk mempertahankan timer sesi tidur.

### 11.7. Pemulihan Wake-up Mode

Status Wake-up Mode disimpan secara terpisah dari data sesi.

Jika aplikasi dihentikan saat Wake-up Mode aktif:

- Data sesi yang selesai harus tetap tersedia.
- Status Wake-up Mode harus dapat diperiksa kembali.
- Saat aplikasi dibuka, antarmuka dapat memulihkan mode jika statusnya masih aktif.
- Getaran harus diperiksa dan diaktifkan kembali hanya jika sesuai dengan kondisi aplikasi.

Jika aplikasi ditutup atau proses dihentikan oleh pengguna maupun sistem, Frenooze tidak menjamin stimulasi getaran tetap berjalan tanpa gangguan.

---

## 12. Konfigurasi Sistem Android

### 12.1. Versi Android

Target awal adalah Android 12 atau lebih baru.

Minimum SDK yang direncanakan adalah API 26 atau Android 8.0 agar integrasi API waktu modern dan dependensi terkait lebih sederhana.

Target SDK harus mengikuti versi stabil yang diwajibkan oleh kebijakan distribusi ketika aplikasi dirilis.

Versi target dan versi minimum harus dibedakan.

### 12.2. Izin Android

Izin ditambahkan berdasarkan kebutuhan fitur yang benar-benar digunakan.

Daftar awal:

| Izin                           | Kegunaan                   | Keterangan                                 |
| ------------------------------ | -------------------------- | ------------------------------------------ |
| VIBRATE                        | Mengakses getaran          | Dibutuhkan                                 |
| POST_NOTIFICATIONS             | Menampilkan notifikasi     | Jika fitur notifikasi digunakan            |
| FOREGROUND_SERVICE             | Layanan latar depan        | Hanya jika memang diperlukan               |
| FOREGROUND_SERVICE_SPECIAL_USE | Jenis layanan khusus       | Hanya jika penggunaan memenuhi persyaratan |
| RECEIVE_BOOT_COMPLETED         | Menerima peristiwa restart | Jika pemulihan sistem memerlukannya        |

Tidak semua izin harus langsung ditambahkan.

Izin yang tidak diperlukan sebaiknya tidak diminta.

### 12.3. Notifikasi

Notifikasi bukan bagian wajib dari mekanisme pencatatan tidur.

Notifikasi dapat digunakan untuk memberikan informasi status aplikasi atau mendukung layanan latar depan jika kelak diperlukan.

Jika digunakan pada Android 13 atau lebih baru, aplikasi harus memperhatikan izin notifikasi.

### 12.4. AlarmManager

MVP tidak memerlukan alarm presisi karena pengguna sendiri yang menekan tombol bangun.

AlarmManager tidak boleh digunakan hanya untuk memperbarui durasi tidur.

Jika fitur alarm terjadwal ditambahkan di masa depan, kebutuhan izin alarm presisi dan kebijakan Android harus dievaluasi secara terpisah.

### 12.5. WakeLock

Frenooze tidak boleh mempertahankan CPU WakeLock sepanjang sesi tidur.

Penggunaan pengaturan layar tetap menyala hanya dibatasi pada antarmuka Wake-up Mode yang sedang terlihat.

### 12.6. Battery Optimization

Aplikasi harus tetap berfungsi tanpa meminta pengguna menonaktifkan optimasi baterai secara paksa.

Jangan meminta pengecualian optimasi baterai tanpa alasan teknis yang benar-benar diperlukan.

---

## 13. Arsitektur Basis Data

Frenooze menggunakan SQLite dengan Drift sebagai lapisan akses basis data.

### 13.1. Tabel Sleep Sessions

Tabel utama untuk menyimpan seluruh sesi tidur.

```text
sleep_sessions
|
|-- id
|-- started_at_utc_ms
|-- ended_at_utc_ms
|-- start_timezone
|-- end_timezone
|-- start_offset_minutes
|-- end_offset_minutes
|-- start_elapsed_ms
|-- end_elapsed_ms
|-- start_boot_count
|-- end_boot_count
|-- is_start_manual
|-- is_end_manual
|-- time_accuracy_status
|-- created_at_utc_ms
|-- updated_at_utc_ms
```

Keterangan:

- `started_at_utc_ms`: waktu mulai dalam timestamp UTC.
- `ended_at_utc_ms`: waktu selesai, dapat bernilai kosong untuk sesi aktif.
- `start_timezone`: identitas zona waktu ketika mulai.
- `end_timezone`: identitas zona waktu ketika selesai.
- `start_offset_minutes`: offset ketika mulai.
- `end_offset_minutes`: offset ketika selesai.
- `start_elapsed_ms`: waktu monotonik ketika mulai.
- `end_elapsed_ms`: waktu monotonik ketika selesai.
- `start_boot_count`: identitas boot ketika mulai.
- `end_boot_count`: identitas boot ketika selesai.
- `time_accuracy_status`: penanda kondisi keandalan perhitungan waktu.

### 13.2. Tabel App Settings

Menyimpan konfigurasi aplikasi.

```text
app_settings
|
|-- id
|-- setting_key
|-- setting_value
|-- updated_at_utc_ms
```

Pengaturan dapat menggunakan tabel ini atau penyimpanan preferensi lokal sesuai jenis datanya.

### 13.3. Tabel Wake-up State

Status Wake-up Mode perlu dipertahankan secara lokal.

```text
wake_up_state
|
|-- id
|-- is_active
|-- activated_at_utc_ms
|-- related_session_id
|-- updated_at_utc_ms
```

Hanya satu status Wake-up Mode aktif yang diperbolehkan.

### 13.4. Indeks dan Batasan

Database harus menerapkan:

- Primary key untuk setiap tabel.
- Indeks tanggal sesi.
- Foreign key untuk hubungan antartabel.
- Validasi hubungan waktu.
- Pembatasan satu sesi aktif.

Satu sesi aktif dapat dijaga menggunakan unique partial index pada baris yang memiliki `ended_at_utc_ms IS NULL`.

### 13.5. Migrasi Database

Setiap perubahan struktur tabel harus disertai migrasi.

Ketentuan:

- Nomor versi database harus dikelola.
- Migrasi tidak boleh menghapus data lama secara tidak sengaja.
- Migrasi harus diuji pada database versi sebelumnya.
- Kegagalan migrasi harus ditangani secara aman.

---

## 14. Strategi Ekspor dan Impor

### 14.1. JSON

JSON menjadi format utama backup dan restore.

Contoh struktur:

```json
{
    "application": "Frenooze",
    "backup_version": 1,
    "exported_at": "2026-11-12T00:00:00Z",
    "sessions": [
        {
            "id": "session-id",
            "started_at_utc_ms": 1794441600000,
            "ended_at_utc_ms": 1794468600000,
            "start_timezone": "Asia/Makassar",
            "end_timezone": "Asia/Makassar",
            "start_offset_minutes": 480,
            "end_offset_minutes": 480
        }
    ]
}
```

Contoh tersebut hanya menggambarkan struktur data.

Format backup harus memiliki versi agar dapat dikembangkan tanpa merusak kompatibilitas.

### 14.2. CSV

CSV digunakan untuk analisis eksternal.

Kolom yang disarankan:

```text
id,
started_at,
ended_at,
start_timezone,
end_timezone,
duration_seconds,
is_start_manual,
is_end_manual
```

### 14.3. Proses Import

Import harus melewati tahapan:

1. Membaca file.
2. Memvalidasi struktur.
3. Memvalidasi versi backup.
4. Memvalidasi setiap record.
5. Mendeteksi duplikasi.
6. Menampilkan ringkasan.
7. Meminta konfirmasi.
8. Menjalankan transaksi.
9. Menampilkan hasil.

Jika terjadi kegagalan, operasi perubahan data harus dibatalkan secara transaksional.

### 14.4. Keamanan Data

- Jangan menjalankan kode dari file backup.
- Batasi ukuran file yang dapat diproses.
- Validasi seluruh input.
- Hindari menimpa database secara langsung.
- Pastikan file impor tidak dapat merusak struktur database.
- Jangan menganggap nama file sebagai bukti validitas isinya.

---

## 15. Pengelolaan Siklus Hidup Aplikasi

Frenooze harus dapat menangani perubahan kondisi aplikasi dan perangkat.

### 15.1. Aplikasi Masuk Latar Belakang

Ketika aplikasi tidak terlihat:

- Sesi tidur tetap tersimpan.
- Tidak ada timer yang harus dipertahankan.
- Tidak ada CPU WakeLock.
- Status sesi tetap dapat dipulihkan.

### 15.2. Aplikasi Dibuka Kembali

Ketika aplikasi aktif kembali:

1. Periksa status database.
2. Ambil sesi aktif.
3. Ambil status Wake-up Mode.
4. Periksa informasi waktu perangkat.
5. Hitung ulang durasi jika sesi masih aktif.
6. Pulihkan antarmuka sesuai keadaan terakhir.

### 15.3. Proses Aplikasi Dihentikan

Jika Android menghentikan proses aplikasi:

- Data yang sudah tersimpan harus tetap aman.
- Sesi aktif tidak boleh hilang.
- Aplikasi harus dapat membaca kembali status sesi ketika dijalankan ulang.

### 15.4. Perangkat Restart

Setelah perangkat menyala kembali:

- Ambil sesi aktif dari database.
- Baca identitas boot terbaru.
- Jangan membandingkan waktu monotonik dari dua boot berbeda.
- Gunakan mekanisme perhitungan cadangan jika sesi melintasi restart.
- Tandai potensi ketidakakuratan jika diperlukan.

Tidak diperlukan layanan latar depan untuk mempertahankan sesi tidur selama perangkat restart.

---

## 16. Penanganan Kesalahan

Seluruh fitur harus memiliki penanganan kegagalan yang konsisten.

Contoh kondisi:

| Kondisi                  | Penanganan                                     |
| ------------------------ | ---------------------------------------------- |
| Sesi aktif sudah ada     | Tolak sesi baru                                |
| Tidak ada sesi aktif     | Tolak permintaan bangun                        |
| Database gagal           | Tampilkan kesalahan dan pertahankan data       |
| Perangkat tanpa vibrator | Berikan informasi bahwa getaran tidak tersedia |
| Getaran gagal            | Sesi tetap tersimpan                           |
| Zona waktu tidak dikenal | Gunakan penanganan cadangan yang aman          |
| Jam perangkat berubah    | Tandai potensi ketidakakuratan                 |
| File impor rusak         | Tolak impor                                    |
| Duplikasi data           | Tampilkan hasil deteksi                        |
| Migrasi gagal            | Jangan menghapus database lama                 |

Kesalahan harus dibedakan antara kesalahan bisnis, kesalahan penyimpanan, dan kesalahan platform.

---

## 17. Strategi Pengujian

Pengujian dibagi menjadi empat kategori.

### 17.1. Unit Testing

Menguji:

- Perhitungan durasi tidur.
- Validasi sesi.
- Perubahan state.
- Perhitungan statistik.
- Konversi zona waktu.
- Validasi impor.
- Deteksi duplikasi.

### 17.2. Widget Testing

Menguji:

- Dashboard.
- Card mulai tidur.
- Tampilan sesi aktif.
- Wake-up Mode.
- Riwayat.
- Statistik.
- Formulir edit.

### 17.3. Integration Testing

Menguji:

- Penyimpanan SQLite.
- Alur mulai dan selesai tidur.
- Pemulihan sesi.
- Export dan import.
- Integrasi Flutter dengan Kotlin.
- Aktivasi dan penghentian getaran.

### 17.4. Pengujian Perangkat Android

Pengujian harus mencakup:

- Layar mati.
- Mode hemat baterai.
- Mode jangan ganggu.
- Volume nol.
- Aplikasi diminimalkan.
- Aplikasi dihentikan sistem.
- Perangkat restart.
- Perubahan zona waktu.
- Perubahan jam manual.
- Perangkat dengan dan tanpa vibrator.
- Perbedaan versi Android.

Pengujian pada perangkat fisik wajib dilakukan untuk memastikan perilaku API Android sesuai kondisi nyata.

---

## 18. Ketentuan Pengembangan

### 18.1. Konsistensi Kode

- Gunakan Dart untuk logika aplikasi utama.
- Gunakan Kotlin hanya untuk kebutuhan integrasi Android.
- Hindari duplikasi aturan bisnis.
- Pisahkan antarmuka dari akses data.
- Gunakan penamaan yang konsisten.
- Terapkan null safety.
- Hindari ketergantungan antarfitur yang tidak diperlukan.

### 18.2. Pengelolaan Dependensi

Setiap dependensi harus memiliki alasan penggunaan yang jelas.

Hindari menambahkan paket hanya untuk fungsi kecil yang dapat ditangani oleh Flutter atau Android secara langsung.

Dependensi harus diperiksa kompatibilitasnya dengan versi Flutter, Dart, dan Android yang digunakan.

### 18.3. Perubahan Arsitektur

Perubahan harus dilakukan secara bertahap.

Ketika menambahkan fitur:

1. Identifikasi modul yang terdampak.
2. Periksa aturan bisnis yang sudah berjalan.
3. Tentukan perubahan pada lapisan terkait.
4. Pertahankan fungsi yang sudah stabil.
5. Tambahkan atau perbarui pengujian.
6. Verifikasi tidak ada regresi.

### 18.4. Dokumentasi

Perubahan penting pada:

- Skema database.
- Struktur modul.
- Platform API.
- State machine.
- Format backup.
- Pengelolaan waktu.

Harus diikuti pembaruan dokumentasi.

---

## 19. Batasan Arsitektur

Beberapa keterbatasan sistem harus dipahami sejak awal:

1. Frenooze bergantung pada akurasi jam sistem perangkat.
2. Android dapat menghentikan proses aplikasi sesuai kebijakan sistem.
3. Getaran tidak dapat dijamin berjalan tanpa gangguan ketika aplikasi dihentikan paksa atau perangkat dimatikan.
4. Perangkat yang tidak memiliki vibrator tidak dapat menggunakan fungsi getaran.
5. Perilaku background dapat berbeda berdasarkan versi Android dan kebijakan produsen perangkat.
6. Pengukuran waktu monotonik tidak dapat dibandingkan lintas proses boot.
7. Perubahan waktu manual dapat memengaruhi keakuratan timestamp absolut.
8. Pengaturan layar tetap menyala hanya berlaku ketika aktivitas aplikasi terlihat.

Arsitektur harus dirancang untuk menangani keterbatasan tersebut tanpa mengorbankan integritas data.

---

## 20. Referensi Teknis

Dokumentasi resmi yang menjadi acuan implementasi:

### Flutter

- Platform Channels: https://docs.flutter.dev/platform-integration/platform-channels
- BLoC: https://bloclibrary.dev/
- Drift: https://drift.simonbinder.eu/

### Android

- Android Background Work: https://developer.android.com/develop/background-work
- Foreground Services: https://developer.android.com/develop/background-work/services/foreground-services
- Alarm Manager: https://developer.android.com/develop/background-work/services/alarms
- Vibration API: https://developer.android.com/develop/ui/views/haptics
- SystemClock: https://developer.android.com/reference/android/os/SystemClock
- ZoneId: https://developer.android.com/reference/java/time/ZoneId
- Screen On: https://developer.android.com/develop/ui/views/layout/keep-screen-on

### Basis Data

- SQLite: https://www.sqlite.org/docs.html

---

## 21. Kesimpulan Arsitektur

Frenooze dirancang sebagai aplikasi Android offline-first dengan arsitektur modular yang memisahkan tampilan, aturan bisnis, penyimpanan data, dan integrasi sistem operasi.

Flutter menjadi fondasi aplikasi utama, sedangkan Kotlin menangani kemampuan khusus Android.

Sistem pencatatan tidur menggunakan timestamp dan pengukuran durasi berbasis waktu, bukan timer background yang berjalan terus-menerus.

Zona waktu dikelola menggunakan identitas IANA, sementara timestamp UTC menjadi acuan penyimpanan waktu absolut.

Wake-up Mode menggunakan API getaran Android dengan pengelolaan siklus hidup yang terpisah dari pencatatan sesi tidur.

Seluruh data tidur disimpan secara lokal menggunakan SQLite dan dapat dikelola melalui sistem riwayat, statistik, ekspor, serta impor.

**Prinsip utama arsitektur Frenooze:**

Bangun aplikasi yang ringan, hemat baterai, konsisten dalam pengelolaan waktu, dapat diandalkan secara offline, dan mudah dikembangkan tanpa mengorbankan fungsi yang sudah berjalan.
