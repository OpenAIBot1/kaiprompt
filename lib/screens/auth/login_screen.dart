import 'package:flutter/material.dart';
// import 'package:kaiprompt/config/routes.dart';
import 'package:kaiprompt/services/auth_service.dart';
import 'package:kaiprompt/utils/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends HookConsumerWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final isLoadingProvider = StateProvider<bool>((ref) => false);
  final isLoadingGoogleProvider = StateProvider<bool>((ref) => false);

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authServiceProvider.notifier);
    final isLoading = ref.watch(isLoadingProvider);
    final isLoadingGoogle = ref.watch(isLoadingGoogleProvider);

    // Store the context in a variable before the asynchronous operation
    final scaffoldContext = ScaffoldMessenger.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
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
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : Text("Sign In"),
                    onPressed: () async {
                      ref.read(isLoadingProvider.notifier).state = true;
                      var response = await auth.signIn(
                          _emailController.text, _passwordController.text);
                      if (response.isSuccess) {
                        logger.i("User signed in");
                        Future.delayed(Duration.zero, () {
                          context.go("/");
                        });
                      } else {
                        ref.read(isLoadingProvider.notifier).state = false;
                        logger.e("Failed to sign in");
                        scaffoldContext.showSnackBar(SnackBar(
                            duration: const Duration(seconds: 5),
                            showCloseIcon: true,
                            content: Text(
                                response.error ?? "Unknown error occurred")));
                      }
                    },
                  ),
                  SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      ref.read(isLoadingGoogleProvider.notifier).state = true;
                      var response = await auth.signInWithGoogle();
                      if (response.isSuccess) {
                        logger.i("User signed in with Google");
                        Future.delayed(Duration.zero, () {
                          context.go("/");
                        });
                      } else {
                        ref.read(isLoadingGoogleProvider.notifier).state =
                            false;
                        logger.e("Failed to sign in with Google");
                        // Display error message to the user
                      }
                    },
                    icon: isLoadingGoogle
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : FaIcon(FontAwesomeIcons.google),
                    label: Text("Sign In with Google"),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text("Sign Up"),
                    onPressed: () {
                      // Navigate to Forgot Password screen
                      context.go("/auth/signup");
                    },
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    child: Text("Forgot Password?"),
                    onPressed: () {
                      // Navigate to Forgot Password screen
                      context.go("/auth/forgot-password");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
