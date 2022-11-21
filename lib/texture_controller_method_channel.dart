import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'texture_controller_platform_interface.dart';

/// An implementation of [TextureControllerPlatform] that uses method channels.
class MethodChannelTextureController extends TextureControllerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('texture_controller');

  @override
  Future<int> create(double width, double height) async {
    return await methodChannel.invokeMethod('create', {
      'width': width,
      'height': height,
    });
  }

  @override
  Future<void> dispose(int? textureId) =>
      methodChannel.invokeMethod('dispose', {'textureId': textureId});
}
