// lib/widgets/spooky_object_widget.dart
import 'package:flutter/material.dart';
import 'dart:math';
import '../models/spooky_object.dart';
import '../utils/constants.dart';

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
          width: AppConstants.objectSize.toDouble(),
          height: AppConstants.objectSize.toDouble(),
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