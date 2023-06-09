import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:fluro/fluro.dart';
import 'package:kaiprompt/config/routes.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:kaiprompt/services/auth_service.dart';

final logger = Logger();

class LoginScreen extends HookConsumerWidget {
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
              // Sign In button
              ElevatedButton(
                child: Text("Sign In"),
                onPressed: () async {
                  bool success = await auth.signIn(
                      _emailController.text, _passwordController.text);
                  if (success) {
                    logger.i("User signed in");
                    Future.delayed(Duration.zero, () {
                      router.navigateTo(context, "/home/catalogue",
                          replace: true, clearStack: true);
                    });
                  } else {
                    logger.e("Failed to sign in");
                    //TODO: Display pop up with the error to the user
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Sign In with Google"),
                onPressed: () async {
                  bool success = await auth.signInWithGoogle();
                  if (success) {
                    logger.i("User signed in with Google");
                    Future.delayed(Duration.zero, () {
                      router.navigateTo(context, "/home/catalogue",
                          replace: true, clearStack: true);
                    });
                  } else {
                    logger.e("Failed to sign in with Google");
                    // Display error message to the user
                  }
                },
              ),
              // Navigation to other screens
              TextButton(
                child: Text("Sign Up"),
                onPressed: () {
                  // Navigate to Sign Up screen
                  router.navigateTo(context, "/auth/signup");
                },
              ),
              TextButton(
                child: Text("Forgot Password?"),
                onPressed: () {
                  // Navigate to Forgot Password screen
                  router.navigateTo(context, "/auth/forgot-password");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
