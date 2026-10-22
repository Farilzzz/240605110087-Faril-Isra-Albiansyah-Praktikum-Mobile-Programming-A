import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          'Ini Halaman Home',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      // 1. Hapus SingleChildScrollView, ganti menjadi Padding
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            const Text(
              'Banyak aplikasi memiliki beberapa layar untuk menampilkan informasi yang berbeda. Contohnya, ada layar produk, dan ketika pengguna mengklik produk, akan muncul layar dengan detail produk tersebut.',
              style: TextStyle(color: Colors.white, fontSize: 14), // Ukuran font diperkecil sedikit menjadi 14
              textAlign: TextAlign.justify,
            ),
            
            // 2. Ganti SizedBox(height: 30) dengan Spacer()
            const Spacer(),
            
            // Widget Container untuk kotak ikon Rumah
            Container(
              padding: const EdgeInsets.all(15), // Padding dalam ikon dikurangi sedikit
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                'assets/icon/house.png', // Sesuaikan dengan nama file gambarmu
                width: 90, // Ukuran gambar diperkecil sedikit
                height: 90,
                fit: BoxFit.contain,
              ),
            ),
            
            // 2. Ganti SizedBox(height: 30) dengan Spacer()
            const Spacer(),
            
            const Text(
              'Pertama, kita perlu membuat dua halaman atau "routes" yang ingin kita tampilkan. Selanjutnya, kita gunakan perintah Navigator.push() untuk berpindah dari halaman pertama ke halaman kedua. Ini seperti kita membuka halaman baru. Terakhir, kita bisa kembali dari halaman kedua ke halaman pertama menggunakan Navigator.pop(). Seperti menutup halaman kedua dan kembali ke halaman pertama.',
              style: TextStyle(color: Colors.white, fontSize: 14), // Ukuran font diperkecil sedikit menjadi 14
              textAlign: TextAlign.justify,
            ),
            
            // 2. Ganti SizedBox(height: 30) dengan Spacer()
            const Spacer(),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                // Berpindah ke Halaman Tujuan menggunakan Named Route
                Navigator.pushNamed(context, '/tujuan');
              },
              child: const Text(
                'Ke Halaman tujuan >',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            
            // Tambahan sedikit jarak di bagian paling bawah
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}