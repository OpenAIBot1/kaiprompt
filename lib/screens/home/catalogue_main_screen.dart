import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiprompt/providers/user_provider.dart';
import 'package:kaiprompt/services/auth_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CatalogueMainScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authServiceProvider.notifier);
    final user = ref.watch(userProvider);
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Text('Catalogue Main Screen'),
          Text('Welcome, id: ${auth.getCurrentUser()!.uid}'),
          Text('Welcome, username: ${user.user?.username ?? 'No username'}'),
          TextButton(
            child: Text("Sign In"),
            onPressed: () {
              // Navigate to Sign In screen
              context.go("/auth/login");
            },
          ),
        ],
      )),
    );
  }
}
