import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Row And Column',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Row And Column')
          ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KotakBiruJempol(warnaKotak: Colors.blue, text: 'biru'),
                  SizedBox(width: 20),
                  KotakBiruJempol(warnaKotak: Colors.green, text: 'hijau'),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KotakBiruJempol(warnaKotak: Colors.white, text: 'putih'),
                  SizedBox(width: 20),
                  KotakBiruJempol(warnaKotak: Colors.orange, text: 'oranye'),
                ],
              ),

            ],
          ),
        ),
      ),  
    );
  }
}

class KotakBiruJempol extends StatelessWidget {
  final Color warnaKotak;
  final String text;

  const KotakBiruJempol({super.key, required this.warnaKotak, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration : BoxDecoration(
        color: warnaKotak,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite,
            color: Colors.red,
            size: 40,
          ),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      );
  }
}