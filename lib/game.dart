import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rpgmap/image_component.dart';
import 'package:rpgmap/path_component.dart';
import 'package:rpgmap/player.dart';
import 'package:xml/xml.dart';

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
  late PlayerButton redButton;
  late PlayerButton greenButton;
  late PlayerButton blueButton;
  late PlayerButton yellowButton;

  final tileSize = 64;
  double rayMax = 0;

  Future<String> loadCSV(String asset) async {
    final csv = await rootBundle.loadString(asset);
    final doc = XmlDocument.parse(csv);
    final path = doc.rootElement.descendants
        .where((e) => e is XmlElement && e.name.local == 'path')
        .first;
    final d01 = path.attributes.where((e) => e.name.local == 'd').first.value;
    return d01;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    imageComponent = ImageComponent(
      await Images().load('forteresse.png'),
      size: Vector2(4288, 2752),
      anchor: Anchor.topLeft,
    );

    final corpsDeGarde = await loadCSV(
      'assets/images/forteresse-corps-de-garde.svg',
    );
    final f2 = await loadCSV('assets/images/forteresse-f2.svg');
    final f3 = await loadCSV('assets/images/forteresse-f3.svg');
    final f4 = await loadCSV('assets/images/forteresse-f4.svg');
    final f5 = await loadCSV('assets/images/forteresse-f5.svg');
    final f6 = await loadCSV('assets/images/forteresse-f6.svg');

    await addAll([
      //mapComponent,
      imageComponent,
      PathComponent(corpsDeGarde),
      PathComponent(f2),
      PathComponent(f3),
      PathComponent(f4),
      PathComponent(f5),
      PathComponent(f6),
      red = Player()
        ..position =
            Vector2(tileSize / 2 + tileSize * 19, tileSize / 2 + 10 * tileSize)
        ..color = const Color(0xffff0000),
      green = Player()
        ..position =
            Vector2(tileSize / 2 + tileSize * 5, tileSize / 2 + tileSize * 1)
        ..color = const Color(0xff00ff00),
      blue = Player()
        ..position =
            Vector2(tileSize / 2 + tileSize * 5, tileSize / 2 + tileSize * 3)
        ..color = const Color(0xff0000ff),
      yellow = Player()
        ..position =
            Vector2(tileSize / 2 + tileSize * 1, tileSize / 2 + tileSize * 3)
        ..color = const Color(0xffffff00),
      redButton = PlayerButton()
        ..position = Vector2(
          tileSize * (viewportWidth - 4),
          tileSize * (viewportHeight - 1),
        )
        ..color = const Color(0xffff0000)
        ..onTap = () {
          cameraTarget = red.position - camera.gameSize / 2;
        },
      greenButton = PlayerButton()
        ..position = Vector2(
          tileSize * (viewportWidth - 3),
          tileSize * (viewportHeight - 1),
        )
        ..color = const Color(0xff00ff00)
        ..onTap = () {
          cameraTarget = green.position - camera.gameSize / 2;
        },
      blueButton = PlayerButton()
        ..position = Vector2(
          tileSize * (viewportWidth - 2),
          tileSize * (viewportHeight - 1),
        )
        ..color = const Color(0xff0000ff)
        ..onTap = () {
          cameraTarget = blue.position - camera.gameSize / 2;
        },
      yellowButton = PlayerButton()
        ..position = Vector2(
          tileSize * (viewportWidth - 1),
          tileSize * (viewportHeight - 1),
        )
        ..color = const Color(0xffffff00)
        ..onTap = () {
          cameraTarget = yellow.position - camera.gameSize / 2;
        },
    ]);

    camera.viewport = FixedResolutionViewport(
      Vector2(
        tileSize * viewportWidth * 1,
        tileSize * viewportHeight * 1,
      ),
    );

    rayMax = camera.viewport.effectiveSize.length;
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
    final result = collisionDetection.raycastAll(
      red.position,
      numberOfRays: 8000,
    );
    red.raycastResult = result;
  }
}
