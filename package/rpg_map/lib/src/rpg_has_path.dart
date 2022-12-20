import 'package:rpg_map/src/rpg_map_layer.dart';
import 'package:vector_math/vector_math_64.dart';

mixin RpgHasPath on RpgMapLayer {
  List<Vector2> parsePaths(String instructions) {
    final splits = instructions.split(' ');
    final points = <Vector2>[];
    var currentPoint = Vector2.zero();

    var command = '';
    for (final split in splits) {
      if ('0123456789-'.contains(split[0])) {
        switch (command) {
          case 'm':
            final xy = split.split(',');
            final x = double.parse(xy[0]) + currentPoint.x;
            final y = double.parse(xy[1]) + currentPoint.y;
            currentPoint = Vector2(x, y);
            points.add(currentPoint);
            command = 'l';
            break;
          case 'M':
            final xy = split.split(',');
            final x = double.parse(xy[0]);
            final y = double.parse(xy[1]);
            currentPoint = Vector2(x, y);
            points.add(currentPoint);
            command = 'L';
            break;
          case 'v':
            final y = double.parse(split) + currentPoint.y;
            currentPoint = Vector2(currentPoint.x, y);
            points.add(currentPoint);
            break;
          case 'V':
            final y = double.parse(split);
            currentPoint = Vector2(currentPoint.x, y);
            points.add(currentPoint);
            break;
          case 'h':
            final x = double.parse(split) + currentPoint.x;
            currentPoint = Vector2(x, currentPoint.y);
            points.add(currentPoint);
            break;
          case 'H':
            final x = double.parse(split);
            currentPoint = Vector2(x, currentPoint.y);
            points.add(currentPoint);
            break;
          case 'l':
            final xy = split.split(',');
            final x = double.parse(xy[0]) + currentPoint.x;
            final y = double.parse(xy[1]) + currentPoint.y;
            currentPoint = Vector2(x, y);
            points.add(currentPoint);
            break;
          case 'L':
            final xy = split.split(',');
            final x = double.parse(xy[0]);
            final y = double.parse(xy[1]);
            currentPoint = Vector2(x, y);
            points.add(currentPoint);
            break;
          default:
            throw Exception('Unknown command $command');
        }
      } else {
        command = split;
      }
    }

    return points;
  }
}
