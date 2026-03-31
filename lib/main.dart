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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shaders App"),
        forceMaterialTransparency: true,
      ),
      body: ListView.separated(
        itemCount: 2,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (_, index) {
          return Padding(
            padding: const .symmetric(horizontal: 16),
            child: Material(
              elevation: 1,
              borderRadius: .circular(16),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ShadersScreen(
                          items: index == 0
                              ? ShaderAsset.samples
                              : ShaderAsset.smaplesWithInteractions,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  padding: .symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: .circular(16),
                    color: Colors.blue,
                    boxShadow: [BoxShadow(color: Colors.grey)],
                  ),
                  child: ListTile(
                    contentPadding: .zero,
                    title: Text(
                      "Shaders ${index != 0 ? 'with interactions' : ''}",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
