import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:rpgmap/game.dart';
import 'package:rpgmap/light_source.dart';

int lastnwalls = 0;
Vector2 lastTarget = Vector2.zero();

const maxWalls = 150;
const maxLightSources = 10;

class ShaderComponent extends PositionComponent with HasGameRef<RpgMapGame> {
  double time = 0;
  List<LightSource> lightSources = <LightSource>[];

  @override
  void update(double dt) {
    time += dt;
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    var nwalls = gameRef.map.walls.length;

    if (nwalls != lastnwalls) {
      debugPrint('nwalls0: $nwalls');
      lastnwalls = nwalls;
    }

    nwalls = nwalls.clamp(0, maxWalls);

    final xRatio = gameRef.map.backgroundSize.x / gameRef.map.viewBox.x;
    final yRatio = gameRef.map.backgroundSize.y / gameRef.map.viewBox.y;

    final resolution = gameRef.size.clone();

    final uniformFloats = <double>[
      resolution.x,
      resolution.y,
      time,
      gameRef.activePlayer.position.x,
      gameRef.activePlayer.position.y,
      nwalls.toDouble(),
    ];

    for (var i = 0; i < nwalls; i++) {
      final wall = gameRef.map.walls[i];
      uniformFloats.addAll([
        wall.start.x * xRatio,
        wall.start.y * yRatio,
        wall.end.x * xRatio,
        wall.end.y * yRatio,
      ]);
    }

    for (var i = nwalls; i < maxWalls; i++) {
      uniformFloats.addAll([
        0.0,
        0.0,
        0.0,
        0.0,
      ]);
    }

    final shader = gameRef.dynamicLightingProgram.fragmentShader();
    for (var i = 0; i < uniformFloats.length; i++) {
      shader.setFloat(i, uniformFloats[i]);
    }

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
