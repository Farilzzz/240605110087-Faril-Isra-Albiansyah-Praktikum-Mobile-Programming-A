import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alignment',
      home: Scaffold(
        appBar: AppBar(title: Text('Alignment')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              const Text(
                'Malang',
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 30),
              const Text(
                '25°',
                style: TextStyle(fontSize: 75, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center, 
                    children: const [
                      Text('Minggu', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Icon(Icons.sunny, size: 40),
                      SizedBox(height: 10),
                      Text('20°C', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text('Senin', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Icon(Icons.cloudy_snowing, size: 40),
                      SizedBox(height: 10),
                      Text('23°C', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text('Selasa', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Icon(Icons.cloud, size: 40),
                      SizedBox(height: 10),
                      Text('22°C', style: TextStyle(fontSize: 16)),
                    ],
                  ),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.thumb_up, color: Colors.white, size: 40),
    );
  }
}

class KotakBiruJempolKecil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.thumb_up, color: Colors.white, size: 40),
    );
  }
}
