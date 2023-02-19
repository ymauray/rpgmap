import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:rpgmap/map_renderer.dart';

void main() {
  final game = MapRenderer();
  runApp(GameWidget(game: game));
}
