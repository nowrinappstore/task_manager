import 'package:flutter/material.dart';
import 'package:task_manager/task_manager/models/api_response.dart';
import 'package:task_manager/task_manager/screens/login_screen.dart';
import 'package:task_manager/task_manager/screens/main_nav_screen.dart';
import 'package:task_manager/task_manager/service/api_caller.dart';
import 'package:task_manager/task_manager/utils/urls.dart';
import 'package:task_manager/task_manager/widgets/screen_bg.dart';

import '../utils/asset_path.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  // ================= SIGN UP =================
  Future<void> onTapSignUP() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final ApiResponse response = await ApiCaller.postRequest(
        url: TMUrls.signUpURL,
        body: {
          "email": emailController.text.trim(),
          "firstName": firstNameController.text.trim(),
          "lastName": lastNameController.text.trim(),
          "mobile": mobileController.text.trim(),
          "password": passwordController.text,
        },
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.errorMessage ?? 'Registration Failed'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
    }
  }

  // ================= SIGN IN =================
  void onTapSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBG(
        child: SafeArea(
          child: Stack(
            children: [
              // =====================================================
              // CENTER LOGO / WATERMARK
              // =====================================================
              Positioned.fill(
                child: Center(
                  child: Opacity(
                    opacity: 0.15,
                    child: Image.asset(
                      AssetPath.logo,
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // =====================================================
              // FORM
              // =====================================================
              SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),

                      // ================= TITLE =================
                      Text(
                        'Join With Us',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),

                      const SizedBox(height: 25),

                      // ================= EMAIL =================
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(hintText: 'Email'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please Enter Email';
                          }

                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );

                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Please Enter a Valid Email';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 25),

                      // ================= FIRST NAME =================
                      TextFormField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          hintText: 'First Name',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please Enter First Name';
                          }

                          if (value.trim().length < 2) {
                            return 'First Name must be at least 2 characters';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 25),

                      // ================= LAST NAME =================
                      TextFormField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          hintText: 'Last Name',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please Enter Last Name';
                          }

                          if (value.trim().length < 2) {
                            return 'Last Name must be at least 2 characters';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 25),

                      // ================= MOBILE =================
                      TextFormField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(hintText: 'Mobile'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please Enter Mobile Number';
                          }

                          final mobileRegex = RegExp(r'^01[3-9]\d{8}$');

                          if (!mobileRegex.hasMatch(value.trim())) {
                            return 'Please Enter a Valid Mobile Number';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 25),

                      // ================= PASSWORD =================
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'Password'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Password';
                          }

                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // ================= SIGN UP BUTTON =================
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isLoading ? null : onTapSignUP,
                          child: isLoading
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  size: 30,
                                ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ================= SIGN IN =================
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already Have an Account? ',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),

                            GestureDetector(
                              onTap: onTapSignIn,
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
