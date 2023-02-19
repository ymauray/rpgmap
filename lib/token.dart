import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
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

    canvas
      ..drawCircle(c, 20, blackFilledPainter)
      ..drawCircle(c, 16, playerPainter);
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
