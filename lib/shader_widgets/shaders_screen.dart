import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'models/shader_asset.dart';
import 'shader_view.dart';

class ShadersScreen extends StatefulWidget {
  const ShadersScreen({super.key, required this.items});

  final List<ShaderAsset> items;

  @override
  State<ShadersScreen> createState() => _ShadersScreenState();
}

class _ShadersScreenState extends State<ShadersScreen>
    with SingleTickerProviderStateMixin {
  double updateTime = 0.0;
  int currentIndex = 0;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      updateTime = elapsed.inMilliseconds / 1000;
      setState(() {});
    });

    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: DefaultTabController(
        length: widget.items.length,
        child: Stack(
          fit: .expand,
          children: [
            TabBarView(
              children: widget.items
                  .map((e) => ShaderView(time: updateTime, shaderAsset: e))
                  .toList(),
            ),
            Positioned.fill(
              bottom: 16,
              child: Align(
                alignment: .bottomCenter,
                child: TabPageSelector(selectedColor: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
