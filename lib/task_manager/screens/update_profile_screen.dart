import 'package:flutter/material.dart';
import 'package:task_manager/task_manager/controller/auth_controller.dart';
import 'package:task_manager/task_manager/models/api_response.dart';
import 'package:task_manager/task_manager/models/user_model.dart';
import 'package:task_manager/task_manager/screens/login_screen.dart';
import 'package:task_manager/task_manager/screens/main_nav_screen.dart';
import 'package:task_manager/task_manager/service/api_caller.dart';
import 'package:task_manager/task_manager/utils/urls.dart';
import 'package:task_manager/task_manager/widgets/screen_bg.dart';
import 'package:task_manager/task_manager/widgets/tm_appbar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<UpdateProfileScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> updateProfile() async {
    // Form validation
    if (!formKey.currentState!.validate()) {
      return;
    }
    Map<String,dynamic> requestBody = {
      "email": emailController.text.trim(),
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "mobile": mobileController.text.trim(),

    };

    if (passwordController.text.isNotEmpty){
      requestBody['password'] = passwordController.text;

    }



    final ApiResponse response = await ApiCaller.postRequest(
      url: TMUrls.updateProfileURL,


      body:
        requestBody
    );

    if (response.isSuccess) {
      UserModel model = UserModel(
       sId: AuthController.userData?.sId,
       email: emailController.text,
       firstName: firstNameController.text,
       lastName: lastNameController.text,
       mobile: mobileController.text,

      );
      AuthController.updateUserData(model);
      setState(() {

      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavScreen()));

    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserModel user = AuthController.userData!;

    emailController.text =user.email!;
    firstNameController.text = user.firstName!;
    lastNameController.text = user.lastName!;
    mobileController.text = user.mobile!;
  }

  void onTapSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: ()
          {
            AuthController.clearUserData(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: ScreenBG(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),

                  Text(
                    'Update Profile',
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
                    decoration: const InputDecoration(
                        hintText: 'Password'),

                  ),

                  const SizedBox(height: 20),


                  SizedBox(
                      width: double.maxFinite,
                    child: FilledButton(
                      onPressed: () {
                        updateProfile();

                      },

                      child:const Icon(Icons.arrow_forward_ios_sharp, size: 20,color: Colors.white,
                      ),


                    ),
                  ),
                  const SizedBox(height: 20),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
