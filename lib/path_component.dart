import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:rpgmap/game.dart';

class PathComponent extends PositionComponent with HasGameRef<MyGame> {
  PathComponent(this.pathData) : super();

  final String pathData;
  final Path _path = Path();
  final List<Vector2> _hitbox = [];

  @override
  Future<void>? onLoad() {
    final parts =
        pathData.split(' ').where((element) => element != '').toList();
    var first = true;
    for (final part in parts) {
      if (part == 'M') {
        continue;
      }
      if (part == 'L') {
        continue;
      }
      if (part == 'C') {
        continue;
      }
      if (part == 'Z') {
        continue;
      }
      final coords = part.split(',');
      final x = double.parse(coords[0]);
      final y = double.parse(coords[1]);
      if (first) {
        _path.moveTo(x, y);
        first = false;
      } else {
        _path.lineTo(x, y);
      }
      _hitbox.add(Vector2(x, y));
    }
    add(PolygonHitbox(_hitbox));

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    //canvas.drawPath(_path, Paint()..color = const Color(0xffff0000));
  }
}
