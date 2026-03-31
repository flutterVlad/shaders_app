final class ShaderAsset {
  final String fileName;
  final bool usePointer;

  const ShaderAsset({required this.fileName, required this.usePointer});

  static const List<ShaderAsset> samples = [
    ShaderAsset(fileName: 'bolls_shader', usePointer: false),
    ShaderAsset(fileName: '3d_shader', usePointer: false),
    ShaderAsset(fileName: 'cosmos_shader', usePointer: false),
    ShaderAsset(fileName: 'fast_bolls', usePointer: false),
  ];

  static const List<ShaderAsset> samplesWithInteractions = [
    ShaderAsset(fileName: 'fun_shader', usePointer: true),
    ShaderAsset(fileName: 'laser_shader', usePointer: true),
    ShaderAsset(fileName: 'sea_shader', usePointer: true),
    ShaderAsset(fileName: 'beautiful_shader', usePointer: true),
  ];
}
