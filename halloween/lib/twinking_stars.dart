// lib/widgets/twinkling_stars.dart
import 'package:flutter/material.dart';
import 'dart:math';

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