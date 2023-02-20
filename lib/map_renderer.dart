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

  int pixelsPerGrid = 0;

  double zoom = 1;
  Vector2 imageOrigin = Vector2.zero();

  @override
  FutureOr<void>? onLoad() async {
    final input = await rootBundle.loadString(
      'assets/maps/samplemap.json',
    );
    final map = jsonDecode(input);
    final image = map['image'] as String;
    background = await Flame.images.fromBase64('map.png', image);

    final xratio = canvasSize.x / background.width;
    final yratio = canvasSize.y / background.height;
    zoom = xratio > yratio ? yratio : xratio;
    imageOrigin
      ..x = (canvasSize.x - background.size.x * zoom) / 2.0
      ..y = (canvasSize.y - background.size.y * zoom) / 2.0;

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
    var myRect = (background.size * zoom).toRect();
    //if (imageOrigin.x > 0) {
    //  imageOrigin.x = 0;
    //}
    //if (imageOrigin.y > 0) {
    //  imageOrigin.y = 0;
    //}
    //final csize = camera.canvasSize;
    //if (imageOrigin.x < csize.x - background.width) {
    //  imageOrigin.x = csize.x - background.width;
    //}
    //if (imageOrigin.y < csize.y - background.height) {
    //  imageOrigin.y = csize.y - background.height;
    //}
    myRect = myRect.translate(imageOrigin.x, imageOrigin.y);
    paintImage(canvas: canvas, rect: myRect, image: background);

    for (final wall in walls) {
      canvas.drawLine(
        (wall.start * zoom + imageOrigin).toOffset(),
        (wall.end * zoom + imageOrigin).toOffset(),
        Paint()
          ..strokeWidth = 8.0
          ..color = const Color(0xFFFF0000),
      );
    }
    super.render(canvas);
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

  void zoomIn() {
    var delta = 1.1;
    if ((zoom * delta) > 1) {
      delta = 1 / zoom;
    }

    final xdiff = ((canvasSize.x / 2) - imageOrigin.x) * delta;
    final ydiff = ((canvasSize.y / 2) - imageOrigin.y) * delta;

    imageOrigin
      ..x = (canvasSize.x / 2) - xdiff
      ..y = (canvasSize.y / 2) - ydiff;

    zoom *= delta;
  }

  void zoomOut() {
    final xdiff = ((canvasSize.x / 2) - imageOrigin.x) / 1.1;
    final ydiff = ((canvasSize.y / 2) - imageOrigin.y) / 1.1;

    imageOrigin
      ..x = (canvasSize.x / 2) - xdiff
      ..y = (canvasSize.y / 2) - ydiff;

    zoom /= 1.1;
  }
}
