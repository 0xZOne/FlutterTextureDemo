import 'texture_controller_platform_interface.dart';

class TextureController {
  late int textureId;

  Future<void> initialize(double width, double height) async {
    textureId = await TextureControllerPlatform.instance.create(width, height);
  }

  Future<void> dispose() =>
      TextureControllerPlatform.instance.dispose(textureId);
}
