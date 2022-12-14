import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rpgmap/hud/zoom_button.dart';
import 'package:rpgmap/image_component.dart';
import 'package:rpgmap/player.dart';
import 'package:rpgmap/utils.dart';
import 'package:rpgmap/wall.dart';

class MyGame extends FlameGame
    with HasTappables, HasDraggables, KeyboardEvents, HasCollisionDetection {
  MyGame();

  late ImageComponent imageComponent;

  double time = 0;
  Vector2 cameraTarget = Vector2.zero();
  static const viewportWidth = 36;
  static const viewportHeight = 24;

  late Player red;
  late Player green;
  late Player blue;
  late Player yellow;
  late Player activePlayer;
  late PlayerButton redButton;
  late PlayerButton greenButton;
  late PlayerButton blueButton;
  late PlayerButton yellowButton;

  final tileSize = 64;
  double rayMax = 0;
  List<Wall> walls = <Wall>[];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(
      Vector2(
        tileSize * viewportWidth * 1,
        tileSize * viewportHeight * 1,
      ),
    );

    imageComponent = ImageComponent(
      await Images().load('forteresse.png'),
      size: Vector2(4288, 2752),
      anchor: Anchor.topLeft,
    );

    walls = await loadInkScapeSVG('assets/images/dessin.svg');

    final zoomInIcon = await Sprite.load('assets/images/hud/zoom-in-512.png');
    final zoomOutIcon = await Sprite.load('assets/images/hud/zoom-out-512.png');

    await addAll([
      imageComponent,
      activePlayer = red = Player(const Color(0xffff0000))
        ..position = Vector2(
          tileSize / 2 + tileSize * 46,
          tileSize / 2 + 26 * tileSize,
        ),
      green = Player(const Color(0xff00ff00))
        ..position = Vector2(
          tileSize / 2 + tileSize * 39.5,
          tileSize / 2 + tileSize * 21,
        ),
      blue = Player(const Color(0xff0000ff))
        ..position =
            Vector2(tileSize / 2 + tileSize * 33, tileSize / 2 + tileSize * 26),
      yellow = Player(const Color(0xffffff00))
        ..position =
            Vector2(tileSize / 2 + tileSize * 35, tileSize / 2 + tileSize * 16),
      redButton = PlayerButton()
        ..position = Vector2(
          tileSize * (viewportWidth - 4),
          tileSize * (viewportHeight - 1),
        )
        ..color = const Color(0xffff0000)
        ..onTap = () {
          cameraTarget = red.position - camera.gameSize / 2;
          activePlayer = red;
        },
      greenButton = PlayerButton()
        ..position = Vector2(
          tileSize * (viewportWidth - 3),
          tileSize * (viewportHeight - 1),
        )
        ..color = const Color(0xff00ff00)
        ..onTap = () {
          cameraTarget = green.position - camera.gameSize / 2;
          activePlayer = green;
        },
      blueButton = PlayerButton()
        ..position = Vector2(
          tileSize * (viewportWidth - 2),
          tileSize * (viewportHeight - 1),
        )
        ..color = const Color(0xff0000ff)
        ..onTap = () {
          cameraTarget = blue.position - camera.gameSize / 2;
          activePlayer = blue;
        },
      yellowButton = PlayerButton()
        ..position = Vector2(
          tileSize * (viewportWidth - 1),
          tileSize * (viewportHeight - 1),
        )
        ..color = const Color(0xffffff00)
        ..onTap = () {
          cameraTarget = yellow.position - camera.gameSize / 2;
          activePlayer = yellow;
        },
      FpsTextComponent()
        ..anchor = Anchor.bottomLeft
        ..position = Vector2(10, size.y - 10)
        ..textRenderer = TextPaint(
          style: const TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00FF00),
          ),
        ),
      ZoomButton(
        Vector2.zero(),
        Vector2.all(512),
        zoomInIcon,
      )..positionType = PositionType.viewport,
      ZoomButton(
        Vector2.all(512),
        Vector2.all(512),
        zoomOutIcon,
      )..positionType = PositionType.viewport,
    ]);

    rayMax = camera.viewport.effectiveSize.length;

    cameraTarget = red.position - camera.gameSize / 2;
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    debugPrint('Key event');
    if (keysPressed.contains(LogicalKeyboardKey.numpad1)) {
      cameraTarget = red.position - camera.gameSize / 2;
    }
    if (keysPressed.contains(LogicalKeyboardKey.numpad2)) {
      cameraTarget = green.position - camera.gameSize / 2;
    }
    if (keysPressed.contains(LogicalKeyboardKey.numpad3)) {
      cameraTarget = blue.position - camera.gameSize / 2;
    }
    if (keysPressed.contains(LogicalKeyboardKey.numpad4)) {
      cameraTarget = yellow.position - camera.gameSize / 2;
    }
    return KeyEventResult.handled;
  }

  @override
  void update(double dt) {
    super.update(dt);
    camera.snapTo(cameraTarget);
  }
}
