import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texture_controller/texture_controller_method_channel.dart';

void main() {
  MethodChannelTextureController platform = MethodChannelTextureController();
  const MethodChannel channel = MethodChannel('texture_controller');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
