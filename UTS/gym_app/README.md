# gym_app — GET FIT GYM (UTS)

Nama: Faril Isra Albiansyah
NIM: 240605110087
Kelas: Mobile Programming Practikum A

## Deskripsi dan fitur aktual

Aplikasi katalog latihan Flutter bertema gelap yang mengambil data dari **ExerciseDB OSS API**. Endpoint yang dipakai kode adalah `GET https://oss.exercisedb.dev/api/v1/exercises`, dengan parameter `limit` (dibatasi service ke 1–25), `after` untuk cursor pagination, serta filter API yang relevan.

Fitur kode mencakup beranda, library/daftar latihan, kategori fokus, detail latihan dan instruksi, pencarian serta filter lokal pada data yang sudah dimuat, pagination cursor 25 data per permintaan (25 menjadi 50 setelah muat berikutnya), preview GIF dengan fallback bila media gagal, atribusi sumber, dan retry untuk kegagalan jaringan.

## Arsitektur

- `lib/model/exercise_api_model.dart`: model respons JSON latihan.
- `lib/service/exercise_api_service.dart`: HTTP GET, timeout, validasi status/format, penanganan rate limit, dan cursor pagination.
- `lib/view/list_all_exercise_page.dart`: `FutureBuilder<ExerciseApiResponse>` untuk alur asynchronous.
- `lib/view/detail_exercise_page.dart`: informasi dan instruksi detail.
- `lib/view/widgets/exercise_gif_widget.dart`: GIF jaringan dan fallback.
- `lib/controller/`, `lib/theme/`, serta view lain: controller, tema, beranda, kategori/focus, loading, dan profil.

`FutureBuilder` menangani lima keadaan UI: **loading**, **error** dengan Coba Lagi/Retry, **empty**, **data**, dan **load-more error/loading**. Pencarian/filter bersifat lokal atas data yang sudah dimuat, sehingga pengguna perlu menekan Muat Lebih Banyak untuk memperluas cakupan.

## Package, aset, dan atribusi

- `http`: komunikasi ExerciseDB OSS.
- `get`: dependency navigasi/state yang tersedia pada proyek.
- Aset: `assets/images/` dan `assets/data/dummy_gym_app.json`.
- Ketentuan sumber data/media: lihat `EXERCISEDB_ATTRIBUTION.md`. GIF bisa tidak tersedia atau gagal dimuat; UI menyediakan fallback.

## Menjalankan

```bash
flutter pub get
flutter devices
flutter run -t lib/main.dart
```

## Pengujian

```bash
flutter analyze
flutter test
```

Test yang tersedia menguji model API, service API, serta halaman library (`exercise_api_model_test.dart`, `exercise_api_service_test.dart`, `exercise_library_page_test.dart`). Hasil validasi lokal tercatat pada artifact audit di luar repository.

## Batasan

Memerlukan jaringan dan ketersediaan ExerciseDB OSS untuk data nyata. Total server bersifat dinamis dan tidak dianggap jumlah tetap; angka pada laporan adalah kondisi saat screenshot. Filter/pencarian tidak otomatis meminta seluruh katalog. API dapat mengalami timeout, rate limit, data kosong, atau kegagalan GIF.

## Laporan

[Laporan UTS](../Laporan%20UTS.pdf)
