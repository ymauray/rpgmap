import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:rpgmap/wall.dart';
import 'package:xml/xml.dart';

Future<List<Wall>> loadInkScapeSVG(String asset) async {
  final walls = <Wall>[];

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

  return walls;
}
