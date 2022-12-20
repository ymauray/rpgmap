import 'package:vector_math/vector_math_64.dart';

enum RpgWallType { normal, terrain }

class RpgWall {
  Vector2 start = Vector2.zero();
  Vector2 end = Vector2.zero();
  RpgWallType type = RpgWallType.normal;
}
