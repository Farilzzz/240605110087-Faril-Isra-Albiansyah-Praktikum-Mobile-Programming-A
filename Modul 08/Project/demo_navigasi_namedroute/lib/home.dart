import 'package:flutter/material.dart';

import 'tujuan.dart';
import 'screen_arguments.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ini halaman Home', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 15),
            OutlinedButton(
              onPressed: () {
                final args = ScreenArguments(
                  'Judul Game',
                  'Genre: Action',
                  'Ini adalah deskripsi singkat dari game.',
                );
                Navigator.pushNamed(context, Tujuan.routeName, arguments: args);
              },
              child: const Text('Ke Halaman Tujuan'),
            ),
          ],
        ),
      ),
    );
  }
}
