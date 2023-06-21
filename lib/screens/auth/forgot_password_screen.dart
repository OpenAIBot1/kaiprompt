import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:kaiprompt/services/auth_service.dart';

final logger = Logger();

class ForgotPasswordScreen extends HookConsumerWidget {
  // Variables to hold user input
  final _emailController = TextEditingController();

  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Getting the auth service provider
    final auth = ref.read(authServiceProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Reset Password button
              ElevatedButton(
                child: Text("Reset Password"),
                onPressed: () async {
                  bool success = await auth
                      .resetPassword(_emailController.text)
                      .then((value) => value.isSuccess);
                  if (success) {
                    logger.i("Password reset email sent");
                  } else {
                    logger.e("Failed to send password reset email");
                    // Display error message to the user
                  }
                },
              ),
              // Navigation to other screens
              TextButton(
                child: Text("Sign In"),
                onPressed: () {
                  // Navigate to Sign In screen
                  context.go("/auth/login");
                },
              ),
              TextButton(
                child: Text("Sign Up"),
                onPressed: () {
                  // Navigate to Sign Up screen
                  context.go("/auth/signup");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
