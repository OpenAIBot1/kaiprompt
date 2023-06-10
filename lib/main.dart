import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kaiprompt/providers/user_provider.dart';
import 'package:kaiprompt/screens/home/catalogue_main_screen.dart';
import 'package:kaiprompt/models/user.dart';
import 'package:kaiprompt/screens/home/loading_screen.dart';
import 'package:kaiprompt/screens/auth/login_screen.dart';
import 'package:kaiprompt/screens/error/error_screen.dart';
import 'firebase_options.dart';
import 'config/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  defineRoutes(router);
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaiprompt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreenWrapper(),
    );
  }
}

class HomeScreenWrapper extends ConsumerWidget {
  const HomeScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserState userState = ref.watch(userProvider);

    if (userState.user == null) {
      return LoginScreen();
    } else {
      return CatalogueMainScreen();
    }
  }
}
