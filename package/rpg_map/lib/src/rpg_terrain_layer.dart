import 'package:rpg_map/src/rpg_map_layer.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:xml/xml.dart';

class RpgTerrainLayer extends RpgMapLayer {
  RpgTerrainLayer(XmlElement group) : super(group);

  get image => group.childElements
      .firstWhere((e) => e.name.local == 'image')
      .getAttribute('xlink:href');

  Vector2 get size {
    double width = double.parse(group.childElements
            .firstWhere((e) => e.name.local == 'image')
            .getAttribute('width') ??
        '0');
    double height = double.parse(group.childElements
            .firstWhere((e) => e.name.local == 'image')
            .getAttribute('height') ??
        '0');

    return Vector2(width, height) * 72.0 / 25.4;
  }
}
