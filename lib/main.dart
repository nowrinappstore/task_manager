import 'package:flutter/material.dart';
import 'package:task_manager/task_manager/screens/login_screen.dart';
import 'package:task_manager/task_manager/screens/main_nav_screen.dart';
import 'package:task_manager/task_manager/screens/splash_screen.dart';


void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
  );
}