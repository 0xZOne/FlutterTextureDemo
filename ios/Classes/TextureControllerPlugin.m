#import "TextureControllerPlugin.h"

#import "AAPLRenderer.h"

@interface TextureControllerPlugin()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, /*OpenGLRender*/AAPLRenderer *> *renders;
@property (nonatomic, strong) NSObject<FlutterTextureRegistry> *textures;
@end

@implementation TextureControllerPlugin
- (instancetype)initWithTextures:(NSObject<FlutterTextureRegistry> *)textures {
    self = [super init];
    if (self) {
        _renders = [[NSMutableDictionary alloc] init];
        _textures = textures;
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"texture_controller"
            binaryMessenger:[registrar messenger]];
  TextureControllerPlugin* instance = [[TextureControllerPlugin alloc] initWithTextures:[registrar textures]];
  // TextureControllerPlugin* instance = [[TextureControllerPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"create" isEqualToString:call.method]) {
      CGFloat width = [call.arguments[@"width"] floatValue];
      CGFloat height = [call.arguments[@"height"] floatValue];

      NSInteger __block textureId;
      id<FlutterTextureRegistry> __weak registry = self.textures;
      AAPLRenderer* render = [[AAPLRenderer alloc] initWithSize:CGSizeMake(width, height)
                                                     onNewFrame:^{
                                                        [registry textureFrameAvailable:textureId];
                                                     }];

      textureId = [self.textures registerTexture:render];
      self.renders[@(textureId)] = render;
      result(@(textureId));
  } else if ([@"dispose" isEqualToString:call.method]) {
      NSNumber *textureId = call.arguments[@"textureId"];
      AAPLRenderer *render = self.renders[textureId];
      [render dispose];
      [self.renders removeObjectForKey:textureId];
      result(nil);
  } else {
      result(FlutterMethodNotImplemented);
  }
}

@end
