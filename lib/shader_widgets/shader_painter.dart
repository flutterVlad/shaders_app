import 'dart:ui';

import 'package:flutter/material.dart';

class ShaderPainter extends CustomPainter {
  const ShaderPainter({required this.shader, required this.time, this.mouse});

  final double time;
  final FragmentShader shader;
  final Offset? mouse;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, time)
      ..setFloat(1, size.width)
      ..setFloat(2, size.height);

    if (mouse != null) {
      shader
        ..setFloat(3, mouse!.dx)
        ..setFloat(4, mouse!.dy);
    }

    final paint = Paint()..shader = shader;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant ShaderPainter oldDelegate) =>
      oldDelegate.time != time || oldDelegate.mouse != mouse;
}
