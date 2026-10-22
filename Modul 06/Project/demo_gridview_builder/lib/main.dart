import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo GridView.builder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Demo GridView.builder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List untuk menyimpan data berita
  List dataBerita = [];

  @override
  void initState() {
    super.initState();

    // Memanggil method untuk mengambil data API
    _ambilData();
  }

  // Method untuk request data dari API
  Future<void> _ambilData() async {
    try {
      final response = await http.get(
        Uri.parse('https://jakpost.vercel.app/api/category/business/tech'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          dataBerita = data['posts'];
        });
      } else {
        throw Exception('Gagal load data');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber, title: Text(widget.title)),

      // GridView.builder menjadi ListView.builder
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.25,
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: dataBerita.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: GridTile(
                footer: SizedBox(
                  height: 65,
                  child: GridTileBar(
                    backgroundColor: Colors.black26.withAlpha(175),
                    title: Text(
                      dataBerita[index]['title'] ?? 'Tanpa judul',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                child: Image(
                  image: NetworkImage(
                    dataBerita[index]['image'] ?? 'http://cdn.pixabay.com/photo/2018/03/17/20/51/white-buildings-3235135__340.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ), // placeholder
      ),
    );
  }
}

//Tugas Praktikum Modul 6

// import 'dart:convert';

// import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;

// void main() {

//   runApp(const MyApp());

// }

// class MyApp extends StatelessWidget {

//   const MyApp({super.key});

//   @override

//   Widget build(BuildContext context) {

//     return MaterialApp(

//       title: 'Daftar Game',

//       theme: ThemeData(

//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),

//         useMaterial3: true,

//       ),

//       home: const MyHomePage(title: 'Daftar Game'),

//     );

//   }

// }

// class MyHomePage extends StatefulWidget {

//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override

//   State<MyHomePage> createState() => _MyHomePageState();

// }

// class _MyHomePageState extends State<MyHomePage> {

//   // List untuk menyimpan data game dari API

//   List dataGame = [];

//   @override

//   void initState() {

//     super.initState();

//     _ambilData();

//   }

//   // Method untuk request data dari API FreeToGame

//  Future<void> _ambilData() async {
//     try {
//       final response = await http.get(
//         Uri.parse('https://www.freetogame.com/api/games'),
//         // Tambahkan headers ini agar tidak diblokir oleh server FreeToGame
//         headers: {
//           "Accept": "application/json",
//           "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64 AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         setState(() {
//           dataGame = data.take(20).toList();
//         });
//       } else {
//         debugPrint('Gagal: Server merespon dengan kode ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Error sistem/jaringan: $e');
//     }
//   }

//   @override

//   Widget build(BuildContext context) {

//     return Scaffold(

//       backgroundColor: Colors.grey.shade100,

//       appBar: AppBar(

//         backgroundColor: Colors.orange,

//         title: Text(widget.title),

//       ),

//       body: ListView.builder(

//         padding: const EdgeInsets.all(10),

//         itemCount: dataGame.length,

//         itemBuilder: (context, index) {

//           return _listItem(

//             dataGame[index]['thumbnail'] ??

//                 'https://via.placeholder.com/150',

//             dataGame[index]['title'] ?? 'Tidak ada judul',

//             dataGame[index]['genre'] ?? 'Tidak ada genre',

//             dataGame[index]['release_date'] ?? 'Tidak ada tanggal',

//           );

//         },

//       ),

//     );

//   }

// }

// // Fungsi tombol aksi sesuai rancangan modul

// Container _tombolBaca() {

//   return Container(

//     padding: const EdgeInsets.symmetric(

//       vertical: 5,

//       horizontal: 15,

//     ),

//     decoration: BoxDecoration(

//       color: Colors.orange,

//       borderRadius: BorderRadius.circular(15),

//     ),

//     child: const Text(

//       'Baca Info',

//       style: TextStyle(color: Colors.white),

//     ),

//   );

// }

// // Fungsi untuk membuat satu item daftar game

// Container _listItem(

//   String url,

//   String judul,

//   String genre,

//   String rilis,

// ) {

//   return Container(

//     padding: const EdgeInsets.all(15),

//     margin: const EdgeInsets.only(bottom: 10),

//     decoration: BoxDecoration(

//       color: Colors.white,

//       borderRadius: BorderRadius.circular(15),

//     ),

//     child: Row(

//       children: [

//         ClipRRect(

//           borderRadius: BorderRadius.circular(5),

//           child: Image.network(

//             url,

//             width: 70,

//             height: 70,

//             fit: BoxFit.cover,

//             errorBuilder: (context, error, stackTrace) {

//               return Container(

//                 width: 70,

//                 height: 70,

//                 color: Colors.grey.shade300,

//                 alignment: Alignment.center,

//                 child: const Icon(Icons.image_not_supported),

//               );

//             },

//           ),

//         ),

//         const SizedBox(width: 10),

//         Expanded(

//           child: Column(

//             crossAxisAlignment: CrossAxisAlignment.start,

//             children: [

//               Text(

//                 judul,

//                 maxLines: 2,

//                 overflow: TextOverflow.ellipsis,

//                 style: const TextStyle(

//                   fontSize: 18,

//                   fontWeight: FontWeight.bold,

//                 ),

//               ),

//               const SizedBox(height: 5),

//               Row(

//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,

//                 crossAxisAlignment: CrossAxisAlignment.end,

//                 children: [

//                   Expanded(

//                     child: Column(

//                       crossAxisAlignment: CrossAxisAlignment.start,

//                       children: [

//                         Text(

//                           genre,

//                           maxLines: 1,

//                           overflow: TextOverflow.ellipsis,

//                           style: const TextStyle(color: Colors.grey),

//                         ),

//                         const SizedBox(height: 2),

//                         Text(

//                           rilis,

//                           maxLines: 1,

//                           overflow: TextOverflow.ellipsis,

//                           style: const TextStyle(color: Colors.grey),

//                         ),

//                       ],

//                     ),

//                   ),

//                   const SizedBox(width: 8),

//                   _tombolBaca(),

//                 ],

//               ),

//             ],

//           ),

//         ),

//       ],

//     ),

//   );

// }
