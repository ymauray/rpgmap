import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rpgmap/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dynamicLightingProgram = await FragmentProgram.fromAsset(
    'assets/shaders/dynamic_lighting.frag.glsl',
  );
  final lightSourceProgram = await FragmentProgram.fromAsset(
    'assets/shaders/light_source.frag.glsl',
  );
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
  );
  final game = RpgMapGame(dynamicLightingProgram, lightSourceProgram);
  runApp(
    MaterialApp(
      home: GameWidget(game: game),
    ),
  );
}
