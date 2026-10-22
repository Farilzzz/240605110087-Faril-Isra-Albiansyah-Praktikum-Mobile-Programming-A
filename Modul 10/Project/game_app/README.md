# game_app

Nama: Faril Isra Albiansyah
NIM: 240605110087
Kelas: Mobile Programming Practikum A

## Deskripsi

Katalog dan detail game dari API eksternal menggunakan http, model JSON, named route, readmore, serta kode hasil json_serializable.

## Package dan aset

- Dependency tambahan: http ^1.1.0, json_annotation ^4.9.0, readmore ^2.2.0, cupertino_icons ^1.0.8.
- Aset pubspec: tidak ada aset khusus yang dideklarasikan.

## Struktur penting

- `lib/main.dart`
- `lib/model/detailgame.dart`
- `lib/model/game.dart`
- `lib/view/detail.dart`
- `lib/view/home.dart`
- `lib/viewmodel/detailgame.g.dart`
- `lib/viewmodel/fetchgame.dart`

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

[Laporan Praktikum Modul 10](../../Laporan Praktikum Modul 10.pdf)
