
import 'texture_controller_platform_interface.dart';

class TextureController {
  Future<String?> getPlatformVersion() {
    return TextureControllerPlatform.instance.getPlatformVersion();
  }
}
