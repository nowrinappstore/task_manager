import 'package:flutter/material.dart';
import 'package:task_manager/task_manager/controller/auth_controller.dart';
import 'package:task_manager/task_manager/models/api_response.dart';
import 'package:task_manager/task_manager/models/user_model.dart';
import 'package:task_manager/task_manager/screens/login_screen.dart';
import 'package:task_manager/task_manager/screens/main_nav_screen.dart';
import 'package:task_manager/task_manager/service/api_caller.dart';
import 'package:task_manager/task_manager/utils/urls.dart';
import 'package:task_manager/task_manager/widgets/screen_bg.dart';

import '../utils/asset_path.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  // =========================================================
  // UPDATE PROFILE
  // =========================================================
  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestBody = {
      "email": emailController.text.trim(),
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "phone": mobileController.text.trim(),
    };

    if (passwordController.text.isNotEmpty) {
      requestBody['password'] = passwordController.text;
    }

    try {
      final ApiResponse response = await ApiCaller.postRequest(
        url: TMUrls.updateProfileURL,
        body: requestBody,
      );

      if (!mounted) return;

      if (response.isSuccess) {
        UserModel model = UserModel(
          sId: AuthController.userData?.sId,
          email: emailController.text.trim(),
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          mobile: mobileController.text.trim(),
        );

        AuthController.updateUserData(model);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Updated Successfully')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.errorMessage ?? 'Profile Update Failed'),
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

  // =========================================================
  // INIT
  // =========================================================
  @override
  void initState() {
    super.initState();

    final UserModel user = AuthController.userData!;

    emailController.text = user.email ?? '';
    firstNameController.text = user.firstName ?? '';
    lastNameController.text = user.lastName ?? '';
    mobileController.text = user.mobile ?? '';
  }

  // =========================================================
  // DISPOSE
  // =========================================================
  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // =========================================================
  // LOGOUT
  // =========================================================
  void logout() {
    AuthController.clearUserData(context);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // =========================================================
  // BUILD
  // =========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Update Profile',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),

      // =====================================================
      // BODY
      // =====================================================
      body: ScreenBG(
        child: SafeArea(
          child: Stack(
            children: [
              // =================================================
              // CENTER LOGO / WATERMARK
              // =================================================
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

              // =================================================
              // FORM
              // =================================================
              SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      Text(
                        'Update Profile',
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
                        decoration: const InputDecoration(
                          hintText: 'New Password',
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ================= UPDATE BUTTON =================
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isLoading ? null : updateProfile,
                          child: isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  size: 20,
                                  color: Colors.white,
                                ),
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
