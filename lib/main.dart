import 'package:flutter/material.dart';

import '/shader_widgets/models/shader_asset.dart';
import '/shader_widgets/shaders_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shaders App',
      home: const RouteScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  static const Map<int, List<ShaderAsset>> _shaders = {
    0: ShaderAsset.samples,
    1: ShaderAsset.samplesWithInteractions,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shaders App"),
        forceMaterialTransparency: true,
      ),
      body: ListView.separated(
        itemCount: _shaders.length,
        padding: const .fromLTRB(16, 16, 16, 0),
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (_, index) {
          return _ListTile(index: index, items: _shaders[index]!);
        },
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({required this.index, required this.items});

  final int index;
  final List<ShaderAsset> items;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: .circular(16),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ShadersScreen(items: items);
              },
            ),
          );
        },
        child: Container(
          height: 48,
          padding: const .symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: .circular(16),
            color: Colors.blue,
            boxShadow: const [BoxShadow(color: Colors.grey)],
          ),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                "Shaders ${index != 0 ? 'with interactions' : ''}",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const Icon(
                Icons.keyboard_arrow_right,
                size: 30,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
