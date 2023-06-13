import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:kaiprompt/screens/auth/login_screen.dart';
import 'package:kaiprompt/screens/auth/signup_screen.dart';
import 'package:kaiprompt/screens/auth/forgot_password_screen.dart';
import 'package:kaiprompt/screens/auth/password_reset_screen.dart';
import 'package:kaiprompt/screens/error/error_screen.dart';
import 'package:kaiprompt/screens/home/loading_screen.dart';
import 'package:kaiprompt/screens/home/catalogue_main_screen.dart';
import 'package:kaiprompt/screens/profile/profile_view_screen.dart';
import 'package:kaiprompt/screens/prompt/prompt_details_screen.dart';
import 'package:kaiprompt/screens/prompt/prompt_main_editing_screen.dart';
import 'package:kaiprompt/screens/prompt/prompt_publishing_screen.dart';
import 'package:kaiprompt/screens/support/support_main_screen.dart';
import 'package:kaiprompt/screens/support/contributors_screen.dart';
import 'package:kaiprompt/screens/contact/contact_form_screen.dart';
import 'package:kaiprompt/screens/contact/confirmation_screen.dart';
import 'package:kaiprompt/screens/about/about_future_plans_screen.dart';
import 'package:kaiprompt/screens/about/service_agreement_screen.dart';

final router = GoRouter(
    initialLocation: '/',
    // Auth routes
    routes: [
      GoRoute(
        path: "/auth/login",
        pageBuilder: (context, state) => MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        path: "/auth/signup",
        pageBuilder: (context, state) => MaterialPage(child: SignupScreen()),
      ),
      GoRoute(
        path: "/auth/forgot-password",
        pageBuilder: (context, state) =>
            MaterialPage(child: ForgotPasswordScreen()),
      ),
      GoRoute(
        path: "/auth/password-reset",
        pageBuilder: (context, state) =>
            MaterialPage(child: PasswordResetScreen()),
      ),

      // Error routes
      GoRoute(
        path: "/error",
        pageBuilder: (context, state) => MaterialPage(child: ErrorScreen()),
      ),

      // Home routes
      GoRoute(
        path: "/home/loading",
        pageBuilder: (context, state) => MaterialPage(child: LoadingScreen()),
      ),
      GoRoute(
        path: "/",
        pageBuilder: (context, state) =>
            MaterialPage(child: CatalogueMainScreen()),
      ),

      // Profile routes
      GoRoute(
        path: "/profile/view",
        pageBuilder: (context, state) =>
            MaterialPage(child: ProfileViewScreen()),
      ),

      // Prompt routes
      GoRoute(
        path: "/prompt/details",
        pageBuilder: (context, state) =>
            MaterialPage(child: PromptDetailsScreen()),
      ),
      GoRoute(
        path: "/prompt/main-editing",
        pageBuilder: (context, state) =>
            MaterialPage(child: PromptMainEditingScreen()),
      ),
      GoRoute(
        path: "/prompt/publishing",
        pageBuilder: (context, state) =>
            MaterialPage(child: PromptPublishingScreen()),
      ),

      // Support routes
      GoRoute(
        path: "/support/main",
        pageBuilder: (context, state) =>
            MaterialPage(child: SupportMainScreen()),
      ),
      GoRoute(
        path: "/support/contributors",
        pageBuilder: (context, state) =>
            MaterialPage(child: ContributorsScreen()),
      ),

      // Contact routes
      GoRoute(
        path: "/contact/form",
        pageBuilder: (context, state) =>
            MaterialPage(child: ContactFormScreen()),
      ),
      GoRoute(
        path: "/contact/confirmation",
        pageBuilder: (context, state) =>
            MaterialPage(child: ConfirmationScreen()),
      ),

      // About routes
      GoRoute(
        path: "/about/future-plans",
        pageBuilder: (context, state) =>
            MaterialPage(child: AboutFuturePlansScreen()),
      ),
      GoRoute(
        path: "/about/service-agreement",
        pageBuilder: (context, state) =>
            MaterialPage(child: ServiceAgreementScreen()),
      ),
    ]);
