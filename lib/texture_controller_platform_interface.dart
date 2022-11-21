import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'texture_controller_method_channel.dart';

abstract class TextureControllerPlatform extends PlatformInterface {
  /// Constructs a TextureControllerPlatform.
  TextureControllerPlatform() : super(token: _token);

  static final Object _token = Object();

  static TextureControllerPlatform _instance = MethodChannelTextureController();

  /// The default instance of [TextureControllerPlatform] to use.
  ///
  /// Defaults to [MethodChannelTextureController].
  static TextureControllerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TextureControllerPlatform] when
  /// they register themselves.
  static set instance(TextureControllerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
