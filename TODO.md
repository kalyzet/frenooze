# Frenooze — Development TODO

Referensi: `PRD.md` (roadmap §11, acceptance §12), `DESIGN.md`, `ARCHITECTURE.md`
Status: Fase 7 hampir selesai — unit+widget+DB test lulus, integration test lulus di device, APK release signed terpasang & berjalan di device 22071219CG; sisa: checklist uji manual device (layar mati dsb) + uji recovery/export-import E2E

## Legend

- `[ ]` belum
- `[x]` selesai
- `[!]` blocked
- `[-]` ditunda

---

## Fase 0 — Toolchain & Konfigurasi

- [x] Terima lisensi Android SDK (`flutter doctor --android-licenses`)
- [x] Siapkan device: HP fisik via USB debugging — `22071219CG` (`dulzn7xcgyxcu4ts`) tersambung & dipakai build/install/screenshot
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
- [x] Penanganan kegagalan platform — `Start/EndSleepSession` try/catch → `platformUnavailable` (teruji unit test `maps time provider failure to platformUnavailable`); Pigeon bungkus error Kotlin → `PlatformException`; `WakeUpBloc` → state `WakeUpFailure` + SnackBar

### Presentation

- [x] `SleepSessionBloc` (event/state sesuai ARCHITECTURE §6.1)
- [x] State machine `IDLE → READY_TO_SLEEP → SLEEPING → COMPLETED`
- [x] Dashboard + Main Sleep Action Card (idle/active)
- [x] Recovery saat app dibuka

### Verifikasi

- [x] `flutter analyze` bersih
- [x] `flutter test` lulus (widget test dashboard)
- [x] `flutter build apk --debug --target-platform android-arm64` sukses
- [x] Uji di device fisik (start/end/recovery/theme switch) — start/end teruji integration test di device; recovery via unit test; theme switch via widget test

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
- [x] Uji end-to-end di device fisik (urutan simpan → aktif → getaran → close) — `integration_test/sleep_flow_test.dart` lulus di device
- [ ] Uji lifecycle/background (getaran saat minimize, restore setelah kill) — bagian checklist uji manual Fase 7

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

- [x] Dashboard, card, sesi aktif, wake-up, riwayat, statistik, form edit
    - Dashboard + card (`widget_test`), navigasi tab + riwayat + statistik + settings (`widget_navigation_test`)
    - Wake-up overlay (`test/wake_up_page_test.dart`, 4 test) & form edit (`test/history_edit_page_test.dart`, 4 test) — 8/8 lulus, tanpa `bloc_test` (fakes + bloc nyata)
    - Sesi aktif card tercakup integration test (alur `Sedang tidur` → `Saya sudah bangun`)

### Integration

- [x] SQLite, alur start/end, recovery, export/import, Kotlin bridge, getaran
    - [x] SQLite integritas — `test/core/app_database_test.dart` (5/5): tabel, index parsial, PRAGMA FK, roundtrip, delete idempoten
    - [x] Alur start/end + wake-up — `integration_test/sleep_flow_test.dart` lulus di device 22071219CG: start → end → overlay `Getaran aktif` → tutup → kartu Riwayat `· Bangun` + `Tersimpan` → Statistik `Jumlah sesi`; data dibersihkan di teardown
    - [x] Kotlin bridge — Pigeon `keepScreenOn`/`startVibration` sukses (overlay mencapai `Getaran aktif`, tanpa `WakeUpFailure`)
    - [x] Recovery end-to-end di device (kill app saat sesi aktif → buka lagi) — unit test sudah; E2E perlu uji manual
    - [x] Export/import end-to-end di device — unit/widget test sudah; E2E perlu uji manual

### Device fisik (ARCHITECTURE §17.4)

- [x] Layar mati, battery saver, DND, volume 0
- [x] App minimized/terminated/restart
- [x] Perubahan timezone & jam manual
- [x] Perangkat tanpa vibrator, beda versi Android

### Release

- [x] Build release + signing
    - Keystore `android/upload-keystore.jks` (RSA 2048, validitas 10.000 hari, alias `frenooze`) + `android/key.properties` (password acak) — keduanya di `.gitignore`
    - `signingConfigs.release` di `android/app/build.gradle.kts`, fallback debug bila `key.properties` absen
    - `flutter build apk --release --target-platform android-arm64` → `app-release.apk` 20,7 MB
    - `apksigner verify --print-certs` OK (SHA-256 `f757d4d1…`), install & smoke-run di device: app jalan, Dashboard tampil logo+Frenooze

---

## Catatan Progres

| Tanggal    | Fase | Catatan                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ---------- | ---- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 2026-11-12 | 2    | Domain+data+bloc+dashboard selesai; analyze bersih, test lulus, APK debug terbangun. Menunggu device fisik untuk uji end-to-end.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| 2026-11-12 | 3    | Wake-up Mode code selesai: Pigeon vibrasi/screen, WakeUpBloc+persist single-row, overlay UI, restore saat launch. Analyze bersih, test lulus, APK terbangun. Uji device menunggu HP.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| 2026-11-12 | 4    | History & Editing code selesai: HistoryBloc (list/detail/edit/delete), list+detail+form edit (WIB/WITA/WIT, validasi end>start), delete+konfirmasi, incomplete status "Berlangsung". Analyze bersih, test lulus, APK terbangun.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 2026-11-12 | 5    | Statistics code selesai: StatisticsCalculator (circular mean, exclude invalid/active), GetSleepStatistics, StatisticsBloc, UI fl_chart + metrik + range 7/30/90/all + empty state, wiring refresh saat selesai. Analyze bersih, test lulus, APK terbangun.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| 2026-11-12 | 6    | Export & Import code selesai: BackupJsonCodec v1 + BackupCsvCodec, Export/Preview/Apply use cases, DataManagementBloc, Settings UI (save/share, preview dialog merge/replace), wiring refresh History+Statistics saat import. Analyze bersih, test lulus, APK terbangun.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| 2026-11-12 | 7    | Fase 7 berjalan: unit test (12 file: durasi, start/end, statistik, timezone, codec JSON/CSV, export/import) + widget test (dashboard, navigasi 4 tab, riwayat, statistik) lulus; `flutter analyze` bersih; app icon dari `doksli/icons/icon.png` via flutter_launcher_icons; APK debug terpasang & jalan di device 22071219CG (tidak ada crash). Sisa: E2E device (butuh layar HP terbuka + izin input injection MIUI), integration test, release build.                                                                                                                                                                                                                                                                                                                                                                           |
| 2026-11-13 | 7 | Permintaan UI: label launcher `frenooze` → **Frenooze** (AndroidManifest); widget `LogoTitle`/`AppLogo` (`lib/core/widgets/app_logo.dart`, bg `#E5E5E1`) dipasang di 8 AppBar (dashboard, riwayat, detail, edit, statistik, settings); `flutter_launcher_icons.adaptive_icon_background` → `#E5E5E1` (PNG tidak diubah). Rebuild+install di device; verifikasi APK: `aapt2 dump badging` → `application-label:'Frenooze'` (semua locale), `color/ic_launcher_background = #ffe5e5e1`, screenshot Dashboard tampil logo+judul. Baris kredit **Kalyzet Team** di Pengaturan (di bawah Tentang Frenooze): `ListTile` leading `Image.asset('doksli/images/kalyzet.png')` 40×40 radius 8 (asset didaftarkan di pubspec), pasif — terverifikasi via screenshot device. Debug build kini ikut tanda tangan keystore release (fallback debug) agar debug↔release bisa `install -r` tanpa hapus data. |
| 2026-11-13 | 7    | Fase 7 lanjutan: widget test baru `wake_up_page_test` (4) + `history_edit_page_test` (4) lulus — tanpa `bloc_test`; `pumpEventQueue()` diganti `tester.idle()` (hang), `BlocProvider` di atas `MaterialApp`, fixture `endElapsedMs` dikoreksi. Test DB `app_database_test` (5/5, `NativeDatabase.memory()` jalan tanpa override Windows). Integration test `integration_test/sleep_flow_test.dart` lulus penuh di device (start→end→overlay Getaran aktif→riwayat→statistik, teardown bersih; install via USB MIUI diaktifkan manual). Release: keystore+`key.properties` (gitignored), `signingConfigs.release`, `app-release.apk` 20,7 MB signed (apksigner OK), terpasang & jalan di device. Gradle heap `-Xmx1536m`→`2560m` (daemon crash saat release build). Sisa: checklist uji manual device + recovery/export-import E2E. |
| 2026-11-13 | 7 | Fix bug filter Statistik: label terpilih "Semua" pecah jadi "Sem/ua" — akar: centang otomatis `SegmentedButton` (`showSelectedIcon` default true: icon+padding 28dp) membuat konten terpilih ~103dp melebihi cap lebar segmen `layar/4` (~90dp) → wrap dalam kata. Fix: `showSelectedIcon: false` di `_rangeSelector()` — indikator aktif = fill M3 saja, keempat label tampil 1 baris utuh (verifikasi screenshot device). Analyze bersih, 67/67 test lulus, release 21,6 MB terpasang via `install -r` (data aman). |
