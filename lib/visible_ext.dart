import 'package:flame/components.dart';
import 'package:rpg_map/rpg_map.dart';

extension Visible on Iterable<RpgWall> {
  Iterable<RpgWall> visible(Vector2 position, Vector2 size) sync* {
    for (final wall in this) {
      if (wall.start.x > position.x + size.x) continue;
      if (wall.start.y > position.y + size.y) continue;
      if (wall.end.x < position.x) continue;
      if (wall.end.y < position.y) continue;
      yield wall;
    }
  }
}
