import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:rpg_map/rpg_map.dart';
import 'package:rpgmap/game.dart';

class Intersection {
  Intersection(this.point, this.distance, this.type);

  final Vector2 point;
  final double distance;
  final RpgWallType type;
}

class Token extends PositionComponent with HasGameRef<RpgMapGame>, Draggable {
  Token(Color color)
      : playerPainter = Paint()
          ..color = color
          ..style = PaintingStyle.fill,
        super(size: Vector2.all(64), anchor: Anchor.center);

  final overlayPainter = Paint()..color = const Color(0xff666666);
  final blackFilledPainter = Paint()
    ..color = const Color(0xFF000000)
    ..style = PaintingStyle.fill;

  final wallPainter = Paint()
    ..color = const Color(0xFFFFFF00)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  static const kViewMax = 500.0;

  Paint playerPainter;
  late Offset c;
  late Shader rayShader;
  late Paint rayPainter;

  @override
  Future<void>? onLoad() {
    c = (size / 2).toOffset();
    rayShader = const RadialGradient(
      colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF), Color(0x00FFFFFF)],
      stops: [0.0, 0.5, 1.0],
    ).createShader(
      Rect.fromCircle(
        center: c,
        radius: kViewMax,
      ),
    );
    rayPainter = Paint()..shader = rayShader;

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final xRatio = game.map.backgroundSize.x / game.map.viewBox.x;
    final yRatio = game.map.backgroundSize.y / game.map.viewBox.y;
    final xp = position.x;
    final yp = position.y;
    const nrays = 800;
    const step = 6.283185307 / nrays;

    //for (final wall in game.map.walls) {
    //  final start = wall.start.toOffset() * xRatio;
    //  final end = wall.end.toOffset() * yRatio;
    //  canvas.drawLine(
    //    start - position.toOffset() + size.toOffset() / 2,
    //    end - position.toOffset() + size.toOffset() / 2,
    //    wallPainter,
    //  );
    //}

    //for (final wall in game.map.terrainWalls) {
    //  final start = wall.start.toOffset() * xRatio;
    //  final end = wall.end.toOffset() * yRatio;
    //  canvas.drawLine(
    //    start - position.toOffset() + size.toOffset() / 2,
    //    end - position.toOffset() + size.toOffset() / 2,
    //    wallPainter,
    //  );
    //}

    final rays = <Offset>[];
    if (game.activePlayer == this) {
      final ray = Vector2(1, -1).normalized();

      for (var n = 0; n < nrays; n++) {
        var xmin = double.infinity;
        var ymin = double.infinity;
        var dmin = double.infinity;

        final dx = ray.x;
        final dy = ray.y;
        game.wallCount = 0;

        final intersections = <Intersection>[];

        for (final wall in [
          ...game.map.walls,
          ...game.map.terrainWalls,
          ...game.doors.where((d) => d.closed),
        ]) {
          if (kDebugMode) {
            game.wallCount += 1;
          }

          final x1 = wall.start.x * xRatio;
          final y1 = wall.start.y * yRatio;
          final x2 = wall.end.x * xRatio;
          final y2 = wall.end.y * yRatio;

          final t = ((xp - x1) * (y2 - y1) - (yp - y1) * (x2 - x1)) /
              (dy * (x2 - x1) - dx * (y2 - y1));
          final u = ((xp - x1) * dy - (yp - y1) * dx) /
              ((x2 - x1) * dy - (y2 - y1) * dx);

          if (u >= 0 && u <= 1 && t >= 0) {
            final x = x1 + u * (x2 - x1);
            final y = y1 + u * (y2 - y1);

            if (t <= kViewMax) {
              intersections.add(
                Intersection(Vector2(x, y), t, wall.type),
              );
            }
            if (t < dmin) {
              dmin = t;
              xmin = x;
              ymin = y;
            }
          }
        }

        intersections.sort((a, b) => a.distance.compareTo(b.distance));

        if (intersections.isNotEmpty) {
          if (intersections.first.type == RpgWallType.terrain) {
            intersections.removeAt(0);
          }
          if (intersections.isNotEmpty) {
            final intersection = intersections.first;
            final v = Offset(intersection.point.x, intersection.point.y) -
                position.toOffset();
            rays.add(v);
          } else {
            rays.add(
              (Vector2(xp, yp) + ray * kViewMax).toOffset() -
                  position.toOffset(),
            );
          }
          //final v = Offset(xmin, ymin) - position.toOffset();
          //rays.add(v);
        } else {
          rays.add(
            (Vector2(xp, yp) + ray * kViewMax).toOffset() - position.toOffset(),
          );
        }

        ray.rotate(step);
      }
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

class PlayerButton extends PositionComponent
    with HasGameRef<RpgMapGame>, Tappable {
  PlayerButton()
      : super(
          size: Vector2.all(48),
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
        4 + size.x / 2,
        Paint()
          ..color = const Color(0xFF000000)
          ..style = PaintingStyle.fill,
      )
      ..drawCircle(
        c,
        size.x / 2,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
  }
}
