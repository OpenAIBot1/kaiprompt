import 'package:fluro/fluro.dart';
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

final router = FluroRouter();

void defineRoutes(FluroRouter router) {
  // Auth routes
  router.define("/auth/login",
      handler: Handler(handlerFunc: (_, __) => LoginScreen()));
  router.define("/auth/signup",
      handler: Handler(handlerFunc: (_, __) => SignupScreen()));
  router.define("/auth/forgot-password",
      handler: Handler(handlerFunc: (_, __) => ForgotPasswordScreen()));
  router.define("/auth/password-reset",
      handler: Handler(handlerFunc: (_, __) => PasswordResetScreen()));

  // Error routes
  router.define("/error",
      handler: Handler(handlerFunc: (_, __) => ErrorScreen()));

  // Home routes
  router.define("/home/loading",
      handler: Handler(handlerFunc: (_, __) => LoadingScreen()));
  router.define("/home/catalogue",
      handler: Handler(handlerFunc: (_, __) => CatalogueMainScreen()));

  // Profile routes
  router.define("/profile/view",
      handler: Handler(handlerFunc: (_, __) => ProfileViewScreen()));

  // Prompt routes
  router.define("/prompt/details",
      handler: Handler(handlerFunc: (_, __) => PromptDetailsScreen()));
  router.define("/prompt/main-editing",
      handler: Handler(handlerFunc: (_, __) => PromptMainEditingScreen()));
  router.define("/prompt/publishing",
      handler: Handler(handlerFunc: (_, __) => PromptPublishingScreen()));

  // Support routes
  router.define("/support/main",
      handler: Handler(handlerFunc: (_, __) => SupportMainScreen()));
  router.define("/support/contributors",
      handler: Handler(handlerFunc: (_, __) => ContributorsScreen()));

  // Contact routes
  router.define("/contact/form",
      handler: Handler(handlerFunc: (_, __) => ContactFormScreen()));
  router.define("/contact/confirmation",
      handler: Handler(handlerFunc: (_, __) => ConfirmationScreen()));

  // About routes
  router.define("/about/future-plans",
      handler: Handler(handlerFunc: (_, __) => AboutFuturePlansScreen()));
  router.define("/about/service-agreement",
      handler: Handler(handlerFunc: (_, __) => ServiceAgreementScreen()));
}
