import 'package:rpg_map/src/rpg_door.dart';
import 'package:rpg_map/src/rpg_has_path.dart';
import 'package:rpg_map/src/rpg_map_layer.dart';
import 'package:xml/xml.dart';

class RpgDoorsLayer extends RpgMapLayer with RpgHasPath {
  RpgDoorsLayer(XmlElement group) : super(group);

  List<RpgDoor> get doors {
    final doors = <RpgDoor>[];
    final paths = group.findElements('path');

    for (final path in paths) {
      assert(path.getAttribute('d') != null, 'No d attribute');
      var points = parsePaths(path.getAttribute('d')!);

      doors.add(
        RpgDoor()
          ..start = points.last / 1512.7112 * 4288
          ..end = points.first / 970.84442 * 2752
          ..closed = true,
      );
    }

    return doors;
  }
}
