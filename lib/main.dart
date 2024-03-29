import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:rpgmap/game_overlay.dart';
import 'package:rpgmap/map_renderer.dart';

void main() {
  //final game = MapRenderer();
  runApp(
    GameWidget<MapRenderer>.controlled(
      gameFactory: MapRenderer.new,
      overlayBuilderMap: {
        'Overlay': (_, game) => GameOverlay(game: game),
      },
      initialActiveOverlays: const ['Overlay'],
    ),
  );
}
