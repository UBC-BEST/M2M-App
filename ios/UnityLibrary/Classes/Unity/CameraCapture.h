#pragma once

#import <AVFoundation/AVFoundation.h>

@interface CameraCaptureController : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureDataOutputSynchronizerDelegate>

- (bool)initCapture:(AVCaptureDevice*)device;
- (bool)initCapture:(AVCaptureDevice*)device preset:(NSString*)preset fps:(float)fps;
- (void)setCaptureFPS:(float)fps;
- (bool)initColorAndDepthCameraCapture:(AVCaptureDevice*)device preset:(NSString*)preset fps:(float)fps isDepth:(bool)isDepth;
- (void)initColorAndDepthCameraCaptureSession;
- (void)clearColorAndDepthCameraCaptureSession;
- (void)captureOutput:(AVCaptureOutput*)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection*)connection;
- (void)depthDataOutput:(AVCaptureDepthDataOutput*)captureDepthOutput didOutputDepthData:(AVDepthData*)depthData  timestamp:(CMTime)timestamp connection:(AVCaptureConnection*)connection;
- (void)dataOutputSynchronizer:(AVCaptureDataOutputSynchronizer *)synchronizer didOutputSynchronizedDataCollection:(AVCaptureSynchronizedDataCollection *)synchronizedDataCollection;
+ (NSMutableArray<CameraCaptureController*>*)getActiveColorAndDepthCameraControllers;
+ (void)addColorAndDepthCameraController:(CameraCaptureController*)controller;
+ (void)removeColorAndDepthCameraController:(CameraCaptureController*)controller;
+ (void)clearColorAndDepthCameraControllers;
+ (CameraCaptureController*)findColorAndDepthCameraController:(AVCaptureDevice*)device isDepth:(bool)isDepth;
- (void)capturePixelBufferToMemBuffer:(uint8_t*)dst;
- (int)isCVTextureFlipped;
+ (BOOL)focusPointSupported:(AVCaptureDevice*)captureDevice withFocusMode:(AVCaptureFocusMode)focusMode;
- (int)setFocusPointWithX:(float)x Y:(float)y;
- (int)setFocusPoint;

- (void)start;
- (void)pause;
- (void)stop;

@property (nonatomic, retain) AVCaptureDevice*          captureDevice;
@property (nonatomic, retain) AVCaptureSession*         captureSession;
@property (nonatomic, retain) AVCaptureDeviceInput*     captureInput;
@property (nonatomic, retain) AVCaptureVideoDataOutput* captureOutput;
@property (nonatomic, retain) AVCaptureDepthDataOutput* captureDepthOutput;
@property (nonatomic, retain) AVCaptureDataOutputSynchronizer*    captureSynchronizer;

- (float)pickAvailableFrameRate:(float)fps;

@end

enum WebCamKind
{
    kWebCamWideAngle = 1,
    kWebCamTelephoto = 2,
    kWebCamColorAndDepth = 3,
    kWebCamUltraWideAngle = 4,
};

@interface CameraCaptureDevice : NSObject
- (bool)isColorAndDepthCaptureDevice;
- (WebCamKind)getKind;
- (void)fillCaptureDeviceResolutions;
- (NSString*)pickPresetFromWidth:(int)w height:(int)h;
- (bool)initCaptureForController:(CameraCaptureController*)controller width:(int)w height:(int)h fps:(float)fps isDepth:(bool)isDepth;
+ (bool)initialized;
+ (void)createCameraCaptureDevicesArray;
+ (void)addCameraCaptureDevice:(AVCaptureDevice*)device;
@end
