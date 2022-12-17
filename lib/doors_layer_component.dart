import 'package:flame/components.dart';
import 'package:rpg_map/rpg_map.dart';
import 'package:rpgmap/door_component.dart';
import 'package:rpgmap/game.dart';

class DoorsLayerComponent extends PositionComponent
    with HasGameRef<RpgMapGame> {
  DoorsLayerComponent({
    required this.doors,
    required super.size,
  });
  final List<RpgDoor> doors;

  @override
  Future<void>? onLoad() {
    for (final door in doors) {
      add(DoorComponent(door: door));
    }
    return super.onLoad();
  }

  //@override
  //void render(Canvas canvas) {
  //  super.render(canvas);
  //  for (final door in doors) {
  //    if (door.closed) {
  //      canvas.drawLine(
  //        door.start.toOffset(),
  //        door.end.toOffset(),
  //        Paint()
  //          ..color = const Color(0xFF000000)
  //          ..strokeWidth = 10,
  //      );
  //    }
  //  }
  //}
}
