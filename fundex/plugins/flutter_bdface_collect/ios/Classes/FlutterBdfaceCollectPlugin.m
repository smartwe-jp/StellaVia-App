#import "FlutterBdfaceCollectPlugin.h"

#import <BDFaceBaseKit/BDFaceBaseKit.h>

#import "MethodConstants.h"

static NSString *const kBdFaceChannelName = @"com.fluttercandies.bdface_collect";
static NSString *const kDefaultLicenseName = @"idl-license.face-ios";
static NSString *const kDefaultEncryptKeyName = @"idl-key.face-ios";

@interface FlutterBdfaceCollectPlugin ()

@property (nonatomic, assign) BOOL didInitSdk;

@end

@implementation FlutterBdfaceCollectPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:kBdFaceChannelName
                                                              binaryMessenger:[registrar messenger]];
  FlutterBdfaceCollectPlugin *instance = [[FlutterBdfaceCollectPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if ([call.method isEqualToString:GetPlatformVersion]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([call.method isEqualToString:Init]) {
    [self initSdk:call.arguments result:result];
  } else if ([call.method isEqualToString:Collect]) {
    [self collect:call.arguments result:result];
  } else if ([call.method isEqualToString:UnInit]) {
    [self unInit:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)initSdk:(id)arguments result:(FlutterResult)result {
  NSString *licenseId = nil;
  NSString *licenseName = kDefaultLicenseName;
  NSString *encryptKeyName = kDefaultEncryptKeyName;

  if ([arguments isKindOfClass:[NSString class]]) {
    licenseId = (NSString *)arguments;
  } else if ([arguments isKindOfClass:[NSDictionary class]]) {
    NSDictionary *argumentMap = (NSDictionary *)arguments;
    licenseId = argumentMap[@"licenseId"] ?: argumentMap[@"licenseID"];
    licenseName = argumentMap[@"licenseName"] ?: kDefaultLicenseName;
    encryptKeyName = argumentMap[@"encryptKeyName"] ?: kDefaultEncryptKeyName;
  }

  if (licenseId.length == 0) {
    result(@"licenseId不能为空");
    return;
  }

  BDFaceBaseKitParamsCustomConfigItem *paramsConfig =
      [[BDFaceBaseKitParamsCustomConfigItem alloc] initWithParamsConfig];
  BDFaceBaseKitUICustomConfigItem *uiConfig =
      [[BDFaceBaseKitUICustomConfigItem alloc] initWithUIConfig];
  BDFaceBaseKitLivenessTipCustomConfigItem *tipConfig =
      [[BDFaceBaseKitLivenessTipCustomConfigItem alloc] initWithLivenessTipConfig];

  [[BDFaceBaseKitManager sharedInstance] setFaceSdkCustomParamsConfig:paramsConfig];
  [[BDFaceBaseKitManager sharedInstance] setFaceSdkCustomUIConfig:uiConfig];
  [[BDFaceBaseKitManager sharedInstance] setFaceSdkCustomLivenessTipConfig:tipConfig];

  [[BDFaceBaseKitManager sharedInstance]
      initCollectWithLicenseID:licenseId
             andLocalLicenceName:licenseName
               andEncryptKeyName:encryptKeyName
                    andExtradata:@{}
                       callback:^(BDFaceInitRemindCode code, NSDictionary *extradata) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                           if (code == BDFaceInitOK) {
                             self.didInitSdk = YES;
                             result(nil);
                           } else {
                             self.didInitSdk = NO;
                             result([self faceInitErrorMessageForCode:code]);
                           }
                         });
                       }];
}

- (void)unInit:(FlutterResult)result {
  self.didInitSdk = NO;
  [[BDFaceBaseKitManager sharedInstance] uninitCollect];
  result(nil);
}

- (void)collect:(NSDictionary *)faceConfigMap result:(FlutterResult)result {
  if (![faceConfigMap isKindOfClass:[NSDictionary class]]) {
    result(@{@"error" : @"采集参数无效"});
    return;
  }

  if (!self.didInitSdk) {
    result(@{@"error" : @"SDK未初始化"});
    return;
  }

  dispatch_async(dispatch_get_main_queue(), ^{
    UIViewController *topController = [self topViewController];
    if (topController == nil) {
      result(@{@"error" : @"无法获取当前页面"});
      return;
    }

    BDFaceBaseKitParamsCustomConfigItem *paramsConfig =
        [self paramsConfigFromFaceConfig:faceConfigMap];
    [[BDFaceBaseKitManager sharedInstance] setFaceSdkCustomParamsConfig:paramsConfig];

    __block BOOL didReturnResult = NO;
    [[BDFaceBaseKitManager sharedInstance]
        startWithCurrentController:topController
                       andExtradata:@{}
                          callback:^(BDFaceCompletionStatusCode code, NSDictionary *sdkResult) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              if (didReturnResult) {
                                return;
                              }

                              if (code == BDFaceStatusIsRunning) {
                                return;
                              }

                              didReturnResult = YES;
                              if (code == BDFaceStatusSuccess) {
                                NSDictionary *payload = [self payloadFromSdkResult:sdkResult];
                                if (payload != nil) {
                                  result(payload);
                                } else {
                                  result(@{@"error" : @"采集成功但未获取到图片数据"});
                                }
                                return;
                              }

                              if (code == BDFaceStatusCancel) {
                                result(nil);
                                return;
                              }

                              result(@{@"error" : [self collectErrorMessageForCode:code]});
                            });
                          }];
  });
}

- (BDFaceBaseKitParamsCustomConfigItem *)paramsConfigFromFaceConfig:(NSDictionary *)faceConfigMap {
  BDFaceBaseKitParamsCustomConfigItem *config =
      [[BDFaceBaseKitParamsCustomConfigItem alloc] initWithParamsConfig];

  NSNumber *minFaceSize = faceConfigMap[@"minFaceSize"];
  NSNumber *notFace = faceConfigMap[@"notFace"];
  NSNumber *brightness = faceConfigMap[@"brightness"];
  NSNumber *brightnessMax = faceConfigMap[@"brightnessMax"];
  NSNumber *blurness = faceConfigMap[@"blurness"];
  NSNumber *occlusionLeftEye = faceConfigMap[@"occlusionLeftEye"];
  NSNumber *occlusionRightEye = faceConfigMap[@"occlusionRightEye"];
  NSNumber *occlusionNose = faceConfigMap[@"occlusionNose"];
  NSNumber *occlusionMouth = faceConfigMap[@"occlusionMouth"];
  NSNumber *occlusionLeftContour = faceConfigMap[@"occlusionLeftContour"];
  NSNumber *occlusionRightContour = faceConfigMap[@"occlusionRightContour"];
  NSNumber *occlusionChin = faceConfigMap[@"occlusionChin"];
  NSNumber *headPitch = faceConfigMap[@"headPitch"];
  NSNumber *headYaw = faceConfigMap[@"headYaw"];
  NSNumber *headRoll = faceConfigMap[@"headRoll"];
  NSNumber *eyeClosed = faceConfigMap[@"eyeClosed"];
  NSNumber *scale = faceConfigMap[@"scale"];
  NSNumber *cropHeight = faceConfigMap[@"cropHeight"];
  NSNumber *cropWidth = faceConfigMap[@"cropWidth"];
  NSNumber *enlargeRatio = faceConfigMap[@"enlargeRatio"];
  NSNumber *faceFarRatio = faceConfigMap[@"faceFarRatio"];
  NSNumber *faceClosedRatio = faceConfigMap[@"faceClosedRatio"];
  NSNumber *sound = faceConfigMap[@"sound"];
  NSNumber *livenessRandom = faceConfigMap[@"livenessRandom"];
  NSArray *livenessTypes = faceConfigMap[@"livenessTypes"];

  if (minFaceSize != nil) config.minFaceSize = minFaceSize.intValue;
  if (notFace != nil) config.notRGBFaceThreshold = notFace.floatValue;
  if (brightness != nil) config.minIllumThr = brightness.floatValue;
  if (brightnessMax != nil) config.maxIllumThr = brightnessMax.floatValue;
  if (blurness != nil) config.blurThr = blurness.floatValue;
  if (occlusionLeftEye != nil) config.leftEyeOcclus = occlusionLeftEye.floatValue;
  if (occlusionRightEye != nil) config.rightEyeOcclus = occlusionRightEye.floatValue;
  if (occlusionNose != nil) config.noseOcclus = occlusionNose.floatValue;
  if (occlusionMouth != nil) config.mouthOcclus = occlusionMouth.floatValue;
  if (occlusionLeftContour != nil) config.leftCheekOcclus = occlusionLeftContour.floatValue;
  if (occlusionRightContour != nil) config.rightCheekOcclus = occlusionRightContour.floatValue;
  if (occlusionChin != nil) config.chinOcclus = occlusionChin.floatValue;
  if (headPitch != nil) config.pitchThr = headPitch.floatValue;
  if (headYaw != nil) config.yawThr = headYaw.floatValue;
  if (headRoll != nil) config.rollThr = headRoll.floatValue;
  if (eyeClosed != nil) config.eyeCloseValue = eyeClosed.floatValue;
  if (scale != nil) config.imageScale = scale.floatValue;
  if (cropHeight != nil) config.height = cropHeight.intValue;
  if (cropWidth != nil) config.width = cropWidth.intValue;
  if (enlargeRatio != nil) config.enlarge_ratio = enlargeRatio.floatValue;
  if (faceFarRatio != nil) config.minRectScale = faceFarRatio.floatValue;
  if (faceClosedRatio != nil) config.maxRectScale = faceClosedRatio.floatValue;

  config.maxCropImageNum = 3;
  config.isSoundMode = sound.boolValue;
  config.conditionTimeout = 20;
  config.isPopWindow = YES;
  config.isCompressImage = YES;
  config.compressValue = 300;
  config.checkAgreeBtn = NO;
  config.isIntoResultView = NO;
  config.isCheckColorfulLive = NO;
  config.isColorType = NO;
  config.isOpenDistanceLive = NO;
  config.isOpenRearCamera = NO;
  config.qualityLevel = 1;

  NSMutableArray *liveActionArray = [NSMutableArray array];
  for (NSString *typeStr in livenessTypes) {
    NSNumber *action = [self nativeActionForCode:typeStr];
    if (action != nil) {
      [liveActionArray addObject:action];
    }
  }

  config.liveActionArray = liveActionArray;
  config.numOfLiveness = (int)liveActionArray.count;
  config.actionLiveSelectNum = (int)liveActionArray.count;
  config.isLivenessRandom = livenessRandom.boolValue;
  config.isLivenessType = liveActionArray.count > 0;
  config.isStrict = config.isLivenessType;
  if (liveActionArray.count == 0) {
    config.isLivenessType = NO;
    config.actionLiveSelectNum = 0;
    config.numOfLiveness = 0;
  }

  return config;
}

- (NSNumber *)nativeActionForCode:(NSString *)typeStr {
  if (![typeStr isKindOfClass:[NSString class]]) {
    return nil;
  }

  if ([typeStr isEqualToString:@"Eye"]) {
    return @(FaceLivenessActionTypeLiveEye);
  }
  if ([typeStr isEqualToString:@"Mouth"]) {
    return @(FaceLivenessActionTypeLiveMouth);
  }
  if ([typeStr isEqualToString:@"HeadLeft"]) {
    return @(FaceLivenessActionTypeLiveYawLeft);
  }
  if ([typeStr isEqualToString:@"HeadRight"]) {
    return @(FaceLivenessActionTypeLiveYawRight);
  }
  if ([typeStr isEqualToString:@"HeadUp"]) {
    return @(FaceLivenessActionTypeLivePitchUp);
  }
  if ([typeStr isEqualToString:@"HeadDown"]) {
    return @(FaceLivenessActionTypeLivePitchDown);
  }
  return nil;
}

- (NSDictionary *)payloadFromSdkResult:(NSDictionary *)sdkResult {
  NSDictionary *payload = [self payloadFromContainer:sdkResult];
  if (payload != nil) {
    return payload;
  }

  for (NSString *key in @[@"cropImageInfo", @"bestImageInfo", @"faceInfo", @"images", @"imageArr",
                          @"cropImages", @"faceInfos"]) {
    payload = [self payloadFromContainer:[self valueForKey:key inObject:sdkResult]];
    if (payload != nil) {
      return payload;
    }
  }
  return nil;
}

- (NSDictionary *)payloadFromContainer:(id)container {
  if (container == nil || container == [NSNull null]) {
    return nil;
  }

  if ([container isKindOfClass:[NSArray class]]) {
    for (id item in (NSArray *)container) {
      NSDictionary *payload = [self payloadFromContainer:item];
      if (payload != nil) {
        return payload;
      }
    }
    return nil;
  }

  NSString *imageSrcBase64 = [self stringForKey:@"originalImageEncryptStr" inObject:container];
  NSString *imageCropBase64 = [self stringForKey:@"cropImageWithBlackEncryptStr" inObject:container];
  if (imageSrcBase64.length > 0 || imageCropBase64.length > 0) {
    return @{
      @"imageCropBase64" : imageCropBase64 ?: @"",
      @"imageSrcBase64" : imageSrcBase64 ?: @"",
    };
  }

  if ([container isKindOfClass:[NSDictionary class]]) {
    for (NSString *key in @[@"cropImageInfo", @"bestImageInfo", @"faceInfo", @"images", @"imageArr",
                            @"cropImages", @"faceInfos"]) {
      NSDictionary *payload = [self payloadFromContainer:[(NSDictionary *)container objectForKey:key]];
      if (payload != nil) {
        return payload;
      }
    }
  }

  NSDictionary *payload = [self payloadFromContainer:[self valueForKey:@"cropImageInfo" inObject:container]];
  if (payload != nil) {
    return payload;
  }

  return nil;
}

- (id)valueForKey:(NSString *)key inObject:(id)object {
  if (object == nil || key.length == 0) {
    return nil;
  }

  if ([object isKindOfClass:[NSDictionary class]]) {
    return ((NSDictionary *)object)[key];
  }

  @try {
    return [object valueForKey:key];
  } @catch (NSException *exception) {
    return nil;
  }
}

- (NSString *)stringForKey:(NSString *)key inObject:(id)object {
  id value = [self valueForKey:key inObject:object];
  return [value isKindOfClass:[NSString class]] ? value : nil;
}

- (UIViewController *)topViewController {
  UIWindow *keyWindow = nil;
  if (@available(iOS 13.0, *)) {
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
      if (scene.activationState != UISceneActivationStateForegroundActive ||
          ![scene isKindOfClass:[UIWindowScene class]]) {
        continue;
      }
      for (UIWindow *window in ((UIWindowScene *)scene).windows) {
        if (window.isKeyWindow) {
          keyWindow = window;
          break;
        }
      }
      if (keyWindow != nil) {
        break;
      }
    }
  }
  if (keyWindow == nil) {
    keyWindow = [UIApplication sharedApplication].keyWindow;
  }

  UIViewController *controller = keyWindow.rootViewController;
  while (controller.presentedViewController != nil) {
    controller = controller.presentedViewController;
  }
  if ([controller isKindOfClass:[UINavigationController class]]) {
    controller = ((UINavigationController *)controller).visibleViewController;
  }
  if ([controller isKindOfClass:[UITabBarController class]]) {
    controller = ((UITabBarController *)controller).selectedViewController;
  }
  return controller;
}

- (NSString *)faceInitErrorMessageForCode:(BDFaceInitRemindCode)code {
  switch (code) {
    case BDFaceInitOK:
      return @"";
    case BDFaceLICENSE_LOCAL_FILE_ERROR:
      return @"license文件读取失败";
    case BDFaceLICENSE_KEY_CHECK_ERROR:
      return @"licenseId或加密Key校验失败";
    case BDFaceLICENSE_FUNCTION_CHECK_ERROR:
      return @"当前license未开通采集能力";
    case BDFaceLICENSE_TIME_EXPIRED:
      return @"license已过期";
    default:
      return [NSString stringWithFormat:@"初始化失败(%ld)", (long)code];
  }
}

- (NSString *)collectErrorMessageForCode:(BDFaceCompletionStatusCode)code {
  switch (code) {
    case BDFaceStatusSDKNotInit:
      return @"SDK未初始化";
    case BDFaceStatusSDKNotLoad:
      return @"SDK未加载";
    case BDFaceStatusCameraError:
      return @"没有相机权限";
    case BDFaceStatusNetworkError:
      return @"网络异常";
    case BDFaceStatusTimeout:
      return @"采集超时";
    case BDFaceStatusCropImageError:
      return @"抠图失败";
    case BDFaceStatusDetectSilentNoPass:
    case BDFaceStatusLivenessSilentNoPass:
      return @"活体检测未通过";
    case BDFaceStatusLivenessActionNotMatch:
      return @"动作不匹配";
    case BDFaceStatusVideoRecordingFail:
      return @"视频录制失败";
    case BDFaceStatusResultFail:
      return @"图片结果构建失败";
    default:
      return [NSString stringWithFormat:@"采集失败(%ld)", (long)code];
  }
}

@end
