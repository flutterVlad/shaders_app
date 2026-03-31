import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shader_app/shader_widgets/shader_painter.dart';

class ShaderWrapper extends StatefulWidget {
  const ShaderWrapper({
    super.key,
    this.useMouse = false,
    required this.shader,
    required this.time,
  });

  final bool useMouse;
  final FragmentShader shader;
  final double time;

  @override
  State<ShaderWrapper> createState() => _ShaderWrapperState();
}

class _ShaderWrapperState extends State<ShaderWrapper> {
  Offset mouse = Offset.zero;
  Offset _targetMouse = Offset.zero;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    if (widget.useMouse) {
      // Акселерометр только обновляет цель, без setState
      _subscription = accelerometerEventStream().listen((event) {
        _targetMouse = Offset(
          (event.x / 10.0).clamp(-1.0, 1.0) * 0.5 + 0.5,
          (event.y / 10.0).clamp(-1.0, 1.0) * 0.5 + 0.5,
        );
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mouse = Offset(
      lerpDouble(mouse.dx, _targetMouse.dx, 0.08)!,
      lerpDouble(mouse.dy, _targetMouse.dy, 0.08)!,
    );

    return CustomPaint(
      painter: ShaderPainter(
        shader: widget.shader,
        time: widget.time,
        mouse: widget.useMouse ? mouse : null,
      ),
    );
  }
}
