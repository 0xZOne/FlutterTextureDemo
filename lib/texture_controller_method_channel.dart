import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'texture_controller_platform_interface.dart';

/// An implementation of [TextureControllerPlatform] that uses method channels.
class MethodChannelTextureController extends TextureControllerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('texture_controller');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
