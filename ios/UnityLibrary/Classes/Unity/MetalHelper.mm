#include "UnityTrampolineCompatibility.h"
#include "UnityRendering.h"

#include "UnityMetalSupport.h"
#include <QuartzCore/QuartzCore.h>
#include <libkern/OSAtomic.h>

#if UNITY_TRAMPOLINE_IN_USE
#include "UnityAppController.h"
#include "CVTextureCache.h"
#endif

#include "ObjCRuntime.h"
#include <utility>

extern "C" void InitRenderingMTL()
{
}

static MTLPixelFormat GetColorFormatForSurface(const UnityDisplaySurfaceMTL* surface)
{
    MTLPixelFormat colorFormat = surface->srgb ? MTLPixelFormatBGRA8Unorm_sRGB : MTLPixelFormatBGRA8Unorm;
#if PLATFORM_IOS || PLATFORM_TVOS || PLATFORM_VISIONOS
    if (surface->wideColor && UnityIsWideColorSupported())
        colorFormat = surface->srgb ? MTLPixelFormatBGR10_XR_sRGB : MTLPixelFormatBGR10_XR;
#elif PLATFORM_OSX
    if (surface->hdr)
    {
        if (@available(macOS 10.15, *))
        {   // 0 = 10bit
            colorFormat = UnityHDRSurfaceDepth() == 0 ? MTLPixelFormatRGB10A2Unorm : MTLPixelFormatRGBA16Float;
        }
    }
    else if (surface->wideColor)
        colorFormat = MTLPixelFormatRGBA16Float;
#endif
    return colorFormat;
}

static uint32_t GetCVPixelFormatForSurface(const UnityDisplaySurfaceMTL* surface)
{
    // this makes sense only for ios (at least we dont support this on macos)
    uint32_t colorFormat = kCVPixelFormatType_32BGRA;
#if PLATFORM_IOS || PLATFORM_TVOS || PLATFORM_VISIONOS
    if (surface->wideColor && UnityIsWideColorSupported())
        colorFormat = kCVPixelFormatType_30RGB;
#endif

    return colorFormat;
}

extern "C" void CreateSystemRenderingSurfaceMTL(UnityDisplaySurfaceMTL* surface)
{
    DestroySystemRenderingSurfaceMTL(surface);

    MTLPixelFormat colorFormat = GetColorFormatForSurface(surface);
    surface->layer.presentsWithTransaction = NO;
    surface->layer.drawsAsynchronously = YES;

#if !PLATFORM_OSX
    if (UnityPreserveFramebufferAlpha())
    {
        const CGFloat components[] = {1.0f, 1.0f, 1.0f, 0.0f};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorSpace, components);
        surface->layer.opaque = NO;
        surface->layer.backgroundColor = color;
        CGColorRelease(color);
        CGColorSpaceRelease(colorSpace);
    }
#endif

#if PLATFORM_OSX
    surface->layer.opaque = YES;
    MetalUpdateDisplaySync();
#endif


#if PLATFORM_OSX
    CGColorSpaceRef colorSpaceRef = nil;
    if (surface->hdr)
        if (@available(macOS 11.0, *)) // 0 = 10bit
            colorSpaceRef = UnityHDRSurfaceDepth() == 0 ? CGColorSpaceCreateWithName(CFSTR("kCGColorSpaceITUR_2100_PQ")) : CGColorSpaceCreateWithName(CFSTR("kCGColorSpaceExtendedLinearITUR_2020"));
        else
            colorSpaceRef = UnityHDRSurfaceDepth() == 0 ? CGColorSpaceCreateWithName(CFSTR("kCGColorSpaceITUR_2020_PQ_EOTF")) : CGColorSpaceCreateWithName(CFSTR("kCGColorSpaceExtendedLinearITUR_2020"));
    else if (surface->wideColor)
        colorSpaceRef = CGColorSpaceCreateWithName(surface->srgb ? kCGColorSpaceExtendedLinearSRGB : kCGColorSpaceExtendedSRGB);
    else
        colorSpaceRef = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);

    surface->layer.colorspace = colorSpaceRef;
    CGColorSpaceRelease(colorSpaceRef);
#endif

    // Update the native screen resolution
    UnityUpdateDrawableSize(surface);

    surface->layer.device = surface->device;
    surface->layer.pixelFormat = colorFormat;
    surface->layer.framebufferOnly = (surface->framebufferOnly != 0);
    surface->colorFormat = (unsigned)colorFormat;

    MTLTextureDescriptor* txDesc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat: colorFormat width: surface->systemW height: surface->systemH mipmapped: NO];
#if PLATFORM_OSX
    txDesc.resourceOptions = MTLResourceCPUCacheModeDefaultCache | MTLResourceStorageModeManaged;
#endif
    txDesc.usage = MTLTextureUsageRenderTarget | MTLTextureUsageShaderRead;

    @synchronized(surface->layer)
    {
#if PLATFORM_OSX
        surface->proxySwaps = 0;
        surface->proxyReady = 0;
        surface->calledPresentDrawable = 0;
        surface->vsync = 1; // by default, vsync is enabled for all surfaces
#endif

        for (int i = 0; i < kUnityNumOffscreenSurfaces; i++)
        {
            UnityUnregisterMetalTextureForMemoryProfiler(surface->drawableProxyRT[i]);

            // Allocating a proxy texture is cheap until it's being rendered to and the GPU driver does allocation
            surface->drawableProxyRT[i] = [surface->device newTextureWithDescriptor: txDesc];
            surface->drawableProxyRT[i].label = @"DrawableProxy";

        #if PLATFORM_IOS || PLATFORM_TVOS || PLATFORM_VISIONOS
            [surface->drawableProxyRT[i] setPurgeableState: MTLPurgeableStateEmpty];
        #endif

            // Mark each drawableProxy surface as needing a clear load action when next rendered to as its contents are undefined.
            surface->drawableProxyNeedsClear[i] = true;

            UnityRegisterExternalRenderSurfaceTextureForMemoryProfiler(surface->drawableProxyRT[i]);
        }
    }
}

extern "C" void CreateRenderingSurfaceMTL(UnityDisplaySurfaceMTL* surface)
{
    DestroyRenderingSurfaceMTL(surface);

    MTLPixelFormat colorFormat = GetColorFormatForSurface(surface);

    const int w = surface->targetW, h = surface->targetH;

    if (w != surface->systemW || h != surface->systemH || surface->useCVTextureCache)
    {
#if PLATFORM_IOS || PLATFORM_TVOS || PLATFORM_VISIONOS
        if (surface->useCVTextureCache)
            surface->cvTextureCache = CreateCVTextureCache();

        if (surface->cvTextureCache)
        {
            surface->cvTextureCacheTexture = CreateReadableRTFromCVTextureCache2(surface->cvTextureCache, surface->targetW, surface->targetH,
                GetCVPixelFormatForSurface(surface), colorFormat, &surface->cvPixelBuffer);
            surface->targetColorRT = GetMetalTextureFromCVTextureCache(surface->cvTextureCacheTexture);
        }
        else
#endif
        {
            MTLTextureDescriptor* txDesc = [MTLTextureDescriptor new];
            txDesc.textureType = MTLTextureType2D;
            txDesc.width = w;
            txDesc.height = h;
            txDesc.depth = 1;
            txDesc.pixelFormat = colorFormat;
            txDesc.arrayLength = 1;
            txDesc.mipmapLevelCount = 1;
#if PLATFORM_OSX
            txDesc.resourceOptions = MTLResourceStorageModeManaged;
#endif
            txDesc.usage = MTLTextureUsageRenderTarget | MTLTextureUsageShaderRead;
            surface->targetColorRT = [surface->device newTextureWithDescriptor: txDesc];
        }
        surface->targetColorRT.label = @"targetColorRT";

        UnityRegisterExternalRenderSurfaceTextureForMemoryProfiler(surface->targetColorRT);
    }

    if (surface->msaaSamples > 1)
    {
        MTLTextureDescriptor* txDesc = [MTLTextureDescriptor new];
        txDesc.textureType = MTLTextureType2DMultisample;
        txDesc.width = w;
        txDesc.height = h;
        txDesc.depth = 1;
        txDesc.pixelFormat = colorFormat;
        txDesc.arrayLength = 1;
        txDesc.mipmapLevelCount = 1;
        txDesc.sampleCount = surface->msaaSamples;
        txDesc.resourceOptions = MTLResourceStorageModePrivate;
        txDesc.usage = MTLTextureUsageRenderTarget | MTLTextureUsageShaderRead;
        if (![surface->device supportsTextureSampleCount: txDesc.sampleCount])
            txDesc.sampleCount = 4;
        surface->targetAAColorRT = [surface->device newTextureWithDescriptor: txDesc];
        surface->targetAAColorRT.label = @"targetAAColorRT";

        UnityRegisterExternalRenderSurfaceTextureForMemoryProfiler(surface->targetAAColorRT);
    }
}

extern "C" void DestroyRenderingSurfaceMTL(UnityDisplaySurfaceMTL* surface)
{
    UnityUnregisterMetalTextureForMemoryProfiler(surface->targetColorRT);
    surface->targetColorRT = nil;
    UnityUnregisterMetalTextureForMemoryProfiler(surface->targetAAColorRT);
    surface->targetAAColorRT = nil;

    if (surface->cvTextureCacheTexture)
        CFRelease(surface->cvTextureCacheTexture);
    if (surface->cvPixelBuffer)
        CFRelease(surface->cvPixelBuffer);
    if (surface->cvTextureCache)
        CFRelease(surface->cvTextureCache);
    surface->cvTextureCache = 0;
}

extern "C" void CreateSharedDepthbufferMTL(UnityDisplaySurfaceMTL* surface)
{
    DestroySharedDepthbufferMTL(surface);
    if (surface->disableDepthAndStencil)
        return;

    MTLPixelFormat pixelFormat = MTLPixelFormatDepth32Float_Stencil8;

    MTLTextureDescriptor* depthTexDesc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat: pixelFormat width: surface->targetW height: surface->targetH mipmapped: NO];
    depthTexDesc.resourceOptions = MTLResourceStorageModePrivate;

#if PLATFORM_IOS || PLATFORM_TVOS || PLATFORM_VISIONOS
    if (surface->memorylessDepth)
        depthTexDesc.storageMode = MTLStorageModeMemoryless;
#endif

    depthTexDesc.usage = MTLTextureUsageRenderTarget | MTLTextureUsageShaderRead;
    if (surface->msaaSamples > 1)
    {
        depthTexDesc.textureType = MTLTextureType2DMultisample;
        depthTexDesc.sampleCount = surface->msaaSamples;
        if (![surface->device supportsTextureSampleCount: depthTexDesc.sampleCount])
            depthTexDesc.sampleCount = 4;
    }
    surface->depthRB = [surface->device newTextureWithDescriptor: depthTexDesc];
    surface->stencilRB = surface->depthRB;
    UnityRegisterExternalRenderSurfaceTextureForMemoryProfiler(surface->depthRB);
}

extern "C" void DestroySharedDepthbufferMTL(UnityDisplaySurfaceMTL* surface)
{
    UnityUnregisterMetalTextureForMemoryProfiler(surface->depthRB);
    surface->depthRB = nil;
    surface->stencilRB = nil;
}

extern "C" void CreateUnityRenderBuffersMTL(UnityDisplaySurfaceMTL* surface)
{
    UnityRenderBufferDesc sys_desc = { surface->systemW, surface->systemH, 1, 1, 1 };
    UnityRenderBufferDesc tgt_desc = { surface->targetW, surface->targetH, 1, (unsigned int)surface->msaaSamples, 1 };

    // note that StartFrameRenderingMTL/AcquireDrawableMTL/EndFrameRenderingMTL happen on the render thread
    // while CreateUnityRenderBuffersMTL/DestroyUnityRenderBuffersMTL happen on main
    MTLTextureRef systemColorRB = nil;
    @synchronized(surface->layer)
    {
        for (unsigned i = 0; i < kUnityNumOffscreenSurfaces; ++i)
            surface->drawableProxyRS[i] = UnityCreateExternalColorSurfaceMTL(surface->drawableProxyRS[i], surface->drawableProxyRT[i], nil, &sys_desc, surface);
        systemColorRB = surface->drawableProxyRT[0];
    }

    surface->systemColorRB = systemColorRB;

    // we could unify all of it with ugly chain of ternary operators but what if karma exists?
    if (surface->targetColorRT)
    {
        // render to interim RT: we do NOT need to request drawable
        MTLTextureRef texRender     = surface->targetAAColorRT ? surface->targetAAColorRT : surface->targetColorRT;
        MTLTextureRef texResolve    = surface->targetAAColorRT ? surface->targetColorRT : nil;
        surface->unityColorBuffer   = UnityCreateExternalColorSurfaceMTL(surface->unityColorBuffer, texRender, texResolve, &tgt_desc, nil);
    }
    else
    {
        // render to backbuffer directly: we will request drawable hence we need to pass surface
        MTLTextureRef texRender     = surface->targetAAColorRT ? surface->targetAAColorRT : systemColorRB;
        MTLTextureRef texResolve    = surface->targetAAColorRT ? systemColorRB : nil;

        surface->unityColorBuffer   = UnityCreateExternalColorSurfaceMTL(surface->unityColorBuffer, texRender, texResolve, &tgt_desc, surface);
    }

    if (surface->depthRB)
        surface->unityDepthBuffer   = UnityCreateExternalDepthSurfaceMTL(surface->unityDepthBuffer, surface->depthRB, surface->stencilRB, &tgt_desc);
    else
        surface->unityDepthBuffer   = UnityCreateDummySurface(surface->unityDepthBuffer, false, &tgt_desc);

    surface->systemColorBuffer = UnityCreateExternalColorSurfaceMTL(surface->systemColorBuffer, systemColorRB, nil, &sys_desc, surface);
    surface->systemDepthBuffer = UnityCreateDummySurface(surface->systemDepthBuffer, false, &sys_desc);
}

extern "C" void DestroySystemRenderingSurfaceMTL(UnityDisplaySurfaceMTL* surface)
{
    // before we needed to nil surface->systemColorRB (to release drawable we get from the view)
    // but after we switched to proxy rt this is no longer needed
    // even more it is harmful when running rendering on another thread (as is default now)
    // as on render thread we do StartFrameRenderingMTL/AcquireDrawableMTL/EndFrameRenderingMTL
    // and DestroySystemRenderingSurfaceMTL comes on main thread so we might end up with race condition for no reason
}

extern "C" void DestroyUnityRenderBuffersMTL(UnityDisplaySurfaceMTL* surface)
{
    UnityDestroyExternalSurface(surface->unityColorBuffer);
    UnityDestroyExternalSurface(surface->systemColorBuffer);
    surface->unityColorBuffer = surface->systemColorBuffer = 0;

    UnityDestroyExternalSurface(surface->unityDepthBuffer);
    UnityDestroyExternalSurface(surface->systemDepthBuffer);
    surface->unityDepthBuffer = surface->systemDepthBuffer = 0;

    @synchronized(surface->layer)
    {
        for (unsigned i = 0; i < kUnityNumOffscreenSurfaces; ++i)
        {
            UnityDestroyExternalSurface(surface->drawableProxyRS[i]);
            surface->drawableProxyRS[i] = 0;
        }
    }
}

extern "C" void PreparePresentMTL(UnityDisplaySurfaceMTL* surface)
{
    if (surface->targetColorRT)
        UnityBlitToBackbuffer(surface->unityColorBuffer, surface->systemColorBuffer, surface->systemDepthBuffer);
#if UNITY_TRAMPOLINE_IN_USE
    APP_CONTROLLER_RENDER_PLUGIN_METHOD(onFrameResolved);
#endif
}

extern "C" void PresentMTL(UnityDisplaySurfaceMTL* surface)
{
    if (surface->drawable)
    {
        // for some reason presentDrawable: afterMinimumDuration: is missing from simulator headers completely in xcode 12
    #if (PLATFORM_IOS || PLATFORM_TVOS || PLATFORM_VISIONOS) && !(TARGET_IPHONE_SIMULATOR || TARGET_TVOS_SIMULATOR)
        const int targetFPS = UnityGetTargetFPS(); assert(targetFPS > 0);
        [UnityCurrentMTLCommandBuffer() presentDrawable: surface->drawable afterMinimumDuration: 1.0 / targetFPS];
        return;
    #endif

        // note that we end up here if presentDrawable: afterMinimumDuration: is not supported
        [UnityCurrentMTLCommandBuffer() presentDrawable: surface->drawable];
    }
    surface->calledPresentDrawable = 1;
}

extern "C" MTLTextureRef AcquireDrawableMTL(UnityDisplaySurfaceMTL* surface)
{
    if (!surface)
        return nil;

    if (!surface->drawable)
        surface->drawable = [surface->layer nextDrawable];

    // on A7 SoC nextDrawable may be nil before locking the screen
    if (!surface->drawable)
        return nil;

    id<MTLTexture> drawableTex = [surface->drawable texture];

    UnityUnregisterMetalTextureForMemoryProfiler(surface->drawableTex);
    surface->drawableTex = surface->systemColorRB = drawableTex;
    UnityRegisterExternalRenderSurfaceTextureForMemoryProfiler(drawableTex);

    return drawableTex;
}

extern "C" int UnityCommandQueueMaxCommandBufferCountMTL()
{
    // customizable argument to pass towards [MTLDevice newCommandQueueWithMaxCommandBufferCount:],
    // the default value is 64 but with Parallel Render Encoder workloads, it might need to be increased

    return 256;
}

extern "C" void StartFrameRenderingMTL(UnityDisplaySurfaceMTL* surface)
{
    // we will acquire drawable lazily in AcquireDrawableMTL
    if (surface->drawableTex)
        UnityUnregisterMetalTextureForMemoryProfiler(surface->drawableTex);

    surface->drawable = nil;
    surface->drawableTex = nil;
    surface->systemColorRB = surface->drawableProxyRT[0];

    UnityRenderBufferDesc sys_desc = { surface->systemW, surface->systemH, 1, 1, 1};
    UnityRenderBufferDesc tgt_desc = { surface->targetW, surface->targetH, 1, (unsigned int)surface->msaaSamples, 1};

    surface->systemColorBuffer = UnityCreateExternalColorSurfaceMTL(surface->systemColorBuffer, surface->systemColorRB, nil, &sys_desc, surface);
    if (surface->targetColorRT == nil)
    {
        if (surface->targetAAColorRT)
            surface->unityColorBuffer = UnityCreateExternalColorSurfaceMTL(surface->unityColorBuffer, surface->targetAAColorRT, surface->systemColorRB, &tgt_desc, surface);
        else
            surface->unityColorBuffer = UnityCreateExternalColorSurfaceMTL(surface->unityColorBuffer, surface->systemColorRB, nil, &tgt_desc, surface);
    }
}

extern "C" void EndFrameRenderingMTL(UnityDisplaySurfaceMTL* surface)
{
    @autoreleasepool
    {
        if (surface->drawableTex)
            UnityUnregisterMetalTextureForMemoryProfiler(surface->drawableTex);

        surface->drawable = nil;
        surface->drawableTex = nil;
        surface->systemColorRB = surface->drawableProxyRT[0];
    }

#if PLATFORM_OSX
    @synchronized(surface->layer)
    {
        if (!surface->calledPresentDrawable)
            return;
        surface->calledPresentDrawable = 0;
        std::swap(surface->drawableProxyRT[0], surface->drawableProxyRT[1]);
        std::swap(surface->drawableProxyRS[0], surface->drawableProxyRS[1]);
        surface->proxySwaps++;
        surface->proxyReady = 1;

        // Swap the needs clear state of the swapped proxy buffers, to ensure that each surface
        // will get cleared at least once when the proxy buffer surfaces are recreated.
        std::swap(surface->drawableProxyNeedsClear[0],
            surface->drawableProxyNeedsClear[1]);
    }
#endif
}

extern "C" void PreparePresentNonMainScreenMTL(UnityDisplaySurfaceMTL* surface)
{
    if (surface->drawable)
        [UnityCurrentMTLCommandBuffer() presentDrawable: surface->drawable];
}

extern "C" void SetDrawableSizeMTL(UnityDisplaySurfaceMTL* surface, int width, int height)
{
    surface->layer.drawableSize = CGSizeMake(width, height);
}
