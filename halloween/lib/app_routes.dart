// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/story_page.dart';
import '../screens/credits_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String story = '/story';
  static const String credits = '/credits';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      story: (context) => const StoryPage(),
      credits: (context) => const CreditsScreen(),
    };
  }

  static void navigateToStory(BuildContext context) {
    Navigator.pushReplacementNamed(context, story);
  }

  static void navigateToCredits(BuildContext context) {
    Navigator.pushNamed(context, credits);
  }

  static void navigateToSplash(BuildContext context) {
    Navigator.pushReplacementNamed(context, splash);
  }
}