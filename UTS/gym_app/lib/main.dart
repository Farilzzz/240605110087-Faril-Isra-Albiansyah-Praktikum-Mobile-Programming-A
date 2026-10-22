import 'package:flutter/material.dart';
import 'package:gym_app/view/loading_page.dart';
import 'package:gym_app/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const LoadingPage(),
    );
  }
}