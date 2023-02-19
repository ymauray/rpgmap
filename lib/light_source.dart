import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LightSource {
  LightSource();
  Vector2 position = Vector2.zero();
  Vector4 color = Vector4(1, 1, 1, 1);
}

extension ColorToVector4 on Color {
  Vector4 toVector4() {
    return Vector4(
      red / 255,
      green / 255,
      blue / 255,
      alpha / 255,
    );
  }
}
