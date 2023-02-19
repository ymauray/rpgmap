import 'dart:async';
import 'dart:convert';

import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class Wall {
  Wall(this.start, this.end);

  final Vector2 start;
  final Vector2 end;
}

class MapRenderer extends FlameGame with HasDraggableComponents {
  late Image background;
  final List<Wall> walls = [];

  Vector2? dragStart;
  Vector2 imageOrigin = Vector2.zero();

  int pixelsPerGrid = 0;

  @override
  FutureOr<void>? onLoad() async {
    final input = await rootBundle.loadString(
      'assets/maps/samplemap.json',
    );
    final map = jsonDecode(input);
    final image = map['image'] as String;
    background = await Flame.images.fromBase64('map.png', image);

    pixelsPerGrid = map['resolution']['pixels_per_grid'] as int;

    final lineOfSight = map['line_of_sight'] as List<dynamic>;
    for (final line in lineOfSight) {
      final points = List.castFrom<dynamic, Map<String, dynamic>>(
        line as List<dynamic>,
      );
      final start = Vector2(
        (points[0]['x'].toDouble() as double) * pixelsPerGrid,
        (points[0]['y'].toDouble() as double) * pixelsPerGrid,
      );
      final end = Vector2(
        (points[1]['x'].toDouble() as double) * pixelsPerGrid,
        (points[1]['y'].toDouble() as double) * pixelsPerGrid,
      );
      walls.add(Wall(start, end));
    }

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    var myRect = background.size.toRect();
    if (imageOrigin.x > 0) {
      imageOrigin.x = 0;
    }
    if (imageOrigin.y > 0) {
      imageOrigin.y = 0;
    }
    final csize = camera.canvasSize;
    if (imageOrigin.x < csize.x - background.width) {
      imageOrigin.x = csize.x - background.width;
    }
    if (imageOrigin.y < csize.y - background.height) {
      imageOrigin.y = csize.y - background.height;
    }
    myRect = myRect.translate(imageOrigin.x, imageOrigin.y);
    paintImage(canvas: canvas, rect: myRect, image: background);
    for (final wall in walls) {
      canvas.drawLine(
        (wall.start + imageOrigin).toOffset(),
        (wall.end + imageOrigin).toOffset(),
        Paint()
          ..strokeWidth = 8.0
          ..color = const Color(0xFFFF0000),
      );
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    dragStart = event.canvasPosition;
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final dragUpdate = event.canvasPosition;
    final offset = dragUpdate - dragStart!;
    imageOrigin += offset;
    dragStart = dragUpdate;
    super.onDragUpdate(event);
  }
}
