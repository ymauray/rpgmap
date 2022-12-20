import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rpg_map/rpg_map.dart';
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
