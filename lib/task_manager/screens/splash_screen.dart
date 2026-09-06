import 'package:flutter/material.dart';
import 'package:task_manager/task_manager/controller/auth_controller.dart';
import 'package:task_manager/task_manager/screens/login_screen.dart';
import 'package:task_manager/task_manager/screens/main_nav_screen.dart';
import 'package:task_manager/task_manager/utils/asset_path.dart';
import 'package:task_manager/task_manager/widgets/screen_bg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  Future moveToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    AuthController.getUserData();
    bool isLogin = await AuthController.isUserLogin();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isLogin ? MainNavScreen() : LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: ScreenBG(
              child: const SizedBox(),
            ),
          ),

          // Logo - Exactly Center
          Center(
            child: Image.asset(
              AssetPath.logo,
              width: 300,
              height: 300,
            ),
          ),

          // Loading Indicator
          const Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),

          // Version
          const Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Version 1.0.1',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
