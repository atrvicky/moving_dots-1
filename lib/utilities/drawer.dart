import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:touchable/touchable.dart';

class ImagePainter extends CustomPainter {
  final List<dynamic> img;

  ImagePainter({this.img});

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(ImagePainter oldPainter) {
    return img != oldPainter.img;
  }
}

class OtherPainter extends CustomPainter {
  OtherPainter();

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(ImagePainter oldPainter) {
    return false;
  }
}
