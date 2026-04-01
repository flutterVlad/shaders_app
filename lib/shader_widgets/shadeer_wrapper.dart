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
  Offset _gestureTarget = const Offset(0.5, 0.5);
  Offset _gestureCurrent = const Offset(0.5, 0.5);

  Offset _accelTarget = const Offset(0.5, 0.5);
  Offset _accelCurrent = const Offset(0.5, 0.5);

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    if (widget.useMouse) {
      // Акселерометр только обновляет цель, без setState
      _subscription = accelerometerEventStream().listen((event) {
        _accelTarget = Offset(
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
    if (widget.useMouse) {
      // Жест — быстрее (0.15), но плавно
      _gestureCurrent = Offset(
        lerpDouble(_gestureCurrent.dx, _gestureTarget.dx, 0.15)!,
        lerpDouble(_gestureCurrent.dy, _gestureTarget.dy, 0.15)!,
      );

      // Наклон — медленнее (0.05), очень плавно
      _accelCurrent = Offset(
        lerpDouble(_accelCurrent.dx, _accelTarget.dx, 0.05)!,
        lerpDouble(_accelCurrent.dy, _accelTarget.dy, 0.05)!,
      );
    }

    final mouse = widget.useMouse
        ? Offset(
            (_gestureCurrent.dx + _accelCurrent.dx) / 2,
            (_gestureCurrent.dy + _accelCurrent.dy) / 2,
          )
        : null;

    return GestureDetector(
      onPanUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        final size = box.size;
        _gestureTarget = Offset(
          (details.localPosition.dx / size.width).clamp(0.0, 1.0),
          (details.localPosition.dy / size.height).clamp(0.0, 1.0),
        );
      },
      child: SizedBox.expand(
        child: CustomPaint(
          painter: ShaderPainter(
            shader: widget.shader,
            time: widget.time,
            mouse: mouse,
          ),
        ),
      ),
    );
  }
}
