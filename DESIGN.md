# Frenooze — Design System & UI/UX Specification

## 1. Overview

Frenooze adalah aplikasi pencatatan tidur offline untuk Android yang dirancang agar pengguna dapat mencatat aktivitas tidur dengan interaksi sesederhana mungkin.

Desain Frenooze berorientasi pada kenyamanan pengguna sebelum tidur dan pengalaman yang menyegarkan setelah bangun. Antarmuka tidak boleh menuntut terlalu banyak perhatian, terutama ketika pengguna sedang mengantuk atau baru terbangun.

Frenooze menggunakan dua identitas visual utama yang berubah berdasarkan kondisi aktivitas pengguna:

1. **Sleep Experience:** antarmuka gelap, tenang, dan minim stimulasi untuk kondisi sebelum tidur dan selama sesi tidur aktif.
2. **Wake Experience:** antarmuka terang, segar, dan memberikan dorongan positif untuk kondisi setelah pengguna bangun.

Kedua identitas ini merupakan bagian permanen dari karakter desain Frenooze, bukan sekadar pilihan dark mode dan light mode biasa.

## 2. Design Philosophy

### 2.1 Simplicity First

Pengguna harus dapat melakukan aktivitas utama tanpa melalui banyak langkah.

- Memulai sesi tidur cukup dengan satu tindakan utama.
- Mengakhiri sesi tidur cukup dengan satu tindakan utama.
- Tidak mewajibkan pengguna menulis catatan.
- Informasi penting harus langsung terlihat.
- Hindari menu dan elemen yang tidak memiliki fungsi jelas.

### 2.2 Sleep-Friendly Experience

Ketika pengguna hendak tidur atau sedang menjalani sesi tidur, aplikasi harus meminimalkan stimulasi visual.

- Gunakan warna gelap dengan tingkat kecerahan visual rendah.
- Hindari animasi yang mencolok.
- Hindari transisi yang mendadak.
- Jangan menggunakan elemen visual yang berkedip.
- Jangan memaksa pengguna melakukan interaksi tambahan.
- Prioritaskan keterbacaan dengan kontras yang memadai.

### 2.3 Wake-Friendly Experience

Setelah pengguna bangun, aplikasi dapat menghadirkan suasana yang lebih cerah dan ekspresif.

- Gunakan warna terang yang terasa segar.
- Tampilkan informasi hasil tidur secara jelas.
- Gunakan ilustrasi atau aksen visual secukupnya.
- Berikan umpan balik positif setelah sesi selesai.
- Pastikan seluruh interaksi mudah dipahami meskipun pengguna baru bangun.

### 2.4 Lightweight Interaction

Semua animasi dan interaksi harus ringan, responsif, dan tidak membebani perangkat.

Desain harus mengutamakan performa daripada efek visual yang berlebihan.

## 3. Two-Mode Design System

### 3.1 Mode Activation

Tema aplikasi ditentukan oleh kondisi aktivitas pengguna, bukan jam perangkat.

| Application State     | Design Mode      |
| --------------------- | ---------------- |
| Dashboard normal      | Sleep Experience |
| Card "Saya mau tidur" | Sleep Experience |
| Sesi tidur aktif      | Sleep Experience |
| Wake-up Mode          | Wake Experience  |
| Sesi tidur selesai    | Wake Experience  |

Perubahan mode terjadi secara otomatis ketika status sesi tidur berubah.

Tema tidak boleh mengubah status, waktu, durasi, maupun data sesi tidur.

### 3.2 Sleep Experience

**Visual identity:** Calm, Restful, Natural, Warm.

Sleep Experience digunakan pada dashboard normal, persiapan tidur, dan sesi tidur aktif.

Karakter warna:

- Soft Blue: memberikan kesan tenang dan lembut.
- Sage Green: menghadirkan nuansa alami dan seimbang.
- Warm Dark Tones: menciptakan suasana hangat dan nyaman.
- Black: menjadi fondasi tampilan gelap.

#### Sleep Color Palette

| Token            | Hex       | Penggunaan               |
| ---------------- | --------- | ------------------------ |
| Sleep Background | `#101315` | Background utama         |
| Sleep Surface    | `#191F20` | Surface dan panel        |
| Sleep Card       | `#222A29` | Kartu dan container      |
| Sleep Primary    | `#91A9C9` | Aksi utama dan highlight |
| Sleep Secondary  | `#9CAF9A` | Aksen natural            |
| Sleep Text       | `#E8ECE8` | Teks utama               |
| Sleep Muted      | `#89958E` | Teks sekunder            |
| Sleep Border     | `#303A37` | Border dan separator     |

#### Sleep Design Rules

- Background utama harus tetap gelap.
- Card menggunakan warna yang sedikit lebih terang daripada background.
- Warna soft blue digunakan untuk informasi dan tindakan penting.
- Sage green digunakan sebagai aksen pendukung.
- Hindari penggunaan warna putih terang secara berlebihan.
- Jangan menggunakan gradient dengan kontras tinggi.
- Hindari dekorasi yang tidak membantu pemahaman informasi.
- Elemen penting tetap harus terbaca dengan jelas.

### 3.3 Wake Experience

**Visual identity:** Fresh, Bright, Warm, Energizing.

Wake Experience digunakan ketika pengguna memasuki Wake-up Mode dan ketika sesi tidur telah selesai.

Karakter warna:

- Warm Yellow: memberikan asosiasi dengan sinar matahari dan energi positif.
- Soft Orange: menciptakan kesan hangat dan bersahabat.
- Crisp Sky Blue: memberikan kesan segar dan lega.
- White: menciptakan tampilan bersih dan terang.

#### Wake Color Palette

| Token           | Hex       | Penggunaan                |
| --------------- | --------- | ------------------------- |
| Wake Background | `#F8F9F5` | Background utama          |
| Wake Surface    | `#FFFFFF` | Surface dan panel         |
| Wake Card       | `#FFF4D8` | Kartu dengan aksen hangat |
| Wake Primary    | `#70B9E8` | Aksi utama dan highlight  |
| Wake Secondary  | `#FFD36E` | Aksen kuning              |
| Wake Accent     | `#F5A66D` | Aksen oranye              |
| Wake Text       | `#293746` | Teks utama                |
| Wake Muted      | `#87939C` | Teks sekunder             |
| Wake Border     | `#E7EAE5` | Border dan separator      |

#### Wake Design Rules

- Gunakan background terang yang nyaman dilihat.
- Warna putih menjadi dasar surface.
- Sky blue menjadi warna utama untuk interaksi.
- Warm yellow dan soft orange digunakan sebagai aksen.
- Hindari penggunaan kuning atau oranye sebagai warna teks berukuran kecil.
- Pastikan teks memiliki kontras yang cukup terhadap background.
- Jangan membuat seluruh elemen menggunakan warna cerah sekaligus.
- Prioritaskan informasi hasil tidur dan tindakan berikutnya.

### 3.4 Color Psychology Guidelines

Penggunaan psikologi warna merupakan pendekatan visual untuk membentuk suasana dan persepsi pengguna, bukan jaminan bahwa setiap pengguna akan merasakan respons emosional yang sama.

| Color          | Intended Association                    |
| -------------- | --------------------------------------- |
| Soft Blue      | Tenang, lembut, dan stabil              |
| Sage Green     | Natural, seimbang, dan nyaman           |
| Warm Dark      | Hangat, terlindungi, dan tidak mencolok |
| Black          | Minim stimulasi visual                  |
| Warm Yellow    | Cahaya matahari, optimisme, dan energi  |
| Soft Orange    | Kehangatan dan keramahan                |
| Crisp Sky Blue | Kesegaran dan kejernihan                |
| White          | Bersih, terang, dan sederhana           |

Kombinasi warna harus digunakan secara konsisten agar pengguna dapat mengenali perubahan pengalaman aplikasi tanpa harus membaca penjelasan tambahan.

## 4. Dashboard Design

### 4.1 Dashboard Overview

Dashboard merupakan halaman utama Frenooze dan menggunakan Sleep Experience.

Dashboard harus sederhana, tidak terlalu padat, serta menampilkan informasi yang paling relevan.

Susunan komponen:

1. Header aplikasi.
2. Greeting atau informasi waktu yang sederhana.
3. Ringkasan aktivitas tidur.
4. Main Sleep Action Card.
5. Ringkasan statistik.
6. Navigasi menuju riwayat dan pengaturan.

### 4.2 Header

Header menampilkan identitas aplikasi dan akses menuju pengaturan.

Elemen:

- Nama atau logo Frenooze.
- Informasi tanggal atau greeting sederhana.
- Tombol pengaturan.

Aturan desain:

- Tidak menggunakan header yang terlalu tinggi.
- Informasi tidak boleh memenuhi seluruh area atas.
- Ikon menggunakan ukuran dan gaya yang konsisten.
- Interaksi tombol memiliki feedback visual yang halus.

### 4.3 Sleep Summary

Komponen ini menampilkan ringkasan aktivitas tidur pengguna.

Informasi yang dapat ditampilkan:

- Total durasi tidur terakhir.
- Waktu mulai tidur.
- Waktu bangun.
- Ringkasan aktivitas tidur terbaru.

Gunakan informasi yang tersedia. Jangan menampilkan angka atau statistik kosong seolah-olah merupakan data nyata.

### 4.4 Main Sleep Action Card

Main Sleep Action Card adalah komponen paling penting pada dashboard.

Card memiliki dua kondisi utama.

#### Idle State

Ketika belum ada sesi tidur aktif:

- Tampilkan teks "Saya mau tidur".
- Gunakan ikon atau ilustrasi sederhana.
- Gunakan warna dan aksen dari Sleep Experience.
- Seluruh area tindakan utama mudah dikenali.
- Pengguna cukup melakukan satu tap untuk memulai sesi.

#### Active Sleep State

Ketika sesi tidur sedang berlangsung:

- Tampilkan status bahwa pengguna sedang tidur.
- Tampilkan waktu mulai tidur.
- Tampilkan durasi berjalan berdasarkan timestamp.
- Tampilkan tindakan "Bangun tidur".
- Jangan menampilkan tombol untuk memulai sesi kedua.

Card harus berubah berdasarkan status sesi tanpa memerlukan navigasi tambahan.

### 4.5 Dashboard Navigation

Navigasi utama dapat menggunakan bottom navigation pada perangkat Android.

Halaman utama yang disediakan:

- Dashboard.
- Riwayat tidur.
- Statistik.
- Pengaturan.

Navigasi harus sederhana dan tidak terlalu banyak menggunakan submenu.

## 5. Sleep Session Design

### 5.1 Active Sleep Session

Ketika sesi tidur dimulai, pengguna tetap berada dalam Sleep Experience.

Tampilan harus lebih minimal daripada dashboard normal.

Informasi utama:

- Status sesi tidur.
- Waktu mulai tidur.
- Durasi sesi.
- Tombol "Bangun tidur".

Elemen dekoratif tidak boleh mengganggu pengguna.

### 5.2 Sleep Session Card

Card sesi tidur harus memiliki struktur visual yang konsisten.

Komponen:

- Status sesi.
- Waktu mulai.
- Durasi tidur.
- Waktu selesai jika sudah tersedia.
- Indikator sesi aktif atau selesai.

Untuk sesi aktif, card harus menggunakan warna Sleep Experience.

Untuk sesi selesai, card menggunakan warna Wake Experience.

### 5.3 Sleep Session Detail

Pengguna dapat membuka detail sesi untuk melihat:

- Tanggal tidur.
- Waktu mulai.
- Waktu selesai.
- Durasi total.
- Zona waktu.
- Informasi tambahan jika tersedia.

Pengguna juga harus dapat mengedit data sesi secara manual.

Pengeditan data tidak boleh mengubah histori secara diam-diam. Perubahan harus tersimpan secara konsisten.

### 5.4 Empty State

Jika pengguna belum memiliki riwayat tidur:

- Tampilkan pesan yang ramah.
- Berikan penjelasan singkat.
- Arahkan pengguna untuk memulai pencatatan pertama.
- Hindari tampilan kosong tanpa konteks.

## 6. Wake-up Mode

### 6.1 Overview

Wake-up Mode merupakan pengalaman khusus setelah pengguna menekan tombol "Bangun tidur".

Mode ini menggunakan Wake Experience dan bertujuan membantu pengguna benar-benar bangun.

Wake-up Mode bukan sekadar halaman konfirmasi bahwa sesi tidur telah selesai.

### 6.2 Visual Direction

Wake-up Mode harus terasa lebih terang, segar, dan positif.

Gunakan kombinasi:

- Warm yellow sebagai aksen utama.
- Soft orange sebagai aksen pendukung.
- Crisp sky blue untuk elemen interaktif.
- White sebagai dasar tampilan.

Visual dapat menggunakan ilustrasi matahari, langit pagi, atau elemen natural sederhana.

Ilustrasi bersifat opsional dan tidak boleh membuat tampilan terlalu ramai.

### 6.3 Main Components

Wake-up Mode terdiri dari:

1. Greeting atau pesan sambutan setelah bangun.
2. Informasi bahwa sesi tidur telah selesai.
3. Ringkasan waktu tidur.
4. Durasi tidur yang tercatat.
5. Indikator atau visual Wake-up Mode.
6. Tombol kecil untuk menutup Wake-up Mode.

Tombol penutup harus mudah ditemukan tetapi tidak boleh terlalu dominan.

### 6.4 Vibration Interaction

Getaran merupakan mekanisme utama Wake-up Mode karena aplikasi tidak boleh bergantung pada suara.

Ketentuan:

- Getaran dimulai setelah Wake-up Mode diaktifkan.
- Pola getaran harus terasa jelas tetapi tidak berlebihan.
- Pengguna dapat menghentikan getaran dengan menutup Wake-up Mode.
- Tidak boleh ada getaran tanpa batas waktu.
- Perilaku getaran harus mempertimbangkan lifecycle aplikasi dan batasan Android.
- Getaran harus dihentikan ketika mode ditutup atau aktivitas terkait dihentikan.

Implementasi pola getaran merupakan tanggung jawab integrasi Android dan harus memperhatikan kemampuan perangkat.

### 6.5 Wake-up Mode Ethics

- Jangan membuat pengguna kesulitan keluar dari mode.
- Jangan menyembunyikan tombol penutup.
- Jangan memaksa pengguna menunggu animasi.
- Jangan menggunakan interaksi yang mengganggu atau menghukum pengguna.
- Jangan mengandalkan suara sebagai satu-satunya mekanisme pengingat.
- Jangan menghalangi navigasi sistem Android.

Wake-up Mode harus membantu pengguna, bukan mengontrol pengguna.

## 7. Sleep History

Halaman riwayat menampilkan seluruh sesi tidur yang pernah dicatat.

### 7.1 History List

Setiap item menampilkan:

- Tanggal sesi.
- Waktu mulai.
- Waktu selesai.
- Durasi tidur.
- Status pencatatan.

Gunakan card sederhana dengan hierarki informasi yang jelas.

### 7.2 History Detail

Pengguna dapat membuka sesi untuk melihat informasi lengkap dan melakukan pengeditan.

### 7.3 History Interaction

- Tap card untuk membuka detail.
- Tindakan edit tersedia dari halaman detail.
- Perubahan data harus memiliki feedback.
- Penghapusan data harus meminta konfirmasi.

Halaman riwayat menggunakan Sleep Experience sebagai identitas visual dasar, dengan warna status yang konsisten dan tidak membingungkan.

## 8. Statistics Design

### 8.1 Overview

Halaman statistik membantu pengguna memahami pola tidur berdasarkan data yang telah dikumpulkan.

Statistik tidak boleh memberikan klaim medis atau diagnosis.

### 8.2 Statistic Components

Komponen statistik dapat mencakup:

- Rata-rata durasi tidur.
- Total waktu tidur.
- Waktu mulai tidur rata-rata.
- Waktu bangun rata-rata.
- Jumlah sesi tidur.
- Tren durasi tidur harian.
- Perbandingan durasi tidur berdasarkan periode.

### 8.3 Time Range

Pengguna dapat memilih periode:

- 7 hari.
- 30 hari.
- 90 hari.
- Semua data.

### 8.4 Chart Design

Gunakan visualisasi sederhana yang mudah dipahami.

Jenis visualisasi:

- Bar chart untuk durasi tidur harian.
- Line chart untuk melihat perubahan pola.
- Summary card untuk nilai rata-rata.
- Progress indicator untuk informasi yang relevan.

Aturan:

- Jangan memenuhi halaman dengan grafik.
- Hindari warna yang terlalu banyak.
- Gunakan label dan satuan yang jelas.
- Berikan empty state jika data belum mencukupi.
- Jangan menyimpulkan kualitas tidur secara medis dari data durasi saja.

Halaman statistik menggunakan Sleep Experience sebagai tema dasarnya.

## 9. Settings Design

Halaman pengaturan menyediakan konfigurasi aplikasi.

Pengaturan yang dapat tersedia:

- Preferensi zona waktu.
- Format waktu.
- Pengelolaan data.
- Export data.
- Import data.
- Informasi aplikasi.
- Pengaturan pengalaman getaran jika disediakan.

Tema Sleep dan Wake tidak disediakan sebagai pilihan manual karena keduanya merupakan bagian dari sistem pengalaman berbasis status aplikasi.

## 10. Animation & Motion System

### 10.1 General Principles

Animasi digunakan untuk memperjelas perubahan status dan memberikan feedback interaksi.

Animasi bukan dekorasi utama.

Ketentuan:

- Ringan.
- Halus.
- Tidak menghambat interaksi.
- Tidak menggunakan efek yang terlalu kompleks.
- Tidak mengganggu penggunaan dalam kondisi mengantuk.
- Menghormati pengaturan pengurangan animasi jika tersedia.

### 10.2 Animation Categories

| Interaction          | Animation                   |
| -------------------- | --------------------------- |
| Button tap           | Subtle scale feedback       |
| Card tap             | Slight elevation or scale   |
| Page transition      | Smooth fade and slide       |
| Theme transition     | Color interpolation         |
| Session state change | Subtle content transition   |
| Statistics update    | Smooth chart transition     |
| Bottom navigation    | Active indicator transition |
| Modal opening        | Fade and subtle scale       |
| Loading              | Minimal progress indicator  |

### 10.3 Sleep Animation

Sleep Experience harus memiliki gerakan yang sangat terbatas.

Aturan:

- Tidak ada animasi berkedip.
- Tidak ada gerakan cepat.
- Tidak ada elemen yang terus bergerak tanpa fungsi.
- Hindari animasi dengan perubahan kecerahan yang besar.
- Prioritaskan transisi sederhana dan stabil.

Animasi dekoratif pada sesi tidur aktif sebaiknya tidak digunakan.

### 10.4 Wake Animation

Wake Experience dapat menggunakan animasi yang lebih ekspresif.

Contoh:

- Fade-in untuk greeting.
- Subtle slide untuk ringkasan tidur.
- Smooth transition untuk statistik.
- Gentle scale untuk tombol utama.
- Transisi warna yang lembut ketika Wake-up Mode muncul.

Animasi tetap harus singkat dan tidak menghambat akses ke tombol penutup.

### 10.5 Theme Transition

Perubahan Sleep Experience ke Wake Experience dan sebaliknya harus berlangsung secara halus.

Rekomendasi durasi awal:

| Transition       |   Duration |
| ---------------- | ---------: |
| Color transition | 300–450 ms |
| Component fade   | 180–250 ms |
| Page transition  | 200–300 ms |
| Button feedback  | 100–160 ms |

Durasi tersebut merupakan nilai awal yang dapat disesuaikan saat pengujian.

Ketika berpindah dari Sleep ke Wake:

- Background berubah secara bertahap.
- Surface dan card mengikuti perubahan tema.
- Teks dan ikon berubah tanpa flicker.
- Konten utama muncul dengan transisi sederhana.

Ketika berpindah dari Wake ke Sleep:

- Hindari perubahan yang terasa seperti flash.
- Gunakan transisi yang lebih tenang.
- Jangan menampilkan animasi dekoratif tambahan.

## 11. Component Design Rules

Semua komponen harus mengikuti aturan desain yang konsisten.

### 11.1 Cards

- Memiliki radius sudut konsisten.
- Menggunakan padding yang cukup.
- Tidak menggunakan shadow berlebihan.
- Memiliki hierarki informasi yang jelas.
- Menggunakan warna sesuai design mode.

### 11.2 Buttons

- Area sentuh minimal mengikuti rekomendasi Android, dengan target sekitar 48 dp.
- Label tindakan harus jelas.
- Tombol utama mudah ditemukan.
- Tombol sekunder tidak boleh bersaing dengan tombol utama.
- Berikan feedback visual saat ditekan.

### 11.3 Typography

Gunakan tipografi sans-serif yang mudah dibaca.

Rekomendasi skala awal:

| Style     |  Size |
| --------- | ----: |
| Display   | 32 sp |
| Heading 1 | 24 sp |
| Heading 2 | 20 sp |
| Heading 3 | 18 sp |
| Body      | 16 sp |
| Secondary | 14 sp |
| Caption   | 12 sp |

Aturan:

- Hindari terlalu banyak variasi font.
- Gunakan weight untuk membangun hierarki.
- Informasi penting harus lebih menonjol daripada metadata.
- Jangan menggunakan ukuran kecil untuk informasi utama.
- Dukung perubahan ukuran teks sistem Android.

### 11.4 Icons

- Gunakan ikon yang sederhana dan konsisten.
- Hindari penggunaan terlalu banyak ikon dekoratif.
- Ikon tindakan harus mudah dipahami.
- Gunakan label teks jika fungsi ikon berpotensi ambigu.

### 11.5 Spacing

Gunakan sistem spacing berbasis kelipatan 4 dp.

Nilai dasar:

- 4 dp: jarak sangat kecil.
- 8 dp: jarak antar elemen dekat.
- 12 dp: jarak komponen kecil.
- 16 dp: padding standar.
- 24 dp: jarak antar bagian.
- 32 dp: jarak antar section besar.

Nilai dapat disesuaikan berdasarkan kebutuhan layout.

## 12. Responsive Layout

Frenooze dikembangkan khusus untuk Android.

Desain harus mengutamakan penggunaan pada perangkat mobile dengan orientasi portrait.

### 12.1 Mobile Layout

- Gunakan layout satu kolom sebagai standar.
- Hindari komponen yang terlalu lebar.
- Pastikan tombol utama mudah dijangkau.
- Gunakan bottom navigation untuk navigasi utama.
- Pastikan konten dapat di-scroll dengan nyaman.
- Perhatikan safe area dan system navigation.

### 12.2 Small Screens

Pada perangkat dengan layar kecil:

- Kurangi dekorasi.
- Pertahankan ukuran tombol yang nyaman.
- Hindari teks terpotong.
- Gunakan layout adaptif.
- Jangan memaksakan dua kolom.

### 12.3 Large Screens

Pada perangkat Android dengan layar lebih besar:

- Konten dapat menggunakan batas lebar maksimum.
- Statistik dapat menggunakan dua kolom jika ruang mencukupi.
- Card tetap mempertahankan proporsi dan keterbacaan.
- Hindari memperlebar teks hingga sulit dibaca.

## 13. Accessibility & Usability

Desain Frenooze harus tetap nyaman digunakan oleh berbagai kondisi pengguna.

Ketentuan:

- Kontras teks harus memadai pada kedua tema.
- Jangan menyampaikan status hanya melalui warna.
- Gunakan teks atau ikon pendukung untuk status penting.
- Area sentuh harus cukup besar.
- Teks harus mendukung pembesaran sistem.
- Animasi tidak boleh menjadi satu-satunya cara menyampaikan informasi.
- Perhatikan pengaturan reduced motion.
- Tombol penting harus memiliki label aksesibilitas.

Pengguna harus selalu dapat memahami status sesi tidur tanpa bergantung pada interpretasi warna.

## 14. UI Feedback & Interaction States

Komponen interaktif harus memiliki kondisi visual yang jelas.

| State    | Behavior                                |
| -------- | --------------------------------------- |
| Default  | Tampilan normal                         |
| Pressed  | Feedback visual ringan                  |
| Disabled | Tampilan redup dan tidak interaktif     |
| Loading  | Indikator proses                        |
| Success  | Konfirmasi sederhana                    |
| Error    | Pesan yang jelas dan tindakan pemulihan |
| Empty    | Penjelasan kondisi tanpa data           |

Feedback tidak boleh menggunakan dialog berulang untuk tindakan yang sederhana.

Untuk operasi penting seperti import atau penghapusan data, gunakan konfirmasi yang jelas.

## 15. Design Ethics

Frenooze harus menghormati kondisi fisik dan perhatian pengguna.

Prinsip etika desain:

1. **Tidak mengganggu tidur:** aplikasi tidak boleh menghadirkan stimulasi visual yang tidak diperlukan ketika pengguna sedang tidur.
2. **Tidak memaksa interaksi:** pengguna tidak harus menulis catatan atau melewati banyak langkah untuk mencatat tidur.
3. **Tidak memanipulasi pengguna:** jangan menggunakan streak, rasa bersalah, atau pesan negatif untuk memaksa kebiasaan tertentu.
4. **Tidak mengklaim diagnosis:** statistik hanya menyajikan data pencatatan, bukan kesimpulan medis.
5. **Tidak menyembunyikan kontrol:** pengguna selalu dapat mengakhiri Wake-up Mode dan mengakses navigasi sistem.
6. **Menghormati privasi:** data tidur merupakan data pribadi dan harus dikelola secara bertanggung jawab.
7. **Mengutamakan kejelasan:** setiap tindakan dan status harus dapat dipahami pengguna.
8. **Menghormati keterbatasan perangkat:** animasi dan fitur latar belakang tidak boleh mengorbankan baterai secara tidak perlu.

## 16. Performance Guidelines

Desain visual harus mendukung karakter aplikasi yang offline-first dan ringan.

Ketentuan:

- Hindari animasi yang berjalan terus-menerus tanpa kebutuhan.
- Hindari penggunaan blur dan efek visual mahal secara berlebihan.
- Gunakan aset visual yang ringan.
- Hindari rebuild komponen yang tidak diperlukan.
- Perbarui durasi sesi berdasarkan timestamp, bukan timer polling yang terus berjalan.
- Gunakan animasi hanya ketika ada perubahan state atau interaksi.
- Pastikan transisi tema tidak menyebabkan flicker.

## 17. Design Acceptance Criteria

Desain dianggap memenuhi spesifikasi apabila:

### Sleep Experience

- Dashboard normal menggunakan tema gelap.
- Card "Saya mau tidur" menggunakan tema gelap.
- Sesi tidur aktif menggunakan tema gelap.
- Warna soft blue, sage green, warm dark, dan black digunakan secara konsisten.
- Tidak ada animasi mencolok selama sesi tidur aktif.

### Wake Experience

- Wake-up Mode menggunakan tema terang.
- Sesi tidur selesai menggunakan tema terang.
- Warna warm yellow, soft orange, crisp sky blue, dan white digunakan secara konsisten.
- Informasi hasil tidur mudah dibaca.
- Tombol penutup Wake-up Mode mudah ditemukan.
- Getaran dapat dihentikan ketika mode ditutup.

### General UI

- Seluruh halaman memiliki konsistensi desain.
- Navigasi mudah dipahami.
- Komponen responsif terhadap ukuran layar.
- Kontras dan aksesibilitas diperhatikan.
- Animasi berjalan lancar dan tidak menghambat interaksi.
- Aplikasi tetap nyaman digunakan pada perangkat Android dengan sumber daya terbatas.

---

## 18. Final Design Direction

Frenooze memiliki dua pengalaman yang saling melengkapi:

**Sleep Experience — Calm & Restful**

Suasana gelap, natural, hangat, dan minim stimulasi. Pengguna dapat memulai tidur dan membiarkan aplikasi mencatat sesi tanpa gangguan.

**Wake Experience — Fresh & Energizing**

Suasana terang, hangat, dan menyegarkan. Pengguna mendapatkan pengalaman bangun yang positif, ringkasan tidur yang jelas, dan bantuan melalui getaran.

Keduanya harus terasa seperti satu aplikasi yang memiliki identitas visual konsisten, bukan dua aplikasi berbeda yang digabungkan.

Prinsip utama Frenooze adalah:

**"Let users sleep peacefully, and wake up gently."**
