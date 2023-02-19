import 'package:rpg_map/src/rpg_door.dart';
import 'package:rpg_map/src/rpg_doors_layer.dart';
import 'package:rpg_map/src/rpg_terrain_layer.dart';
import 'package:rpg_map/src/rpg_wall.dart';
import 'package:rpg_map/src/rpg_walls_layer.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:xml/xml.dart';

class RpgMap {
  factory RpgMap.load(String input) {
    final XmlDocument doc = XmlDocument.parse(input);
    final gameMap = RpgMap._internal(doc);
    gameMap.parse();
    return gameMap;
  }

  RpgMap._internal(this.doc);

  final XmlDocument doc;

  late String background;
  late Vector2 backgroundSize;
  late Vector2 viewBox;
  late List<RpgWall> walls;
  late List<RpgWall> terrainWalls;
  late List<RpgDoor> doors;

  XmlElement _getGroup(String label) {
    return doc.rootElement.childElements.firstWhere(
      (e) => e.name.local == 'g' && e.getAttribute('inkscape:label') == label,
    );
  }

  void parse() {
    RpgTerrainLayer terrainLayer = RpgTerrainLayer(_getGroup('Terrain'));
    background = terrainLayer.image;
    var width = double.parse(doc.rootElement.getAttribute('width') ?? '0');
    var height = double.parse(doc.rootElement.getAttribute('height') ?? '0');
    backgroundSize = Vector2(width, height);
    final attr = doc.rootElement.getAttribute('viewBox')!;
    final splits = attr.split(' ');
    width = double.parse(splits[2]);
    height = double.parse(splits[3]);
    viewBox = Vector2(width, height);

    RpgWallsLayer wallsLayer = RpgWallsLayer(_getGroup('Walls'));
    walls = wallsLayer.walls;

    RpgDoorsLayer doorsLayer = RpgDoorsLayer(_getGroup('Doors'));
    doors = doorsLayer.doors;

    //RpgWallsLayer terrainWallsLayer = RpgWallsLayer(_getGroup('Terrain Walls'));
    //terrainWalls = terrainWallsLayer.walls;
    //for (var wall in terrainWalls) {
    //  wall.type = RpgWallType.terrain;
    //}
  }
}
