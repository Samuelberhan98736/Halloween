
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';
import 'dart:async';

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
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Splash Screen with animated entrance
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
      duration: const Duration(seconds: 2),
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
    // In production, use: await _bgPlayer.play(AssetSource('sounds/background.mp3'));
    // For now, this is a placeholder
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
              const Color(0xFF1a0a2e),
              const Color(0xFF3d1f5c),
              const Color(0xFF1a0a2e),
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
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        '🎃 Spooktacular Storybook 🎃',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.deepOrange,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 60),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StoryPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
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

// Main Story/Game Page
class StoryPage extends StatefulWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> with TickerProviderStateMixin {
  final List<SpookyObject> _objects = [];
  final Random _random = Random();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _gameWon = false;
  int _score = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeObjects();
    _startAnimation();
  }

  void _initializeObjects() {
    // Create 8 trap objects and 1 winning object
    final icons = [
      Icons.psychology, // Ghost trap
      Icons.bug_report, // Spider trap
      Icons.visibility, // Eye trap
      Icons.cloud, // Cloud trap
      Icons.water_drop, // Potion trap
      Icons.local_fire_department, // Fire trap
      Icons.ac_unit, // Ice trap
      Icons.bolt, // Lightning trap
    ];

    for (int i = 0; i < 8; i++) {
      _objects.add(SpookyObject(
        id: i,
        icon: icons[i],
        isTrap: true,
        position: Offset(
          _random.nextDouble() * 0.8,
          _random.nextDouble() * 0.8,
        ),
        color: Colors.purple,
      ));
    }

    // Add the winning candy
    _objects.add(SpookyObject(
      id: 8,
      icon: Icons.cake,
      isTrap: false,
      position: Offset(
        _random.nextDouble() * 0.8,
        _random.nextDouble() * 0.8,
      ),
      color: Colors.orange,
    ));

    _objects.shuffle();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_gameWon && mounted) {
        setState(() {
          for (var obj in _objects) {
            obj.updatePosition(_random);
          }
        });
      }
    });
  }

  void _handleObjectTap(SpookyObject obj) async {
    if (_gameWon) return;

    if (obj.isTrap) {
      // Play jump scare sound
      // await _sfxPlayer.play(AssetSource('sounds/scream.mp3'));
      setState(() {
        _score = max(0, _score - 10);
      });
      _showTrapDialog();
    } else {
      // Play success sound
      // await _sfxPlayer.play(AssetSource('sounds/success.mp3'));
      setState(() {
        _gameWon = true;
        _score += 100;
      });
      _showWinDialog();
    }
  }

  void _showTrapDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '👻 BOO! 👻',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'That was a trap! Try again!',
          style: TextStyle(fontSize: 18, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.orange.withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '🎉 You Found It! 🎉',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'You found the magical candy!',
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $_score',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StoryPage(),
                ),
              );
            },
            child: const Text(
              'Play Again',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SplashScreen(),
                ),
              );
            },
            child: const Text(
              'Main Menu',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _sfxPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find the Magical Candy! 🍬'),
        backgroundColor: Colors.deepPurple,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Score: $_score',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              const Color(0xFF2d1b4e),
              const Color(0xFF1a0a2e),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating stars/sparkles
            ...List.generate(20, (index) {
              return Positioned(
                left: _random.nextDouble() * size.width,
                top: _random.nextDouble() * size.height,
                child: TwinklingStars(delay: index * 200),
              );
            }),
            // Spooky objects
            ..._objects.map((obj) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 50),
                left: obj.position.dx * size.width,
                top: obj.position.dy * size.height,
                child: GestureDetector(
                  onTap: () => _handleObjectTap(obj),
                  child: SpookyObjectWidget(object: obj),
                ),
              );
            }).toList(),
            // Instructions
            if (!_gameWon)
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Tap objects to find the magical candy!\nBeware of traps! 👻',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Spooky Object Model
class SpookyObject {
  final int id;
  final IconData icon;
  final bool isTrap;
  Offset position;
  Offset velocity;
  final Color color;

  SpookyObject({
    required this.id,
    required this.icon,
    required this.isTrap,
    required this.position,
    required this.color,
  }) : velocity = Offset(
          (Random().nextDouble() - 0.5) * 0.002,
          (Random().nextDouble() - 0.5) * 0.002,
        );

  void updatePosition(Random random) {
    position += velocity;

    // Bounce off edges
    if (position.dx <= 0 || position.dx >= 0.85) {
      velocity = Offset(-velocity.dx, velocity.dy);
      position = Offset(position.dx.clamp(0, 0.85), position.dy);
    }
    if (position.dy <= 0 || position.dy >= 0.85) {
      velocity = Offset(velocity.dx, -velocity.dy);
      position = Offset(position.dx, position.dy.clamp(0, 0.85));
    }

    // Occasionally change direction
    if (random.nextDouble() < 0.02) {
      velocity = Offset(
        (random.nextDouble() - 0.5) * 0.002,
        (random.nextDouble() - 0.5) * 0.002,
      );
    }
  }
}

// Spooky Object Widget with animations
class SpookyObjectWidget extends StatefulWidget {
  final SpookyObject object;

  const SpookyObjectWidget({Key? key, required this.object}) : super(key: key);

  @override
  State<SpookyObjectWidget> createState() => _SpookyObjectWidgetState();
}

class _SpookyObjectWidgetState extends State<SpookyObjectWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000 + Random().nextInt(1000)),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.object.color.withOpacity(0.3),
            boxShadow: [
              BoxShadow(
                color: widget.object.color,
                blurRadius: 20 * _glowAnimation.value,
                spreadRadius: 5 * _glowAnimation.value,
              ),
            ],
          ),
          child: Icon(
            widget.object.icon,
            size: 35,
            color: widget.object.color,
          ),
        );
      },
    );
  }
}

// Twinkling Stars Background Effect
class TwinklingStars extends StatefulWidget {
  final int delay;

  const TwinklingStars({Key? key, required this.delay}) : super(key: key);

  @override
  State<TwinklingStars> createState() => _TwinklingStarsState();
}

class _TwinklingStarsState extends State<TwinklingStars>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500 + Random().nextInt(1500)),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value * 0.7,
          child: Container(
            width: 3,
            height: 3,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}