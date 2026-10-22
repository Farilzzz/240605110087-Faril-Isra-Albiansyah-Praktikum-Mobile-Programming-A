# demo_gridview_builder

Nama: Faril Isra Albiansyah
NIM: 240605110087
Kelas: Mobile Programming Practikum A

## Deskripsi

Grid dinamis berbasis GridView.builder yang mengambil artikel kategori teknologi dari `https://jakpost.vercel.app/api/category/business/tech` melalui package http. Alternatif FreeToGame di source adalah kode komentar, bukan endpoint aktif.

## Package dan aset

- Dependency tambahan: http ^1.5.0, cupertino_icons ^1.0.8.
- Aset pubspec: tidak ada aset khusus yang dideklarasikan.

## Struktur penting

- `lib/main.dart`

Folder platform yang tersedia: lib/, test/, android/, ios/, web/, windows/, linux/, macos/.

## Menjalankan

```bash
flutter pub get
flutter devices
flutter run -t lib/main.dart
```

## Batasan

Proyek dipertahankan sesuai hasil praktikum. Fitur jaringan memerlukan koneksi dan ketersediaan API eksternal; proyek lain berfokus pada demonstrasi widget/konsep, bukan aplikasi produksi. Test bawaan dapat masih merefleksikan template awal dan belum tentu sesuai UI yang telah diubah.

## Laporan

[Laporan Praktikum Modul 6](../../Laporan Praktikum Modul 6.pdf)
