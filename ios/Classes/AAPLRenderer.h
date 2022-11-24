/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Header for a renderer class that performs Metal setup and per-frame rendering.
*/

// @import MetalKit;
#import <Flutter/Flutter.h>


// A platform-independent renderer class.
@interface AAPLRenderer : NSObject<FlutterTexture>

// - (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;
- (nonnull instancetype)initWithSize:(CGSize)renderSize
                          onNewFrame:(void(^)(void))onNewFrame;

- (void)dispose;
@end
