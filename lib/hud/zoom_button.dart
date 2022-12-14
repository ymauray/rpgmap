import 'package:flame/components.dart';
import 'package:rpgmap/game.dart';

class ZoomButton extends SpriteComponent with Tappable, HasGameRef<MyGame> {
  ZoomButton(Vector2 position, Vector2 size, Sprite sprite)
      : super(position: position, size: size, sprite: sprite);
}
