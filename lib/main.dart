import 'package:flutter/material.dart';
import 'timerApp.dart'; // timerApp.dart 파일 임포트

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TimerApp(), // TimerApp 위젯 사용
    );
  }
}
