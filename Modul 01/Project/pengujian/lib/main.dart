import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home : Scaffold(
        appBar: AppBar(
          title: const Text('Program Pertamaku'),
        ),
        body: const Center(
          child: Text('Faril Isra Albiansyah', style: TextStyle(fontSize: 24)),
        ),
      )
    );
  }
}