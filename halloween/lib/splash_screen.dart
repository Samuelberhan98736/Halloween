// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../routes/app_routes.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final AudioPlayer _bgPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.splashDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
    _playBackgroundMusic();
  }

  void _playBackgroundMusic() async {
    // Uncomment for production with sound files:
    // await _bgPlayer.play(AssetSource('sounds/background.mp3'));
    // await _bgPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void dispose() {
    _controller.dispose();
    _bgPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.darkPurple,
              AppConstants.mediumPurple,
              AppConstants.darkPurple,
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.auto_stories,
                        size: 120,
                        color: AppConstants.spookyOrange,
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        '🎃 Spooktacular Storybook 🎃',
                        style: AppConstants.titleStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 60),
                      ElevatedButton(
                        onPressed: () => AppRoutes.navigateToStory(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.spookyOrange,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Enter if You Dare...',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => AppRoutes.navigateToCredits(context),
                        child: const Text(
                          'About',
                          style: TextStyle(
                            color: AppConstants.spookyOrange,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}