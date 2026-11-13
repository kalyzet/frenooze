# Frenooze — Development TODO

Referensi: `PRD.md` (roadmap §11, acceptance §12), `DESIGN.md`, `ARCHITECTURE.md`
Status: Fase 7 berjalan — unit+widget test lulus, analyze bersih, APK terpasang & berjalan di device 22071219CG; label "Frenooze", logo header, dan bg ikon #E5E5E1 terverifikasi dari APK; uji E2E menunggu HP dibuka + izin input injection MIUI

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

### Platform (Kotlin / Pigeon)

- [x] Vibrasi via `AndroidPlatformApiImpl` (`VibratorManager` API 31+ / `Vibrator`, `VibrationEffect.createWaveform` repeat — hardware-driven, bukan loop Dart)
- [x] Pola getaran burst-with-pause (PRD §4.4.2)
- [x] `keepScreenOn` / `releaseScreenOn` (FLAG_KEEP_SCREEN_ON via Activity; cleanup di `onDestroy`)
- [x] Izin `android.permission.VIBRATE` di `AndroidManifest.xml`
- [x] Pigeon: `startVibration`, `stopVibration`, `keepScreenOn`, `releaseScreenOn` + regenerasi `.g.dart`/`.g.kt`

### Domain & Data

- [x] Entity `WakeUpStatus`, repository contract, `WakeUpHardware` port
- [x] Use cases: `ActivateWakeUpMode`, `CloseWakeUpMode`, `RestoreWakeUpState`
- [x] DataSource Drift single-row (id=1 upsert) + repository impl

### Presentation

- [x] `WakeUpBloc` (event `ActivateWakeUpRequested`/`CloseWakeUpRequested`/`RestoreWakeUpRequested`; state Initial/Inactive/Activating/Active/Closing/Failure)
- [x] Coordination: `SleepSessionSuccess(completed)` → activate (bloc tidak saling panggil; sesi tersimpan dulu — PRD §4.3)
- [x] UI Wake Experience (greeting, ringkasan, indikator getaran, close kecil) sebagai overlay penuh di atas shell
- [x] Tombol close idempoten; restore status aktif saat app dibuka (`RestoreWakeUpRequested` di `main()`)

### Verifikasi

- [x] `flutter analyze` bersih
- [x] `flutter test` lulus
- [x] `flutter build apk --debug --target-platform android-arm64` sukses
- [ ] Uji lifecycle/background (getaran saat minimize, restore setelah kill) — menunggu device
- [ ] Uji end-to-end di device fisik (urutan simpan → aktif → getaran → close)

---

## Fase 4 — History & Editing (PRD §11 Phase 4)

- [x] History list (Sleep Experience)
- [x] Detail sesi
- [x] Form edit + validasi (end > start, dsb)
- [x] Delete + konfirmasi
- [x] Penanda `is_start_manual`/`is_end_manual`
- [x] Incomplete session handling (status "Berlangsung", durasi tidak dihitung)

**Status:** code selesai — `flutter analyze` bersih, `flutter test` lulus, APK debug terbangun. Uji device menunggu HP tersambung.

---

## Fase 5 — Statistics (PRD §11 Phase 5)

- [x] Agregasi daily/weekly/monthly
- [x] Metrik: avg/total durasi, avg tidur/bangun, longest/shortest, count
- [x] `fl_chart` (bar/line)
- [x] Exclude sesi invalid (bukan durasi 0)
- [x] Range 7/30/90/all + empty state

**Status:** code selesai — `flutter analyze` bersih, `flutter test` lulus, APK debug terbangun. Uji device menunggu HP tersambung.

---

## Fase 6 — Export & Import (PRD §11 Phase 6)

- [x] JSON export (`backup_version: 1`)
- [x] CSV export
- [x] JSON import: validasi struktur/tipe/timestamp/timezone
- [x] Deteksi duplikat
- [x] Preview + ringkasan
- [x] Merge/Replace transaksional
- [x] Proteksi data existing

**Status:** code selesai — `flutter analyze` bersih, `flutter test` lulus, APK debug terbangun. Uji device menunggu HP tersambung.

---

## Fase 7 — Testing & Release (PRD §11 Phase 7)

### Unit

- [x] Durasi, validasi sesi, state, statistik, timezone, validasi impor, duplikat

### Widget

- [ ] Dashboard, card, sesi aktif, wake-up, riwayat, statistik, form edit
  - Sudah: dashboard (`widget_test`), navigasi tab + riwayat + statistik + settings (`widget_navigation_test`)
  - Belum: wake-up overlay & form edit (ditunda — `bloc_test` konflik resolver)

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
| 2026-11-12 | 3 | Wake-up Mode code selesai: Pigeon vibrasi/screen, WakeUpBloc+persist single-row, overlay UI, restore saat launch. Analyze bersih, test lulus, APK terbangun. Uji device menunggu HP. |
| 2026-11-12 | 4 | History & Editing code selesai: HistoryBloc (list/detail/edit/delete), list+detail+form edit (WIB/WITA/WIT, validasi end>start), delete+konfirmasi, incomplete status "Berlangsung". Analyze bersih, test lulus, APK terbangun. |
| 2026-11-12 | 5 | Statistics code selesai: StatisticsCalculator (circular mean, exclude invalid/active), GetSleepStatistics, StatisticsBloc, UI fl_chart + metrik + range 7/30/90/all + empty state, wiring refresh saat selesai. Analyze bersih, test lulus, APK terbangun. |
| 2026-11-12 | 6 | Export & Import code selesai: BackupJsonCodec v1 + BackupCsvCodec, Export/Preview/Apply use cases, DataManagementBloc, Settings UI (save/share, preview dialog merge/replace), wiring refresh History+Statistics saat import. Analyze bersih, test lulus, APK terbangun. |
| 2026-11-12 | 7 | Fase 7 berjalan: unit test (12 file: durasi, start/end, statistik, timezone, codec JSON/CSV, export/import) + widget test (dashboard, navigasi 4 tab, riwayat, statistik) lulus; `flutter analyze` bersih; app icon dari `doksli/icons/icon.png` via flutter_launcher_icons; APK debug terpasang & jalan di device 22071219CG (tidak ada crash). Sisa: E2E device (butuh layar HP terbuka + izin input injection MIUI), integration test, release build. |
| 2026-11-13 | 7 | Permintaan UI: label launcher `frenooze` → **Frenooze** (AndroidManifest); widget `LogoTitle`/`AppLogo` (`lib/core/widgets/app_logo.dart`, bg `#E5E5E1`) dipasang di 8 AppBar (dashboard, riwayat, detail, edit, statistik, settings); `flutter_launcher_icons.adaptive_icon_background` → `#E5E5E1` (PNG tidak diubah). Rebuild+install di device; verifikasi APK: `aapt2 dump badging` → `application-label:'Frenooze'` (semua locale), `color/ic_launcher_background = #ffe5e5e1`, screenshot Dashboard tampil logo+judul. Sisa: verifikasi header halaman lain via UI device (input injection masih ditolak MIUI). |
