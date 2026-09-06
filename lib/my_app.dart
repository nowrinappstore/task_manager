import 'package:flutter/material.dart';
import 'package:task_manager/task_manager/screens/splash_screen.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme:ThemeData(
        textTheme: TextTheme(titleLarge: TextStyle(fontSize: 28,fontWeight: FontWeight.w600),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,

          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        filledButtonTheme:FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.green,
            fixedSize: Size.fromWidth(double.maxFinite),
            padding: EdgeInsets.symmetric(
                vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            )
          )
        ) 
      ) ,
      home: SplashScreen(),
    );

  }
}