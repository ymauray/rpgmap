import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:rpgmap/game.dart';

class ShaderComponent extends PositionComponent with HasGameRef<RpgMapGame> {
  ShaderComponent() : super(position: Vector2.zero());

  double time = 0;

  @override
  void update(double dt) {
    time += dt;
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    final resolution = Vector2(gameRef.size.x, gameRef.size.y);
    final uniformFloats = <double>[resolution.x, resolution.y, time];

    final shader = gameRef.program.shader(
      floatUniforms: Float32List.fromList(uniformFloats),
    );

    final paint = Paint()..shader = shader;

    canvas.drawRect(
      Rect.fromLTWH(
        gameRef.cameraTarget.x,
        gameRef.cameraTarget.y,
        gameRef.size.x,
        gameRef.size.y,
      ),
      paint,
    );
  }
}
