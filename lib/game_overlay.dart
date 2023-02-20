import 'package:flutter/material.dart';
import 'package:rpgmap/map_renderer.dart';

class GameOverlay extends StatelessWidget {
  const GameOverlay({
    required this.game,
    super.key,
  });

  final MapRenderer game;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                TextButton(
                  onPressed: game.zoomIn,
                  child: const Icon(
                    Icons.zoom_in,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                TextButton(
                  onPressed: game.zoomOut,
                  child: const Icon(
                    Icons.zoom_out,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
