import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/task_manager/models/api_response.dart';
import 'package:task_manager/task_manager/screens/login_screen.dart';
import 'package:task_manager/task_manager/screens/main_nav_screen.dart';
import 'package:task_manager/task_manager/service/api_caller.dart';
import 'package:task_manager/task_manager/utils/urls.dart';
import 'package:task_manager/task_manager/widgets/screen_bg.dart';

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

  Future<void> onTapSignUP() async {
    // Form validation
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration Successful')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.errorMessage ?? 'Registration Failed')),
      );
    }
  }

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),

                  Text(
                    'Join With Us',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 25),

                  // Email
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

                  // First Name
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(hintText: 'First Name'),
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

                  // Last Name
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(hintText: 'Last Name'),
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

                  // Mobile
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

                  // Password
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

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isLoading ? null : onTapSignUP,
                      child: isLoading
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )

                          : const Icon(Icons.arrow_forward_ios_sharp, size: 30),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Sign In
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already Have an Account? ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = onTapSignIn,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
