import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rpg_map/rpg_map.dart';
import 'package:rpgmap/debug_component.dart';
import 'package:rpgmap/doors_layer_component.dart';
import 'package:rpgmap/hud/zoom_button.dart';
import 'package:rpgmap/image_component.dart';
import 'package:rpgmap/shader_component.dart';
import 'package:rpgmap/token.dart';

const kTileSize = 64;
const viewportWidth = 18.0 * kTileSize;
const viewportHeight = 12.0 * kTileSize;

class RpgMapGame extends FlameGame
    with HasTappables, HasDraggables, KeyboardEvents, HasCollisionDetection {
  RpgMapGame(this.program);

  final FragmentProgram program;

  late Token red;
  late Token activePlayer;
  late RpgMap map;

  Vector2 cameraTarget = Vector2.zero();
  List<RpgDoor> doors = <RpgDoor>[];
  int wallCount = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(
      Vector2(1920, 1080),
    );

    map = RpgMap.load(await rootBundle.loadString('assets/images/inn.svg'));

    final zoomInIcon = await Sprite.load('hud/zoom-in-512.png');
    final zoomOutIcon = await Sprite.load('hud/zoom-out-512.png');

    await addAll([
      ImageComponent(
        await Images().load(map.background),
        size: map.backgroundSize,
        anchor: Anchor.topLeft,
      ),
      ShaderComponent(),
      activePlayer = red = Token(const Color(0xffff0000))
        ..position = Vector2(
          map.backgroundSize.x / 2,
          map.backgroundSize.y / 2,
        ),
      ZoomButton(
        ZoomButtonAction.zoomIn,
        Vector2.zero(),
        Vector2.all(96),
        zoomInIcon,
      )
        ..positionType = PositionType.viewport
        ..anchor = Anchor.topRight
        ..position = Vector2(size.x - 10, 10),
      ZoomButton(
        ZoomButtonAction.zoomOut,
        Vector2.all(512),
        Vector2.all(96),
        zoomOutIcon,
      )
        ..positionType = PositionType.viewport
        ..anchor = Anchor.topRight
        ..position = Vector2(size.x - 10 - 10 - 96, 10),
      if (kDebugMode)
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
    ]);

    cameraTarget = red.position - camera.gameSize / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);
    camera.snapTo(cameraTarget);
  }
}

class MyOldGame extends FlameGame
    with HasTappables, HasDraggables, KeyboardEvents, HasCollisionDetection {
  MyOldGame();

  late ImageComponent imageComponent;

  late Token red;
  late Token green;
  late Token blue;
  late Token yellow;
  late Token activePlayer;

  Vector2 cameraTarget = Vector2.zero();
  List<RpgWall> walls = <RpgWall>[];
  List<RpgDoor> doors = <RpgDoor>[];
  int wallCount = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(
      Vector2(viewportWidth, viewportHeight),
    );

    final map =
        RpgMap.load(await rootBundle.loadString('assets/images/inn.svg'));

    walls = map.walls;
    doors = map.doors;

    final zoomInIcon = await Sprite.load('hud/zoom-in-512.png');
    final zoomOutIcon = await Sprite.load('hud/zoom-out-512.png');

    // 2.834645503 => pixels per mm => 72 dpi
    await addAll([
      imageComponent = ImageComponent(
        await Images().load(map.background),
        size: map.backgroundSize,
        anchor: Anchor.topLeft,
      ),
      DoorsLayerComponent(
        doors: doors,
        size: map.backgroundSize,
      ),
      activePlayer = red = Token(const Color(0xffff0000))
        ..position = Vector2(
          kTileSize / 2 + kTileSize * 46,
          kTileSize / 2 + 26 * kTileSize,
        ),
      green = Token(const Color(0xff00ff00))
        ..position = Vector2(
          kTileSize / 2 + kTileSize * 39.5,
          kTileSize / 2 + kTileSize * 21,
        ),
      blue = Token(const Color(0xff0000ff))
        ..position = Vector2(
          kTileSize / 2 + kTileSize * 33,
          kTileSize / 2 + kTileSize * 26,
        ),
      yellow = Token(const Color(0xffffff00))
        ..position = Vector2(
          kTileSize / 2 + kTileSize * 35,
          kTileSize / 2 + kTileSize * 16,
        ),
      PlayerButton()
        ..position = Vector2(
          viewportWidth - kTileSize * 7,
          viewportHeight - kTileSize * 1,
        )
        ..color = const Color(0xffff0000)
        ..onTap = () {
          cameraTarget = red.position - camera.gameSize / 2;
          activePlayer = red;
        },
      PlayerButton()
        ..position = Vector2(
          viewportWidth - kTileSize * 5,
          viewportHeight - kTileSize * 1,
        )
        ..color = const Color(0xff00ff00)
        ..onTap = () {
          cameraTarget = green.position - camera.gameSize / 2;
          activePlayer = green;
        },
      PlayerButton()
        ..position = Vector2(
          viewportWidth - kTileSize * 3,
          viewportHeight - kTileSize * 1,
        )
        ..color = const Color(0xff0000ff)
        ..onTap = () {
          cameraTarget = blue.position - camera.gameSize / 2;
          activePlayer = blue;
        },
      PlayerButton()
        ..position = Vector2(
          viewportWidth - kTileSize * 1,
          viewportHeight - kTileSize * 1,
        )
        ..color = const Color(0xffffff00)
        ..onTap = () {
          cameraTarget = yellow.position - camera.gameSize / 2;
          activePlayer = yellow;
        },
      ZoomButton(
        ZoomButtonAction.zoomIn,
        Vector2.zero(),
        Vector2.all(96),
        zoomInIcon,
      )
        ..positionType = PositionType.viewport
        ..anchor = Anchor.topRight
        ..position = Vector2(size.x - 10, 10),
      ZoomButton(
        ZoomButtonAction.zoomOut,
        Vector2.all(512),
        Vector2.all(96),
        zoomOutIcon,
      )
        ..positionType = PositionType.viewport
        ..anchor = Anchor.topRight
        ..position = Vector2(size.x - 10 - 10 - 96, 10),
      if (kDebugMode)
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
      if (kDebugMode)
        DebugComponent()
          ..anchor = Anchor.topLeft
          ..position = Vector2(10, 10)
          ..textRenderer = TextPaint(
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w100,
              color: Color(0xFF00FF00),
            ),
          ),
    ]);

    cameraTarget = red.position - camera.gameSize / 2;
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
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
