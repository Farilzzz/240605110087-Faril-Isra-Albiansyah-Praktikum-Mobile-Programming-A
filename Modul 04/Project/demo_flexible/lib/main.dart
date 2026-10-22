// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flexible',
//       home: Scaffold(
//         appBar: AppBar(title: Text('Flexible')),
//         body: Column(
//           children: [
//             _kotakUji(Colors.amber, 150, 'Normal'),
//             Flexible(
//               fit: FlexFit.loose,
//               flex: 1,
//               child: _kotakUji(Colors.green, 100, 'Flexible')),
//             Expanded(
//               flex: 2,
//               child: _kotakUji(Colors.blue, 250, 'Expanded')),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class KotakBiruJempolKecil extends StatelessWidget {
//   const KotakBiruJempolKecil({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 75,
//       height: 75,
//       decoration: BoxDecoration(
//         color: Colors.blue,
//         border: Border.all(color: Colors.black, width: 2),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Icon(Icons.thumb_up, color: Colors.white, size: 40),
//     );
//   }
// }

// Container _kotakUji(Color warna, double tinggi, String teks) {
//   return Container(
//     width: double.infinity,
//     height: tinggi,
//     color: warna,
//     alignment: const Alignment(0.0, 0.0),
//     child: Text(
//       teks,
//       style: const TextStyle(fontSize: 30, color: Colors.white),
//     ),
//   );
// }

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pemutar Musik',
      theme: ThemeData.dark(), // Spesifikasi a: Tema gelap
      home: const MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemutar Musik'),
      ),
      body: const Center(
        child: Text(
          'Pemutar Musik',
          style: TextStyle(fontSize: 22, color: Colors.white70),
        ),
      ),
      // Spesifikasi b & c: Control Bar di bagian bawah dengan Container dan padding
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        color: Colors.black54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tombol Shuffle (Menggunakan Expanded)
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.shuffle, color: Colors.white),
                onPressed: () {},
              ),
            ),
            // Tombol Previous (Menggunakan Expanded)
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {},
              ),
            ),
            // Spesifikasi f: Tombol Play menggunakan Flexible (flex: 2, fit: tight) agar lebih besar
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: IconButton(
                iconSize: 48,
                icon: const Icon(Icons.play_circle_fill, color: Colors.white),
                onPressed: () {},
              ),
            ),
            // Tombol Next (Menggunakan Expanded)
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: () {},
              ),
            ),
            // Tombol Repeat (Menggunakan Expanded)
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.repeat, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}