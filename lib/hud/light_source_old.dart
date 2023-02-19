import 'dart:ui';

import 'package:flame/components.dart';
import 'package:rpgmap/game.dart';

class LightSourceOld extends PositionComponent with HasGameRef<RpgMapGame> {
  Vector2 lightPos = Vector2.zero();

  @override
  void render(Canvas canvas) {
    final shader = gameRef.lightSourceProgram.fragmentShader()
      ..setFloat(0, gameRef.map.backgroundSize.x)
      ..setFloat(1, gameRef.map.backgroundSize.y)
      ..setFloat(2, 0)
      ..setFloat(3, lightPos.x)
      ..setFloat(4, lightPos.y);

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
