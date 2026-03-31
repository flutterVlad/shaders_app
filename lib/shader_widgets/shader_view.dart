import 'dart:ui';

import 'package:flutter/material.dart';

import 'models/shader_asset.dart';
import 'shadeer_wrapper.dart';

class ShaderView extends StatefulWidget {
  const ShaderView({super.key, required this.shaderAsset, required this.time});

  final ShaderAsset shaderAsset;
  final double time;

  @override
  State<ShaderView> createState() => _ShaderViewState();
}

class _ShaderViewState extends State<ShaderView> {
  late Future<FragmentShader> _shaderFuture;

  @override
  void initState() {
    super.initState();

    _shaderFuture = _loadShader(
      'assets/shaders/${widget.shaderAsset.fileName}.frag',
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _shaderFuture,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return SizedBox.expand(
            child: ShaderWrapper(
              useMouse: widget.shaderAsset.usePointer,
              shader: snapshot.data!,
              time: widget.time,
            ),
          );
        } else if (snapshot.connectionState == .waiting) {
          return Center(
            child: Column(
              mainAxisSize: .min,
              children: [
                Text(snapshot.connectionState.name),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator.adaptive(),
                ),
              ],
            ),
          );
        }

        return Center(child: Text("No data"));
      },
    );
  }

  Future<FragmentShader> _loadShader(String shaderAssetPath) async {
    final program = await FragmentProgram.fromAsset(shaderAssetPath);

    return program.fragmentShader();
  }
}
