// Mathew york and Sami Berhan
import 'package:flutter/material.dart';
import 'app_routes.dart';

void main() {
  runApp(const HalloweenStorybookApp());
}

class HalloweenStorybookApp extends StatelessWidget {
  const HalloweenStorybookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spooktacular Storybook',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF1a0a2e),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}