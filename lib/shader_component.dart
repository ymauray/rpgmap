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
    const nwalls = 7;

    final xRatio = game.map.backgroundSize.x / game.map.viewBox.x;
    final yRatio = game.map.backgroundSize.y / game.map.viewBox.y;

    final resolution = Vector2(
      gameRef.map.backgroundSize.x,
      gameRef.map.backgroundSize.y,
    );

    final uniformFloats = <double>[
      resolution.x,
      resolution.y,
      time,
      game.activePlayer.position.x,
      game.activePlayer.position.y,
      nwalls.toDouble(),
    ];

    for (var i = 0; i < nwalls; i++) {
      final wall = game.map.walls[i];
      uniformFloats.addAll([
        wall.start.x * xRatio,
        wall.start.y * yRatio,
        wall.end.x * xRatio,
        wall.end.y * yRatio,
      ]);
    }
    for (var i = nwalls; i < 10; i++) {
      uniformFloats.addAll([0, 0, 0, 0]);
    }

    //debugPrint(uniformFloats.toString());
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
