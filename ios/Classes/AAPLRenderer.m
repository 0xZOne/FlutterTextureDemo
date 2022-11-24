/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation for a renderer class that performs Metal setup and
 per-frame rendering.
*/

@import MetalKit;

#import "AAPLRenderer.h"

// The main class performing the rendering.
@implementation AAPLRenderer
{
    // Texture to render to and then sample from.
    id<MTLTexture> _renderTargetTexture;

    // Render pass descriptor to draw to the texture
    MTLRenderPassDescriptor* _renderToTextureRenderPassDescriptor;

    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    IOSurfaceRef _ioSurface;
    CADisplayLink* _displayLink;
    void(^_onNewFrame)(void);
    CGSize _renderSize;
    CGFloat _tick;
}

- (void)recreateIOSurfaceWithSize:(CGSize)size {
  if (_ioSurface) {
    CFRelease(_ioSurface);
  }

  unsigned pixelFormat = 'BGRA';
  unsigned bytesPerElement = 4;

  size_t bytesPerRow = IOSurfaceAlignProperty(kIOSurfaceBytesPerRow, size.width * bytesPerElement);
  size_t totalBytes = IOSurfaceAlignProperty(kIOSurfaceAllocSize, size.height * bytesPerRow);
  NSDictionary* options = @{
    (id)kIOSurfaceWidth : @(size.width),
    (id)kIOSurfaceHeight : @(size.height),
    (id)kIOSurfacePixelFormat : @(pixelFormat),
    (id)kIOSurfaceBytesPerElement : @(bytesPerElement),
    (id)kIOSurfaceBytesPerRow : @(bytesPerRow),
    (id)kIOSurfaceAllocSize : @(totalBytes),
  };

  _ioSurface = IOSurfaceCreate((CFDictionaryRef)options);
  IOSurfaceSetValue(_ioSurface, CFSTR("IOSurfaceColorSpace"), kCGColorSpaceSRGB);
}

/// Initializes the renderer with the MetalKit view from which you obtain the Metal device.
- (nonnull instancetype)initWithSize:(CGSize)renderSize
                          onNewFrame:(void(^)(void))onNewFrame {
    self = [super init];
    if(self)
    {
        _renderSize = renderSize;
        _onNewFrame = onNewFrame;

        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

        // 1. Creating an MTLDevice
        _device = MTLCreateSystemDefaultDevice();

        // 2. Creating a MTLCommandQueue
        _commandQueue = [_device newCommandQueue];

        // 3. Creating a IOSurface
        [self recreateIOSurfaceWithSize: _renderSize];

        // 4. Set up a texture for rendering to
        MTLTextureDescriptor *texDescriptor = [MTLTextureDescriptor new];
        texDescriptor.textureType = MTLTextureType2D;
        texDescriptor.width = _renderSize.width;
        texDescriptor.height = _renderSize.height;
        texDescriptor.pixelFormat = MTLPixelFormatRGBA8Unorm;
        texDescriptor.usage = MTLTextureUsageRenderTarget |
                            MTLTextureUsageShaderRead;
        _renderTargetTexture = [_device newTextureWithDescriptor:texDescriptor
                                                       iosurface:_ioSurface
                                                           plane:0];

        // 5. Set up a render pass descriptor for the render pass to render into _renderTargetTexture.
        _renderToTextureRenderPassDescriptor = [MTLRenderPassDescriptor new];
        _renderToTextureRenderPassDescriptor.colorAttachments[0].texture = _renderTargetTexture;
        _renderToTextureRenderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        _renderToTextureRenderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 0.0, 0.0, 1.0);
        _renderToTextureRenderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    }
    return self;
}

// Handles view rendering for a new frame.
- (void)onDisplayLink {
     // Create a new command buffer for each render pass to the current drawable.
     id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
     commandBuffer.label = @"Command Buffer";

    _tick = _tick + M_PI / 60;
    CGFloat green = (sin(_tick) + 1) / 2;

    _renderToTextureRenderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, green, 0.0, 1.0);

     // Create a render command encoder.
     id<MTLRenderCommandEncoder> renderEncoder =
         [commandBuffer renderCommandEncoderWithDescriptor:_renderToTextureRenderPassDescriptor];
     renderEncoder.label = @"Offscreen Render Pass";

     // End encoding commands for this render pass.
     [renderEncoder endEncoding];

    // Finalize rendering here & push the command buffer to the GPU.
     [commandBuffer commit];
    _onNewFrame();
}

- (CVPixelBufferRef)pixelBuffer {
  CVPixelBufferRef pixelBuffer = NULL;
  CVReturn cvValue =
      CVPixelBufferCreateWithIOSurface(kCFAllocatorDefault, _ioSurface, NULL, &pixelBuffer);
  NSAssert(cvValue == kCVReturnSuccess && pixelBuffer != NULL, @"Failed to create pixel buffer.");
  return pixelBuffer;
}

- (void)dispose {
    _device = nil;
    _commandQueue = nil;
    if (_ioSurface) {
        CFRelease(_ioSurface);
    }
    _ioSurface = nil;
}

#pragma mark - FlutterTexture

- (CVPixelBufferRef _Nullable)copyPixelBuffer {
  return [self pixelBuffer];
}

@end
