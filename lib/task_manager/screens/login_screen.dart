import 'package:flutter/material.dart';

import 'package:task_manager/task_manager/controller/auth_controller.dart';
import 'package:task_manager/task_manager/models/api_response.dart';
import 'package:task_manager/task_manager/models/user_model.dart';
import 'package:task_manager/task_manager/screens/main_nav_screen.dart';
import 'package:task_manager/task_manager/screens/signup_screen.dart';
import 'package:task_manager/task_manager/service/api_caller.dart';
import 'package:task_manager/task_manager/utils/urls.dart';
import 'package:task_manager/task_manager/widgets/screen_bg.dart';

import '../utils/asset_path.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  // ================= SIGN UP =================
  void onTapSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  // ================= LOGIN =================
  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final ApiResponse response = await ApiCaller.postRequest(
        url: TMUrls.loginURL,
        body: {
          "email": emailController.text.trim(),
          "password": passwordController.text,
        },
      );

      if (!mounted) return;

      if (response.isSuccess) {
        final Map<String, dynamic> responseData =
            response.responseData as Map<String, dynamic>;

        // ================= USER DATA =================
        final UserModel model = UserModel.fromJson(responseData['data']);

        // ================= TOKEN =================
        final String token = responseData['token'];

        // ================= SAVE USER DATA =================
        await AuthController.saveUserData(model, token);

        if (!mounted) return;

        // ================= MAIN SCREEN =================
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainNavScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.responseData['message'] ?? 'Invalid email or password',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
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
              // LOGIN FORM
              // =====================================================
              SingleChildScrollView(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 120),

                      // ================= TITLE =================
                      Text(
                        'Get Started With:',
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

                      // ================= LOGIN BUTTON =================
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isLoading ? null : login,
                          child: isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  size: 20,
                                ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ================= FORGET PASSWORD =================
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // Forget password functionality later
                          },
                          child: const Text(
                            'Forget Password..?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ================= SIGN UP =================
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't Have an Account? "),
                            GestureDetector(
                              onTap: onTapSignUp,
                              child: const Text(
                                'Sign Up',
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
