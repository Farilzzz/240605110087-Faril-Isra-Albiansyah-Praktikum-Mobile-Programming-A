import 'package:flutter/material.dart';

class TujuanPage extends StatelessWidget {
  const TujuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        automaticallyImplyLeading: false, 
        title: const Text(
          'Ini Halaman Tujuan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      // 1. Hapus SingleChildScrollView, gunakan Padding langsung
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            const Text(
              'Untuk berpindah ke halaman baru, gunakan metode Navigator.push(). Metode push() akan menambahkan Route ke dalam tumpukan Route yang dikelola oleh Navigator. Route ini dapat dibuat secara kustom atau menggunakan MaterialPageRoute, yang memiliki animasi transisi sesuai dengan platform yang digunakan.',
              style: TextStyle(color: Colors.white, fontSize: 14), // Font sedikit diperkecil
              textAlign: TextAlign.justify,
            ),
            
            // 2. Gunakan Spacer() sebagai pengganti SizedBox(height: ...)
            const Spacer(), 
            
            Container(
              padding: const EdgeInsets.all(15), // Padding ikon sedikit dikurangi
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                'assets/icon/island.png', 
                width: 90, 
                height: 90,
                fit: BoxFit.contain,
              ),
            ),
            
            const Spacer(),
            
            const Text(
              'Untuk menutup halaman kedua dan kembali ke halaman pertama, gunakan metode Navigator.pop(). Metode pop() akan menghapus Route saat ini dari tumpukan Route yang dikelola oleh Navigator.',
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.justify,
            ),
            
            const Spacer(),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                '< Kembali ke home',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            
            // Tambahan sedikit jarak di bawah tombol agar tidak terlalu menempel ke ujung bawah layar
            const SizedBox(height: 10), 
          ],
        ),
      ),
    );
  }
}