#pragma once

// we are still allowing to build with older sdk and run on simulator without metal support (pre MacOS 10.15)
// it is expected to substitute Metal.h so we assume this is used only with objc

#ifdef __cplusplus
extern "C" typedef MTLDeviceRef (*MTLCreateSystemDefaultDeviceFunc)();
#else
typedef MTLDeviceRef (*MTLCreateSystemDefaultDeviceFunc)();
#endif

#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>
