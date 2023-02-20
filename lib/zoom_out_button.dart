import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ZoomOutButton extends PositionComponent with HasGameRef {
  ZoomOutButton()
      : super(
          anchor: Anchor.center,
          position: Vector2.zero(),
          size: Vector2.all(50),
        );

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke;
    canvas
      ..drawRect(size.toRect(), paint)
      ..drawLine(
        Offset(0, size.y / 2),
        Offset(size.x, size.y / 2),
        paint,
      );
  }
}
