# Frenooze — Development TODO

Referensi: `PRD.md` (roadmap §11, acceptance §12), `DESIGN.md`, `ARCHITECTURE.md`
Status: Fase 2 selesai — siap Fase 3

## Legend

- `[ ]` belum
- `[x]` selesai
- `[!]` blocked
- `[-]` ditunda

---

## Fase 0 — Toolchain & Konfigurasi

- [x] Terima lisensi Android SDK (`flutter doctor --android-licenses`)
- [-] Siapkan device: HP fisik via USB debugging (saat testing development)
- [x] Konfirmasi package `com.kalyzet.frenooze`, `minSdk 26`, `compileSdk`/`targetSdk 36`
- [x] Putuskan Pigeon vs MethodChannel → **Pigeon**
- [x] Pertahankan Flutter 3.38.5 (tanpa upgrade)

---

## Fase 1 — Project Foundation (PRD §11 Phase 1)

### Scaffold & Dependency

- [x] `flutter create --org com.kalyzet --project-name frenooze --platforms=android .`
- [x] Atur `minSdk 26` / `compileSdk 36` / `targetSdk 36` di `android/app/build.gradle.kts`
- [x] Tambah deps: `flutter_bloc`, `equatable`, `drift` (^2.34.0), `drift_flutter`, `sqlite3_flutter_libs`, `shared_preferences`, `timezone`, `fl_chart`, `file_picker`, `share_plus`, `intl`
- [x] Dev deps: `build_runner`, `drift_dev`, `pigeon`, `mocktail` (bloc_test ditunda: konflik resolver dengan drift_dev)
- [x] `analysis_options.yaml` ketat

### Struktur (ARCHITECTURE §4)

- [x] Buat `lib/core/{time,database,platform,theme,routing,widgets,errors,utils}`
- [x] Buat `lib/features/{dashboard,sleep_session,wake_up,sleep_history,statistics,data_management,settings}`
- [x] Buat `lib/shared/{models,enums,widgets}`

### Database (ARCHITECTURE §13)

- [x] Tabel `sleep_sessions` (semua kolom waktu UTC/IANA/offset/elapsed/boot/accuracy)
- [x] Tabel `app_settings`
- [x] Tabel `wake_up_state`
- [x] Unique partial index `ended_at_utc_ms IS NULL`
- [x] Migrasi v1
- [x] `dart run build_runner build --force-jit` (AOT builder gagal karena build hooks; JIT berhasil)

### Theme (DESIGN §3)

- [x] `SleepTheme` (palet `#101315` dsb)
- [x] `WakeTheme` (palet `#F8F9F5` dsb)
- [x] Theme switching by app state (bukan jam) — `ThemeModeController`
- [x] Tipografi 32/24/20/18/16/14/12 sp + spacing 4dp

### Navigation

- [x] Routing (Navigator + IndexedStack shell)
- [x] Bottom nav: Dashboard, Riwayat, Statistik, Pengaturan

### Verifikasi

- [x] `flutter analyze` bersih
- [x] `flutter build apk --debug` sukses (build butuh tuning memori Gradle: `-Xmx1536m`, daemon off, `--target-platform android-arm64`; APK 82.2 MB)

---

## Fase 2 — Core Sleep Tracking (PRD §11 Phase 2)

### Domain

- [x] Entity `SleepSession`
- [x] Repository contract
- [x] Use cases: `StartSleepSession`, `EndSleepSession`, `GetActiveSleepSession`, `GetSleepSessionById`, `GetSleepSessions`, `UpdateSleepSession`, `DeleteSleepSession`, `RecoverActiveSession`
- [x] Aturan single active session (logic + DB)
- [x] Kalkulasi durasi dari timestamp (bukan timer)

### Data

- [x] Repository impl + mapper
- [x] DataSource Drift

### Platform (ARCHITECTURE §10)

- [x] Kotlin: `getDeviceTimezone`, `getElapsedRealtimeMs`, `getBootCount` (di `AndroidPlatformApiImpl.kt`)
- [x] Pigeon contract (`pigeons/android_platform_api.dart`) + generated `android_platform_api.g.dart` / `AndroidPlatformApi.g.kt`
- [x] Wiring di `MainActivity.kt` (register `AndroidPlatformApi`)
- [-] Penanganan kegagalan platform (try/catch di Kotlin, PlatformException di Dart) — dasar saja

### Presentation

- [x] `SleepSessionBloc` (event/state sesuai ARCHITECTURE §6.1)
- [x] State machine `IDLE → READY_TO_SLEEP → SLEEPING → COMPLETED`
- [x] Dashboard + Main Sleep Action Card (idle/active)
- [x] Recovery saat app dibuka

### Verifikasi

- [x] `flutter analyze` bersih
- [x] `flutter test` lulus (widget test dashboard)
- [x] `flutter build apk --debug --target-platform android-arm64` sukses
- [ ] Uji di device fisik (start/end/recovery/theme switch) — menunggu HP tersambung

---

## Fase 3 — Wake-up Mode (PRD §11 Phase 3)

- [ ] Kotlin `VibrationHandler` (`VibratorManager`/`Vibrator`/`VibrationEffect`)
- [ ] Pola getaran + repeat via API (bukan loop Dart)
- [ ] `keepScreenOn` / `releaseScreenOn`
- [ ] `WakeUpBloc` + persistence `wake_up_state`
- [ ] UI Wake Experience
- [ ] Tombol close idempoten
- [ ] Urutan: simpan sesi → aktifkan mode → getaran
- [ ] Uji lifecycle/background

---

## Fase 4 — History & Editing (PRD §11 Phase 4)

- [ ] History list (Sleep Experience)
- [ ] Detail sesi
- [ ] Form edit + validasi (end > start, dsb)
- [ ] Delete + konfirmasi
- [ ] Penanda `is_start_manual`/`is_end_manual`
- [ ] Incomplete session handling

---

## Fase 5 — Statistics (PRD §11 Phase 5)

- [ ] Agregasi daily/weekly/monthly
- [ ] Metrik: avg/total durasi, avg tidur/bangun, longest/shortest, count
- [ ] `fl_chart` (bar/line)
- [ ] Exclude sesi invalid (bukan durasi 0)
- [ ] Range 7/30/90/all + empty state

---

## Fase 6 — Export & Import (PRD §11 Phase 6)

- [ ] JSON export (`backup_version: 1`)
- [ ] CSV export
- [ ] JSON import: validasi struktur/tipe/timestamp/timezone
- [ ] Deteksi duplikat
- [ ] Preview + ringkasan
- [ ] Merge/Replace transaksional
- [ ] Proteksi data existing

---

## Fase 7 — Testing & Release (PRD §11 Phase 7)

### Unit

- [ ] Durasi, validasi sesi, state, statistik, timezone, validasi impor, duplikat

### Widget

- [ ] Dashboard, card, sesi aktif, wake-up, riwayat, statistik, form edit

### Integration

- [ ] SQLite, alur start/end, recovery, export/import, Kotlin bridge, getaran

### Device fisik (ARCHITECTURE §17.4)

- [ ] Layar mati, battery saver, DND, volume 0
- [ ] App minimized/terminated/restart
- [ ] Perubahan timezone & jam manual
- [ ] Perangkat tanpa vibrator, beda versi Android

### Release

- [ ] Build release + signing

---

## Catatan Progres

| Tanggal | Fase | Catatan |
| ------- | ---- | ------- |
| 2026-11-12 | 2 | Domain+data+bloc+dashboard selesai; analyze bersih, test lulus, APK debug terbangun. Menunggu device fisik untuk uji end-to-end. |
