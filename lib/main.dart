import 'package:eat_today/Screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // 플러터 내에서 파이어베이스 사용시 호출할 메소드
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: '오늘뭐먹지?',
      home: main_screen(),
      theme: ThemeData(
        fontFamily: 'DnF',
      ),
    ),
  );
}
