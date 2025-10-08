
import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color darkPurple = Color(0xFF1a0a2e);
  static const Color mediumPurple = Color(0xFF3d1f5c);
  static const Color deepPurple = Color(0xFF2d1b4e);
  static const Color spookyOrange = Colors.orange;
  static const Color trapPurple = Colors.purple;
  
  // Game Settings
  static const int numberOfTraps = 8;
  static const int trapPenalty = 10;
  static const int winScore = 100;
  static const int objectSize = 60;
  static const int starCount = 20;
  
  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration objectUpdateInterval = Duration(milliseconds: 50);
  static const Duration trapDialogDuration = Duration(seconds: 1);
  
  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: spookyOrange,
    shadows: [
      Shadow(
        blurRadius: 10.0,
        color: Colors.deepOrange,
        offset: Offset(0, 0),
      ),
    ],
  );
  
  static const TextStyle scoreStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}