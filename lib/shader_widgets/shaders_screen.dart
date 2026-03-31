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
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _ticker = createTicker((elapsed) {
      updateTime = elapsed.inMilliseconds / 1000;
      setState(() {});
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: .expand,
        children: [
          PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.items.length,
            itemBuilder: (_, index) =>
                ShaderView(time: updateTime, shaderAsset: widget.items[index]),
          ),
          Positioned.fill(
            bottom: 16,
            child: Align(
              alignment: .bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: .circular(24),
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    IconButton(
                      onPressed: currentIndex > 0
                          ? () => _goTo(currentIndex - 1)
                          : null,
                      icon: const Icon(Icons.keyboard_arrow_left, size: 30),
                      disabledColor: Colors.grey,
                      color: Colors.white,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(widget.items.length, (i) {
                        final selected = i == currentIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const .symmetric(horizontal: 3),
                          width: selected ? 12 : 8,
                          height: selected ? 12 : 8,
                          decoration: BoxDecoration(
                            color: selected ? Colors.blue : Colors.white54,
                            shape: .circle,
                          ),
                        );
                      }),
                    ),
                    IconButton(
                      onPressed: currentIndex < widget.items.length - 1
                          ? () => _goTo(currentIndex + 1)
                          : null,
                      icon: const Icon(Icons.keyboard_arrow_right, size: 30),
                      disabledColor: Colors.grey,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
