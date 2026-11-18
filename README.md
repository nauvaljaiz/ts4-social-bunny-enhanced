# Social Bunny Verified

Mod ini menambahkan tab **Verified** ke aplikasi Social Bunny bawaan *The Sims 4*. Tab **Feed**, **Friends**, dan **Message** tetap menggunakan UI serta fitur asli game.

## Fitur

### Integrasi dengan Social Bunny bawaan

- Menambahkan tab **Verified** setelah tab Message, langsung di dalam panel Social Bunny.
- Mempertahankan Feed, Friends, Message, posting, DM, daftar teman, dan pemilih kontak bawaan.
- Menampilkan tanda centang biru di header Social Bunny selama manfaat langganan aktif.
- Menyaring paket data UI internal agar tidak muncul sebagai posting di Feed.
- Tidak mengganti aplikasi telepon lain atau tuning Social Bunny bawaan.

### Akun dan status Verified

- Membuat akun Social Bunny untuk Sim dengan ID akun dan nama pengguna yang konsisten.
- Menampilkan status langganan, kelayakan, harga, periode tagihan, manfaat, dan aktivitas akun.
- Menyediakan riwayat pembayaran serta pemberitahuan untuk aktivasi, perpanjangan, pembayaran gagal, masa tenggang, pembatalan, hadiah, Boost, dan pencairan pendapatan.
- Menyimpan status per save slot dan Sim. Data tetap tersimpan saat pindah zona, berganti Sim/rumah tangga, atau memuat ulang game.
- Menyimpan data secara atomik, memulihkan salinan cadangan jika file utama rusak, dan tidak menghapus riwayat langganan setelah berakhir.

### Langganan dan pembayaran

- Langganan hanya tersedia untuk Sim yang dikendalikan pemain dan memiliki rumah tangga dengan dana yang dapat diakses.
- Meminta konfirmasi sebelum menarik Simoleon. Pembayaran gagal atau dana tidak cukup tidak akan mengaktifkan langganan.
- Paket bawaan seharga **§250 per 7 hari Sim**; harga dan periode dapat diubah lewat konfigurasi.
- Mendukung perpanjangan otomatis, pengingat, riwayat pembayaran, coba ulang pembayaran, masa tenggang, penangguhan, pembatalan, dan aktivasi kembali.
- Manfaat tetap berlaku selama sisa periode berbayar setelah langganan dibatalkan atau perpanjangan otomatis dimatikan.
- Jika pembayaran perpanjangan gagal, langganan memasuki masa tenggang. Langganan dapat ditangguhkan jika pembayaran tidak diselesaikan.
- Tidak menggunakan pembayaran uang sungguhan; semua transaksi memakai Simoleon.

Status yang ditampilkan: **Not Subscribed**, **Eligible**, **Active**, **Payment Pending**, **Payment Failed**, **Grace Period**, **Cancelled**, **Expired**, dan **Suspended**.

### Manfaat untuk pelanggan aktif

- **Badge biru** di samping nama Sim di Social Bunny.
- **Prioritas Feed:** posting Sim Verified diprioritaskan di Feed, hingga batas prioritas yang dikonfigurasi.
- **Prioritas rekomendasi teman:** Sim Verified dapat diprioritaskan oleh pemilih kontak baru bawaan.
- **Pertumbuhan followers:** bonus awal **+75 followers** saat berlangganan dan bonus **2,5×** pada satu perhitungan harian; bonus tambahan dibatasi maksimal **50 followers per hari Sim**.
- **Batas posting:** maksimal **2 posting dalam 6 jam Sim** untuk mencegah spam; posting setelah batas tidak dibuat.
- **Bonus posting:** posting publik yang berhasil memberi Fame dan dapat memicu reaksi NPC otomatis.
- **Bonus reaksi:** reaksi positif terklasifikasi dapat memberi **+3 followers** dan pendapatan berbasis sentimen.
- **Creator Spotlight / Boost Reach:** kampanye selama **4 jam Sim** dengan hasil followers, reaksi, dan pendapatan dalam gelombang per jam. Tersedia kembali setelah cooldown bawaan **24 jam Sim**.
- **Pendapatan kreator:** pendapatan mengikuti reaksi positif/negatif dan Brand Safety, dibatasi maksimal **§250 per hari Sim** dari posting, reaksi, dan Boost; gunakan **Claim** untuk memindahkan saldo tertunda ke dana rumah tangga.
- **Networking:** menambahkan teman Social Bunny memberi bonus awal hubungan pertemanan.

Nilai manfaat selain harga dan periode paket juga tersedia di konfigurasi `benefits` (lihat contoh di bawah).

## Instalasi

1. Pastikan *High School Years* terpasang, karena aplikasi Social Bunny bawaan diperkenalkan oleh paket tersebut.
2. Salin kedua file dari folder `dist` ke `Documents\Electronic Arts\The Sims 4\Mods\`:
   - `SocialBunnyVerified_UI.package`
   - `SocialBunnyVerified.ts4script`
3. Jangan meletakkan file `.ts4script` lebih dari satu subfolder di dalam folder Mods.
4. Aktifkan **Enable Custom Content and Mods** dan **Script Mods Allowed** di *Game Options → Other*.
5. Jika memperbarui dari versi lama mod, hapus `localthumbcache.package`, lalu buka Social Bunny dari ponsel Sim. Tab **Verified** akan muncul setelah Message.

## Menggunakan tab Verified

1. Buka **Social → Open Social Bunny** dari ponsel Sim.
2. Pilih tab **Verified** untuk melihat harga, kelayakan, status, dan manfaat.
3. Pilih **Subscribe**, periksa konfirmasi, lalu konfirmasikan pembayaran Simoleon.
4. Gunakan tombol pengelolaan untuk mengatur perpanjangan otomatis, membatalkan atau mengaktifkan kembali langganan, mencoba ulang pembayaran, menjalankan Boost, dan mengklaim pendapatan.
5. Periksa riwayat pembayaran dan pemberitahuan di bagian bawah tab.

Retry manual dibatasi satu percobaan per interval retry agar klik berulang tidak memicu tagihan ganda. Retry otomatis hanya berjalan selama grace period; status pembayaran yang masih menunggu konfirmasi tidak akan ditagih ulang otomatis.

## Konfigurasi

Buat file berikut jika ingin mengubah nilai bawaan:

`Documents\Electronic Arts\The Sims 4\Mods\SocialBunnyVerified_Data\verified_config.json`

Contoh mengubah harga, periode pembayaran, dan beberapa manfaat:

```json
{
  "plan": {
    "price": 250,
    "billing_interval_days": 7,
    "grace_period_days": 2,
    "retry_interval_hours": 12,
    "renewal_reminder_hours": 24
  },
  "benefits": {
    "feed_priority_limit": 25,
    "contact_priority_enabled": true,
    "welcome_follower_bonus": 75,
    "follower_growth_multiplier": 2.5,
    "min_daily_follower_gain": 20,
    "reaction_follower_bonus": 3,
    "fame_per_post": 12,
    "boost_duration_hours": 4,
    "boost_cooldown_hours": 24,
    "boost_follower_min": 45,
    "boost_follower_max": 110,
    "boost_payout_base": 60
  },
  "dm_balance": {
    "friendship_bonus_on_add": 1.5
  },
  "credibility": {
    "max_posts_per_window": 2,
    "spam_post_window_hours": 6,
    "base_rpm": 2.5,
    "daily_payout_cap": 250
  }
}
```

Hapus properti yang tidak ingin diubah; nilainya akan memakai default mod. Perubahan konfigurasi dibaca ketika mod dimuat.

## Perintah opsional

Buka konsol cheat game untuk menggunakan:

- `sbv.verified_status` — menampilkan save slot aktif dan jumlah akun langganan/Verified.
- `sbv.verified_tick` — menjalankan pemeriksaan tagihan dan kampanye yang tertunda.
- `sbv.verified_reload` — memuat ulang data Verified untuk save slot aktif.

## Kompatibilitas dan batasan

- Mod hanya mengganti satu resource GFX SocialMedia. Mod UI lain yang mengganti resource GFX yang sama dapat berkonflik.
- `widgetlist.xml`, library UI bersama, tekstur Social Bunny, tuning native, dan aplikasi telepon lain tidak diganti.
- Feed, Friends, Message, posting, DM, dan pemilih native tetap berasal dari game.
- Tagihan menggunakan waktu Sim. Setelah lama tidak bermain, mod memproses tagihan yang jatuh tempo satu periode saat game berjalan kembali; mod tidak menagih semua periode yang terlewat sekaligus.
- Perubahan UI Scaleform perlu diuji di dalam game. Tes otomatis mencakup logika langganan, persistensi, paket, dan komunikasi UI.

## Build dan tes pengembang

Bangun package dan arsip script:

```powershell
python tools\build_packages.py
```

Bangun sekaligus salin file hasil build ke folder Mods:

```powershell
python tools\build_packages.py --deploy
```

Jalankan tes (memerlukan Python 3.7 yang sesuai dengan runtime game):

```powershell
& "C:\Users\nauval jaiz\Documents\the-sims-mods\simstagram\tools\python37\python.exe" tests\run_all_tests.py
```

## Isi folder proyek

- `src/gfx/original/` — salinan GFX asli untuk proses build.
- `src/gfx/decompiled/` — referensi ActionScript hasil dekompilasi.
- `src/gfx/scripts/` — ActionScript yang digunakan untuk membangun UI.
- `src/python/sbv/verified/` — layanan akun, langganan, pembayaran, manfaat, persistensi, dan bridge UI.
- `tools/` — alat audit resource dan build package.
- `tests/` — tes Python dan validasi package.
- `docs/` — dokumentasi arsitektur, kompatibilitas, batasan, dan laporan tes.
- `dist/` — file mod siap dipasang.
