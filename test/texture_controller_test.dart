import 'package:flutter_test/flutter_test.dart';
import 'package:texture_controller/texture_controller.dart';
import 'package:texture_controller/texture_controller_platform_interface.dart';
import 'package:texture_controller/texture_controller_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTextureControllerPlatform
    with MockPlatformInterfaceMixin
    implements TextureControllerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TextureControllerPlatform initialPlatform = TextureControllerPlatform.instance;

  test('$MethodChannelTextureController is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTextureController>());
  });

  test('getPlatformVersion', () async {
    TextureController textureControllerPlugin = TextureController();
    MockTextureControllerPlatform fakePlatform = MockTextureControllerPlatform();
    TextureControllerPlatform.instance = fakePlatform;

    expect(await textureControllerPlugin.getPlatformVersion(), '42');
  });
}
