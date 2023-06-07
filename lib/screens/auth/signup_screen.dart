import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:fluro/fluro.dart';
import 'package:kaiprompt/config/routes.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:kaiprompt/services/auth_service.dart';

final logger = Logger();

class SignupScreen extends HookConsumerWidget {
  // Variables to hold user input
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Sign Up button
              ElevatedButton(
                child: Text("Sign Up"),
                onPressed: () async {
                  bool success = await auth.register(
                      _emailController.text, _passwordController.text);
                  if (success) {
                    logger.i("User registered");
                    Future.delayed(Duration.zero, () {
                      router.navigateTo(context, "/home/catalogue",
                          replace: true, clearStack: true);
                    });
                  } else {
                    logger.e("Failed to register");
                    // Display error message to the user
                  }
                },
              ),
              // Navigation to other screens
              TextButton(
                child: Text("Already have an account? Sign In"),
                onPressed: () {
                  // Navigate to Sign In screen
                  router.navigateTo(context, "/auth/login");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
