import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecoverVerifyEmail extends StatefulWidget {
  const RecoverVerifyEmail({super.key});

  @override
  State<RecoverVerifyEmail> createState() => _RecoverVerifyEmailState();
}

class _RecoverVerifyEmailState extends State<RecoverVerifyEmail> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Center(
              child: Opacity(
                opacity: 0.2,
                child: SvgPicture.asset(
                  'assets/images/logo/background.svg',
                  width: 250,
                ),
              ),
            ),

            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Verify Email',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'A 6 digit code will be sent to this email',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          String email = emailController.text.trim();

                          if (email.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter your email'),
                              ),
                            );
                            return;
                          }

                          // এখানে Verify Email API call করবেন
                        },
                        child: const Text('Send Code'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}