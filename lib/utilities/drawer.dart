import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:touchable/touchable.dart';
import 'package:base_app/constants.dart';

class ForegroundPainter extends CustomPainter {
  final List<dynamic> dots;
  final BuildContext context;

  ForegroundPainter({this.dots, this.context});

  @override
  void paint(Canvas canvas, Size size) {
    TouchyCanvas touchyCanvas = TouchyCanvas(context, canvas);

    // PLAYER DOTS
    final pointMode = ui.PointMode.points;
    final pts = dots.map((dynamic player) {
      player = new List<dynamic>.from(player);
      return Offset(
        player[1],
        player[0],
      );
    }).toList();

    touchyCanvas.drawPoints(pointMode, pts, paintPts, onTapDown: (pointer) {
      print('A');
    });
  }

  @override
  bool shouldRepaint(ForegroundPainter oldPainter) {
    return dots != oldPainter.dots;
  }
}

class OtherPainter extends CustomPainter {
  OtherPainter();

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(ForegroundPainter oldPainter) {
    return false;
  }
}
