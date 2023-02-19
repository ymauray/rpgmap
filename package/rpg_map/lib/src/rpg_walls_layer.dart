import 'package:flutter/rendering.dart';
import 'package:rpg_map/src/rpg_has_path.dart';
import 'package:rpg_map/src/rpg_map_layer.dart';
import 'package:rpg_map/src/rpg_wall.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:xml/xml.dart';

class RpgWallsLayer extends RpgMapLayer with RpgHasPath {
  RpgWallsLayer(XmlElement group) : super(group);

  List<RpgWall> get walls {
    final walls = <RpgWall>[];

    final paths = group.findElements('path');
    for (final path in paths) {
      assert(path.getAttribute('d') != null, 'No d attribute');
      final points = parsePaths(path.getAttribute('d')!);
      final wallLabel = path.getAttribute('inkscape:label');

      for (var i = 0; i < points.length - 1; i++) {
        final wall = RpgWall()
          ..start = points[i]
          ..end = points[i + 1];
        walls.add(wall);
        debugPrint('Added $wallLabel : ${wall.start} -> ${wall.end}');
      }
    }

    final rects = group.findElements('rect');
    for (final rect in rects) {
      final left = double.parse(rect.getAttribute('x')!);
      final top = double.parse(rect.getAttribute('y')!);
      final width = double.parse(rect.getAttribute('width')!);
      final height = double.parse(rect.getAttribute('height')!);
      walls.addAll([
        RpgWall()
          ..start = Vector2(left, top)
          ..end = Vector2(left + width, top),
        RpgWall()
          ..start = Vector2(left + width, top)
          ..end = Vector2(left + width, top + height),
        RpgWall()
          ..start = Vector2(left + width, top + height)
          ..end = Vector2(left, top + height),
        RpgWall()
          ..start = Vector2(left, top + height)
          ..end = Vector2(left, top),
      ]);
    }

    return walls;
  }
}
