import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:rpg_map/rpg_map.dart';
import 'package:rpgmap/game.dart';

const kDoorThickness = 10.0;

class DoorComponent extends PositionComponent
    with HasGameRef<RpgMapGame>, Tappable {
  DoorComponent({
    required this.door,
  });
  final RpgDoor door;

  @override
  Future<void>? onLoad() {
    final bbox = Rect.fromLTRB(
      0,
      0,
      door.end.x - door.start.x,
      door.end.y - door.start.y,
    );
    if (bbox.width.abs() > bbox.height.abs()) {
      /* Horizontal door */
      size = Vector2(bbox.width.abs(), kDoorThickness * 2);
      position = Vector2(
        min(door.start.x, door.end.x),
        door.start.y - kDoorThickness,
      );
    } else {
      /* Vertical door */
      size = Vector2(kDoorThickness * 2, bbox.height.abs());
      position = Vector2(
        door.start.x - kDoorThickness,
        min(door.start.y, door.end.y),
      );
    }

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (size.x > size.y) {
      /* Horizontal door */
      canvas.drawLine(
        const Offset(0, kDoorThickness),
        Offset(size.x, kDoorThickness),
        Paint()
          ..color = Color(door.closed ? 0xFF000000 : 0x88000000)
          ..strokeWidth = kDoorThickness,
      );
    } else {
      /* Vertical door */
      canvas.drawLine(
        const Offset(kDoorThickness, 0),
        Offset(kDoorThickness, size.y),
        Paint()
          ..color = Color(door.closed ? 0xFF000000 : 0x88000000)
          ..strokeWidth = kDoorThickness,
      );
    }
  }

  @override
  bool onTapDown(TapDownInfo info) {
    return door.closed = !door.closed;
  }
}
