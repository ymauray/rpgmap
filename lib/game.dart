import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rpgmap/image_component.dart';
import 'package:rpgmap/player.dart';
import 'package:rpgmap/wall.dart';
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
  List<Wall> walls = <Wall>[];

  Future<String> loadCSV(String asset) async {
    final csv = await rootBundle.loadString(asset);
    final doc = XmlDocument.parse(csv);
    final path = doc.rootElement.descendants
        .where((e) => e is XmlElement && e.name.local == 'path')
        .first;
    final d01 = path.attributes.where((e) => e.name.local == 'd').first.value;
    return d01;
  }

  Future<void> loadInkScapeSVG(String asset) async {
    final csv = await rootBundle.loadString(asset);
    final doc = XmlDocument.parse(csv);
    final g = doc.rootElement.childElements
        .where(
          (element) => element.name.local == 'g',
        )
        .first;
    final transform = g.getAttribute('transform');
    assert(transform != null, 'No transform attribute');
    assert(transform!.startsWith('translate('), 'Not a translate transform');
    final splits = transform!.split('translate(')[1].split(')')[0].split(',');
    final translateX = double.parse(splits[0]);
    final translateY = double.parse(splits[1]);
    final paths = g.childElements.where(
      (element) => element.name.local == 'path',
    );

    for (final path in paths) {
      final d = path.getAttribute('d');
      assert(d != null, 'No d attribute');
      final splits = d!.split(' ');
      final points = <Vector2>[];
      var currentPoint = Vector2.zero();
      final translation = Vector2(translateX, translateY);

      var command = '';
      for (final split in splits) {
        if ('0123456789-'.contains(split[0])) {
          switch (command) {
            case 'm':
              final xy = split.split(',');
              final x = double.parse(xy[0]) + currentPoint.x;
              final y = double.parse(xy[1]) + currentPoint.y;
              currentPoint = Vector2(x, y);
              points.add(currentPoint + translation);
              command = 'l';
              break;
            case 'M':
              final xy = split.split(',');
              final x = double.parse(xy[0]);
              final y = double.parse(xy[1]);
              currentPoint = Vector2(x, y);
              points.add(currentPoint + translation);
              command = 'L';
              break;
            case 'v':
              final y = double.parse(split) + currentPoint.y;
              currentPoint = Vector2(currentPoint.x, y);
              points.add(currentPoint + translation);
              break;
            case 'V':
              final y = double.parse(split);
              currentPoint = Vector2(currentPoint.x, y);
              points.add(currentPoint + translation);
              break;
            case 'h':
              final x = double.parse(split) + currentPoint.x;
              currentPoint = Vector2(x, currentPoint.y);
              points.add(currentPoint + translation);
              break;
            case 'H':
              final x = double.parse(split);
              currentPoint = Vector2(x, currentPoint.y);
              points.add(currentPoint + translation);
              break;
            case 'l':
              final xy = split.split(',');
              final x = double.parse(xy[0]) + currentPoint.x;
              final y = double.parse(xy[1]) + currentPoint.y;
              currentPoint = Vector2(x, y);
              points.add(currentPoint + translation);
              break;
            case 'L':
              final xy = split.split(',');
              final x = double.parse(xy[0]);
              final y = double.parse(xy[1]);
              currentPoint = Vector2(x, y);
              points.add(currentPoint + translation);
              break;
            default:
              throw Exception('Unknown command $command');
          }
        } else {
          command = split;
        }
      }

      for (var i = 0; i < points.length - 1; i++) {
        final wall = Wall()
          ..start = points[i] / 1512.7112 * 4288
          ..end = points[i + 1] / 970.84442 * 2752;
        walls.add(wall);
      }

      walls.add(
        Wall()
          ..start = points.last / 1512.7112 * 4288
          ..end = points.first / 970.84442 * 2752,
      );
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    imageComponent = ImageComponent(
      await Images().load('forteresse.png'),
      size: Vector2(4288, 2752),
      anchor: Anchor.topLeft,
    );

    //final corpsDeGarde = await loadCSV(
    //  'assets/images/forteresse-corps-de-garde.svg',
    //);
    //final f2 = await loadCSV('assets/images/forteresse-f2.svg');
    //final f3 = await loadCSV('assets/images/forteresse-f3.svg');
    //final f4 = await loadCSV('assets/images/forteresse-f4.svg');
    //final f5 = await loadCSV('assets/images/forteresse-f5.svg');
    //final f6 = await loadCSV('assets/images/forteresse-f6.svg');

    await loadInkScapeSVG('assets/images/dessin.svg');

    await addAll([
      //mapComponent,
      imageComponent,
      //PathComponent(corpsDeGarde),
      //PathComponent(f2),
      //PathComponent(f3),
      //PathComponent(f4),
      //PathComponent(f5),
      //PathComponent(f6),
      red = Player()
        ..position = Vector2(
          tileSize / 2 + tileSize * 37,
          tileSize / 2 + 20 * tileSize,
        )
        ..color = const Color(0xffff0000),
      //green = Player()
      //  ..position =
      //      Vector2(tileSize / 2 + tileSize * 5, tileSize / 2 + tileSize * 1)
      //  ..color = const Color(0xff00ff00),
      //blue = Player()
      //  ..position =
      //      Vector2(tileSize / 2 + tileSize * 5, tileSize / 2 + tileSize * 3)
      //  ..color = const Color(0xff0000ff),
      //yellow = Player()
      //  ..position =
      //      Vector2(tileSize / 2 + tileSize * 1, tileSize / 2 + tileSize * 3)
      //  ..color = const Color(0xffffff00),
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
    //final result = collisionDetection.raycastAll(
    //  red.position,
    //  numberOfRays: 8000,
    //);
    //red.raycastResult = result;
  }
}
