import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flutter/rendering.dart';
import 'package:rpgmap/game.dart';
import 'package:rpgmap/wall.dart';

class Player extends PositionComponent with HasGameRef<MyGame>, Draggable {
  Player(Color color)
      : playerPainter = Paint()
          ..color = color
          ..style = PaintingStyle.fill,
        super(size: Vector2.all(64), anchor: Anchor.center);

  final overlayPainter = Paint()..color = const Color(0xff666666);
  final rayPainter = Paint()
    ..color = const Color(0xFFFFFFFF)
    ..strokeWidth = 2;
  final blackFilledPainter = Paint()
    ..color = const Color(0xFF000000)
    ..style = PaintingStyle.fill;

  Paint playerPainter;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final c = (size / 2).toOffset();
    final ray = Vector2(-1, 1).normalized();
    const nrays = 3000;
    const step = 6.283185307 / nrays;
    final rays = <Offset>[];

    for (var n = 0; n < nrays; n++) {
      final xp = position.x;
      final yp = position.y;
      final dx = ray.x;
      final dy = ray.y;

      var xmin = double.infinity;
      var ymin = double.infinity;
      var dmin = double.infinity;

      for (final wall in [
        ...game.walls,
        Wall()
          ..start = Vector2.zero()
          ..end = Vector2(game.imageComponent.size.x, 0),
        Wall()
          ..start = Vector2(game.imageComponent.size.x, 0)
          ..end =
              Vector2(game.imageComponent.size.x, game.imageComponent.size.y),
        Wall()
          ..start =
              Vector2(game.imageComponent.size.x, game.imageComponent.size.y)
          ..end = Vector2(0, game.imageComponent.size.y),
        Wall()
          ..start = Vector2(0, game.imageComponent.size.y)
          ..end = Vector2.zero(),
      ]) {
        final x1 = wall.start.x;
        final y1 = wall.start.y;
        final x2 = wall.end.x;
        final y2 = wall.end.y;

        final t = ((xp - x1) * (y2 - y1) - (yp - y1) * (x2 - x1)) /
            (dy * (x2 - x1) - dx * (y2 - y1));
        final u = ((xp - x1) * dy - (yp - y1) * dx) /
            ((x2 - x1) * dy - (y2 - y1) * dx);

        if (u >= 0 && u <= 1 && t >= 0) {
          final x = x1 + u * (x2 - x1);
          final y = y1 + u * (y2 - y1);

          if (t < dmin) {
            dmin = t;
            xmin = x;
            ymin = y;
          }
        }
      }

      if (dmin < double.infinity) {
        final v = Offset(xmin, ymin) - position.toOffset();
        rays.add(v);
      }

      ray.rotate(step);
    }

    if (rays.isNotEmpty) {
      canvas
        ..saveLayer(null, Paint()..blendMode = BlendMode.multiply)
        ..drawRect(
          Rect.fromLTWH(
            game.cameraTarget.x - position.x + size.x / 2,
            game.cameraTarget.y - position.y + size.y / 2,
            game.size.x,
            game.size.y,
          ),
          overlayPainter,
        );
      for (final ray in rays) {
        canvas.drawLine(
          c,
          c + ray,
          rayPainter,
        );
      }
      canvas.restore();
    }
    canvas
      ..drawCircle(
        c,
        20,
        blackFilledPainter,
      )
      ..drawCircle(
        c,
        16,
        playerPainter,
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
        c,
        16,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
  }
}
