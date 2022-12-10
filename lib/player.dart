import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame/src/collisions/hitboxes/shape_hitbox.dart';
import 'package:flame/src/experimental/raycast_result.dart';
import 'package:flutter/rendering.dart';
import 'package:rpgmap/game.dart';

class Player extends PositionComponent with HasGameRef<MyGame>, Draggable {
  Player() : super(size: Vector2.all(64), anchor: Anchor.center);

  List<RaycastResult<ShapeHitbox>> raycastResult = [];
  Color color = const Color(0x00FFFFFF);
  bool hasTarget = false;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final c = (size / 2).toOffset();
    if (raycastResult.isNotEmpty) {
      canvas
        ..saveLayer(null, Paint()..blendMode = BlendMode.multiply)
        ..drawRect(
          Rect.fromLTWH(
            game.cameraTarget.x - position.x + size.x / 2,
            game.cameraTarget.y - position.y + size.y / 2,
            game.size.x,
            game.size.y,
          ),
          Paint()..color = const Color(0xff000000),
        );
      for (final raycast in raycastResult) {
        canvas.drawLine(
          c,
          c +
              ((raycast.intersectionPoint ?? Vector2.zero()) - position)
                  .toOffset(),
          Paint()
            ..color = const Color(0xFFFFFFFF)
            ..strokeWidth = 2,
        );
      }
      canvas.restore();
    }
    canvas
      ..drawCircle(
        c,
        20,
        Paint()
          ..color = const Color(0xFF000000)
          ..style = PaintingStyle.fill,
      )
      ..drawCircle(
        (size / 2).toOffset(),
        16,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
  }

  @override
  bool onDragStart(DragStartInfo info) {
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    position += info.delta.game;
    return false;
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    return false;
  }
}

class PlayerButton extends PositionComponent with HasGameRef<MyGame>, Tappable {
  PlayerButton()
      : super(
          size: Vector2.all(32),
          anchor: Anchor.center,
        ) {
    positionType = PositionType.viewport;
    anchor = Anchor.center;
  }

  Color color = const Color(0x00FFFFFF);
  VoidCallback? onTap;

  @override
  bool onDragStart(DragStartInfo info) {
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    position -= info.delta.game;
    return false;
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    return false;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    return false;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    onTap?.call();
    return false;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final c = (size / 2).toOffset();
    canvas
      ..drawCircle(
        c,
        20,
        Paint()
          ..color = const Color(0xFF000000)
          ..style = PaintingStyle.fill,
      )
      ..drawCircle(
        (size / 2).toOffset(),
        16,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
  }
}
