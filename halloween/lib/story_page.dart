
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';
import 'dart:async';
import '../spooky_object.dart';
import '../spooky_object_widjet.dart';
import '../twinking_stars.dart';
import '../app_routes.dart';
import '../constants.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> with TickerProviderStateMixin {
  late List<SpookyObject> _objects;
  final Random _random = Random();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _gameWon = false;
  int _score = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _objects = SpookyObject.generateObjects(_random);
    _initializeAudio();
    _startAnimation();
  }

  void _initializeAudio() async {
    try {
      await _sfxPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      await _sfxPlayer.setVolume(1.0);
      print('SFX Player initialized');
    } catch (e) {
      print('SFX initialization error: $e');
    }
  }

  void _startAnimation() {
    _timer = Timer.periodic(AppConstants.objectUpdateInterval, (timer) {
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
      _playSound('asssets/sounds/jump_scare.mp3');
      setState(() {
        _score = max(0, _score - AppConstants.trapPenalty);
      });
      _showTrapDialog();
    } else {
      // Play success sound
      _playSound('asssets/sounds/success.mp3');
      setState(() {
        _gameWon = true;
        _score += AppConstants.winScore;
      });
      _showWinDialog();
    }
  }

  void _playSound(String soundPath) async {
    try {
      print('Attempting to play: $soundPath');
      await _sfxPlayer.stop(); // Stop any current sound
      await _sfxPlayer.setSource(AssetSource(soundPath));
      await _sfxPlayer.resume();
      print('Sound played: $soundPath');
    } catch (e) {
      print('Error playing sound $soundPath: $e');
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
    Future.delayed(AppConstants.trapDialogDuration, () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.spookyOrange.withOpacity(0.95),
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
              AppRoutes.navigateToStory(context);
            },
            child: const Text(
              'Play Again',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              AppRoutes.navigateToSplash(context);
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
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Score: $_score',
                style: AppConstants.scoreStyle,
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              print('Testing sound effect...');
              try {
                await _sfxPlayer.stop();
                await _sfxPlayer.setSource(AssetSource('asssets/sounds/success.mp3'));
                await _sfxPlayer.resume();
                print('Sound effect test completed');
              } catch (e) {
                print('Sound effect test failed: $e');
              }
            },
            icon: const Icon(Icons.volume_up, color: Colors.white),
            tooltip: 'Test Sound',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              AppConstants.deepPurple,
              AppConstants.darkPurple,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating stars
            ...List.generate(AppConstants.starCount, (index) {
              return Positioned(
                left: _random.nextDouble() * size.width,
                top: _random.nextDouble() * size.height,
                child: TwinklingStars(delay: index * 200),
              );
            }),
            // Spooky objects
            ..._objects.map((obj) {
              return AnimatedPositioned(
                duration: AppConstants.objectUpdateInterval,
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
                        color: AppConstants.spookyOrange,
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