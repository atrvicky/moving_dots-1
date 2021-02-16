import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ImagePainter extends CustomPainter {
  ui.Image img;

  ImagePainter({this.img});

  @override
  void paint(Canvas canvas, Size size) {
    if (img != null) {
      canvas.drawImage(img, new Offset(0.0, 0.0), new Paint());
    }
  }

  @override
  bool shouldRepaint(ImagePainter oldPainter) {
    return img != oldPainter.img;
  }
}
