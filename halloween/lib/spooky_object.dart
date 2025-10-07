// lib/models/spooky_object.dart
import 'package:flutter/material.dart';
import 'dart:math';

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

    // Occasionally change direction randomly
    if (random.nextDouble() < 0.02) {
      velocity = Offset(
        (random.nextDouble() - 0.5) * 0.002,
        (random.nextDouble() - 0.5) * 0.002,
      );
    }
  }

  static List<SpookyObject> generateObjects(Random random) {
    final List<SpookyObject> objects = [];
    
    // Trap icons
    final icons = [
      Icons.psychology,
      Icons.bug_report,
      Icons.visibility,
      Icons.cloud,
      Icons.water_drop,
      Icons.local_fire_department,
      Icons.ac_unit,
      Icons.bolt,
    ];

    // Create trap objects
    for (int i = 0; i < 8; i++) {
      objects.add(SpookyObject(
        id: i,
        icon: icons[i],
        isTrap: true,
        position: Offset(
          random.nextDouble() * 0.8,
          random.nextDouble() * 0.8,
        ),
        color: Colors.purple,
      ));
    }

    // Add winning candy
    objects.add(SpookyObject(
      id: 8,
      icon: Icons.cake,
      isTrap: false,
      position: Offset(
        random.nextDouble() * 0.8,
        random.nextDouble() * 0.8,
      ),
      color: Colors.orange,
    ));

    objects.shuffle();
    return objects;
  }
}