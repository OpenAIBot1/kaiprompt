import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:fluro/fluro.dart';
import 'package:kaiprompt/config/routes.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kaiprompt/utils/logger.dart';
import 'package:kaiprompt/services/auth_service.dart';
// import 'package:kaiprompt/screens/home/loading_screen.dart';

class SignupScreen extends HookConsumerWidget {
  // Variables to hold user input
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final isLoadingProvider = StateProvider<bool>((ref) => false);

  SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Getting the auth service provider
    final auth = ref.read(authServiceProvider.notifier);
    final bool isLoading = ref.watch(isLoadingProvider);

    // Store the context in a variable before the asynchronous operation
    final scaffoldContext = ScaffoldMessenger.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
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
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : Text("Sign Up"),
                    onPressed: () async {
                      ref.read(isLoadingProvider.notifier).state = true;
                      var response = await auth.register(
                          _emailController.text, _passwordController.text);

                      if (response.isSuccess) {
                        logger.i("User registered");
                        Future.delayed(Duration.zero, () {
                          context.go("/");
                        });
                      } else {
                        logger.e("Failed to register:");
                        ref.read(isLoadingProvider.notifier).state = false;
                        scaffoldContext.showSnackBar(SnackBar(
                            duration: const Duration(seconds: 5),
                            showCloseIcon: true,
                            content: Text(
                                response.error ?? "Unknown error occurred")));
                        // Display error message to the user
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Navigation to other screens
                  TextButton(
                    child: Text("Already have an account? Sign In"),
                    onPressed: () {
                      // Navigate to Sign In screen
                      context.go("/auth/login");
                    },
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
