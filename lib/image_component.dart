import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:rpgmap/game.dart';

class ImageComponent extends PositionComponent
    with HasGameRef<RpgMapGame>, Draggable {
  ImageComponent(this.image, {Vector2? size, Anchor? anchor})
      : super(size: size ?? Vector2.all(64), anchor: anchor ?? Anchor.center);

  final Image image;

  @override
  Future<void>? onLoad() {
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawImageRect(
      image,
      size.toRect(),
      size.toRect(),
      Paint()..color = const Color(0xFFFFFFFF),
    );
  }

  @override
  bool onDragStart(DragStartInfo info) {
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    game.cameraTarget -= info.delta.game;
    return false;
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    return false;
  }
}
