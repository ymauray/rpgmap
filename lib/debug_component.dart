import 'package:flame/components.dart';
import 'package:rpgmap/game.dart';

class DebugComponent extends TextComponent with HasGameRef<RpgMapGame> {
  DebugComponent() : super(priority: double.maxFinite.toInt()) {
    positionType = PositionType.viewport;
  }

  @override
  void update(double dt) {
    text = 'Visible walls : ${game.wallCount}';
    super.update(dt);
  }
}
