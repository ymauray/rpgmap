import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rpgmap/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final program = await FragmentProgram.fromAsset(
    'assets/shaders/dynamic_lighting.frag.glsl',
  );
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
  );
  final game = RpgMapGame(program);
  runApp(
    MaterialApp(
      home: GameWidget(game: game),
    ),
  );
}
