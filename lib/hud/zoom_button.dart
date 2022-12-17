import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:rpgmap/game.dart';

enum ZoomButtonAction { zoomIn, zoomOut }

class ZoomButton extends SpriteComponent with Tappable, HasGameRef<RpgMapGame> {
  ZoomButton(this.action, Vector2 position, Vector2 size, Sprite sprite)
      : super(position: position, size: size, sprite: sprite);

  final ZoomButtonAction action;

  @override
  bool onTapDown(TapDownInfo info) {
    game.camera.zoom += 0.1 * (action == ZoomButtonAction.zoomIn ? 1 : -1);
    return true;
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    super.render(canvas);
    canvas.restore();
  }
}
