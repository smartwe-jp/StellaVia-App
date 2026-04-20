#import "FlutterBdfaceCollectPlugin.h"

#import <TargetConditionals.h>

#if !TARGET_OS_SIMULATOR
#import <BDFaceBaseKit/BDFaceBaseKit.h>
#endif

#import "MethodConstants.h"

static NSString *const kBdFaceChannelName = @"com.fluttercandies.bdface_collect";
static NSString *const kDefaultLicenseName = @"idl-license.face-ios";
static NSString *const kDefaultEncryptKeyName = @"idl-key.face-ios";

@interface FlutterBdfaceCollectPlugin ()

@property (nonatomic, assign) BOOL didInitSdk;
@property (nonatomic, copy) NSString *preferredLocaleTag;
@property (nonatomic, strong) NSTimer *uiLocalizationTimer;

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
#if TARGET_OS_SIMULATOR
  self.didInitSdk = NO;
  result([self unsupportedSimulatorMessage]);
  return;
#else
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
    [self updatePreferredLocaleTag:argumentMap[@"localeTag"]];
  }

  if (licenseId.length == 0) {
    result([self localizedStringForLocale:[self currentLivenessLocaleCode]
                                  chinese:@"licenseId不能为空"
                                  english:@"licenseId is required"
                       traditionalChinese:@"licenseId 不可為空"
                                 japanese:@"licenseId は必須です"]);
    return;
  }

  BDFaceBaseKitParamsCustomConfigItem *paramsConfig =
      [[BDFaceBaseKitParamsCustomConfigItem alloc] initWithParamsConfig];
  BDFaceBaseKitUICustomConfigItem *uiConfig =
      [[BDFaceBaseKitUICustomConfigItem alloc] initWithUIConfig];
  BDFaceBaseKitLivenessTipCustomConfigItem *tipConfig =
      [[BDFaceBaseKitLivenessTipCustomConfigItem alloc] initWithLivenessTipConfig];
  NSString *localeCode = [self currentLivenessLocaleCode];

  [self applyLocalizationToParamsConfig:paramsConfig localeCode:localeCode];
  [self applyLocalizationToTipConfig:tipConfig localeCode:localeCode];

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
#endif
}

- (void)unInit:(FlutterResult)result {
  self.didInitSdk = NO;
#if !TARGET_OS_SIMULATOR
  [self stopUiLocalizationMonitoring];
  [[BDFaceBaseKitManager sharedInstance] uninitCollect];
#endif
  result(nil);
}

- (void)collect:(NSDictionary *)faceConfigMap result:(FlutterResult)result {
#if TARGET_OS_SIMULATOR
  result(@{@"error" : [self unsupportedSimulatorMessage]});
  return;
#else
  if ([faceConfigMap isKindOfClass:[NSDictionary class]]) {
    [self updatePreferredLocaleTag:faceConfigMap[@"localeTag"]];
  }

  if (![faceConfigMap isKindOfClass:[NSDictionary class]]) {
    result(@{
      @"error" : [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                        chinese:@"采集参数无效"
                                        english:@"Invalid collect arguments"
                             traditionalChinese:@"採集參數無效"
                                       japanese:@"収集パラメータが無効です"]
    });
    return;
  }

  if (!self.didInitSdk) {
    result(@{
      @"error" : [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                        chinese:@"SDK未初始化"
                                        english:@"SDK not initialized"
                             traditionalChinese:@"SDK 尚未初始化"
                                       japanese:@"SDK が初期化されていません"]
    });
    return;
  }

  dispatch_async(dispatch_get_main_queue(), ^{
    UIViewController *topController = [self topViewController];
    if (topController == nil) {
      result(@{
        @"error" : [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                          chinese:@"无法获取当前页面"
                                          english:@"Unable to resolve the current page"
                               traditionalChinese:@"無法取得目前頁面"
                                         japanese:@"現在の画面を取得できません"]
      });
      return;
    }

    BDFaceBaseKitParamsCustomConfigItem *paramsConfig =
        [self paramsConfigFromFaceConfig:faceConfigMap];
    NSString *localeCode = [self currentLivenessLocaleCode];
    BDFaceBaseKitLivenessTipCustomConfigItem *tipConfig =
        [[BDFaceBaseKitLivenessTipCustomConfigItem alloc] initWithLivenessTipConfig];
    [self applyLocalizationToParamsConfig:paramsConfig localeCode:localeCode];
    [self applyLocalizationToTipConfig:tipConfig localeCode:localeCode];
    [[BDFaceBaseKitManager sharedInstance] setFaceSdkCustomParamsConfig:paramsConfig];
    [[BDFaceBaseKitManager sharedInstance] setFaceSdkCustomLivenessTipConfig:tipConfig];
    [self startUiLocalizationMonitoringIfNeededForLocale:localeCode];

    __block BOOL didReturnResult = NO;
    [[BDFaceBaseKitManager sharedInstance]
        startWithCurrentController:topController
                       andExtradata:@{}
                          callback:^(BDFaceCompletionStatusCode code, NSDictionary *sdkResult) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              [self stopUiLocalizationMonitoring];
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
                                  result(@{
                                    @"error" : [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                                                      chinese:@"采集成功但未获取到图片数据"
                                                                      english:@"Collection succeeded but no image data was returned"
                                                           traditionalChinese:@"採集成功，但未取得圖片資料"
                                                                     japanese:@"収集は成功しましたが、画像データを取得できませんでした"]
                                  });
                                }
                                return;
                              }

                              if (code == BDFaceStatusCancel) {
                                result(nil);
                                return;
                              }

                              if (code == BDFaceStatusTimeout) {
                                result(nil);
                                return;
                              }

                              result(@{@"error" : [self collectErrorMessageForCode:code]});
                            });
                          }];
  });
#endif
}

#if !TARGET_OS_SIMULATOR
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
#endif

- (NSString *)currentLivenessLocaleCode {
  NSString *identifier = [self normalizedLocaleIdentifier:self.preferredLocaleTag];
  if (identifier.length == 0) {
    identifier = [self normalizedLocaleIdentifier:[[NSLocale preferredLanguages] firstObject]];
  }
  if (identifier.length == 0) {
    return @"en";
  }
  if ([identifier hasPrefix:@"ja"]) {
    return @"ja";
  }
  if ([self isTraditionalChineseIdentifier:identifier]) {
    return @"zh-Hant";
  }
  if ([identifier hasPrefix:@"zh"]) {
    return @"zh-Hans";
  }
  return @"en";
}

- (void)updatePreferredLocaleTag:(NSString *)localeTag {
  self.preferredLocaleTag = [self normalizedLocaleIdentifier:localeTag];
}

- (NSString *)normalizedLocaleIdentifier:(NSString *)identifier {
  if (![identifier isKindOfClass:[NSString class]]) {
    return nil;
  }
  NSString *normalized =
      [[identifier stringByReplacingOccurrencesOfString:@"_" withString:@"-"]
          lowercaseString];
  normalized = [normalized stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  return normalized.length > 0 ? normalized : nil;
}

- (BOOL)isTraditionalChineseIdentifier:(NSString *)identifier {
  return [identifier hasPrefix:@"zh-hant"] || [identifier hasPrefix:@"zh-tw"] ||
         [identifier hasPrefix:@"zh-hk"] || [identifier hasPrefix:@"zh-mo"];
}

- (NSString *)localizedStringForLocale:(NSString *)localeCode
                               chinese:(NSString *)chinese
                               english:(NSString *)english
                    traditionalChinese:(NSString *)traditionalChinese
                              japanese:(NSString *)japanese {
  if ([localeCode isEqualToString:@"ja"]) {
    return japanese;
  }
  if ([localeCode isEqualToString:@"zh-Hant"]) {
    return traditionalChinese;
  }
  if ([localeCode isEqualToString:@"en"]) {
    return english;
  }
  return chinese;
}

#if !TARGET_OS_SIMULATOR
- (void)applyLocalizationToParamsConfig:(BDFaceBaseKitParamsCustomConfigItem *)config
                             localeCode:(NSString *)localeCode {
  config.isShowLanguageSwitch = NO;
  config.isPopWindow = YES;
  config.liveness_languageType =
      [localeCode isEqualToString:@"ja"] || [localeCode isEqualToString:@"en"] ? @"EN" : @"ZH_CN";
}

- (void)startUiLocalizationMonitoringIfNeededForLocale:(NSString *)localeCode {
  [self stopUiLocalizationMonitoring];
  if (![localeCode isEqualToString:@"ja"]) {
    return;
  }
  __weak typeof(self) weakSelf = self;
  self.uiLocalizationTimer =
      [NSTimer scheduledTimerWithTimeInterval:0.25
                                      repeats:YES
                                        block:^(__unused NSTimer *timer) {
                                          [weakSelf localizeVisibleSdkTextsIfNeeded];
                                        }];
  [self.uiLocalizationTimer fire];
}

- (void)stopUiLocalizationMonitoring {
  [self.uiLocalizationTimer invalidate];
  self.uiLocalizationTimer = nil;
}

- (void)localizeVisibleSdkTextsIfNeeded {
  NSString *localeCode = [self currentLivenessLocaleCode];
  if (![localeCode isEqualToString:@"ja"] && ![localeCode isEqualToString:@"zh-Hant"]) {
    return;
  }
  if ([localeCode isEqualToString:@"ja"]) {
    [self hideSdkTopRightControlsIfNeeded];
  }
  UIWindow *keyWindow = nil;
  if (@available(iOS 13.0, *)) {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
      if (![scene isKindOfClass:[UIWindowScene class]]) {
        continue;
      }
      UIWindowScene *windowScene = (UIWindowScene *)scene;
      for (UIWindow *window in windowScene.windows) {
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
    keyWindow = UIApplication.sharedApplication.keyWindow;
  }
  if (keyWindow == nil) {
    return;
  }

  NSDictionary<NSString *, NSString *> *replacements =
      [self timeoutDialogReplacementsForLocale:localeCode];
  [self replaceVisibleTextsInView:keyWindow replacements:replacements];
  if ([localeCode isEqualToString:@"ja"]) {
    [self hideSdkTopRightButtonsInView:keyWindow];
  }
}

- (NSDictionary<NSString *, NSString *> *)timeoutDialogReplacementsForLocale:(NSString *)localeCode {
  if ([localeCode isEqualToString:@"zh-Hant"]) {
    return @{
      @"Face recognition timeout" : @"人臉辨識未通過",
      @"Please check the following environmental conditions and try again" :
          @"請檢查以下環境條件後再試一次",
      @"Moderate lighting" : @"光線適中",
      @"Avoid obstruction" : @"避免遮擋",
      @"Face to screen" : @"請正對手機",
      @"Clear camera" : @"攝影機畫面需清晰",
      @"Restart" : @"重新採集",
      @"Back" : @"返回",
    };
  }
  return @{
    @"Face recognition timeout" : @"顔認証がタイムアウトしました",
    @"Please check the following environmental conditions and try again" :
        @"次の環境を確認して、もう一度お試しください",
    @"Moderate lighting" : @"適切な明るさ",
    @"Avoid obstruction" : @"遮らないでください",
    @"Face to screen" : @"画面を正面から見てください",
    @"Clear camera" : @"カメラを鮮明にしてください",
    @"Restart" : @"再試行",
    @"Back" : @"戻る",
  };
}

- (void)hideSdkTopRightControlsIfNeeded {
  UIViewController *controller = [self topViewController];
  if (controller == nil) {
    return;
  }
  @try {
    NSArray<NSString *> *candidateKeys = @[ @"voiceImageView", @"language_logo" ];
    for (NSString *candidateKey in candidateKeys) {
      id button = [controller valueForKey:candidateKey];
      if ([button isKindOfClass:[UIView class]]) {
        UIView *buttonView = (UIView *)button;
        buttonView.hidden = YES;
        buttonView.alpha = 0.0;
        buttonView.userInteractionEnabled = NO;
      }
    }
  } @catch (__unused NSException *exception) {
    // Ignore because some SDK screens may not expose these private ivars.
  }
}

- (void)hideSdkTopRightButtonsInView:(UIView *)view {
  if ([view isKindOfClass:[UIButton class]]) {
    UIButton *button = (UIButton *)view;
    NSString *normalTitle = [button titleForState:UIControlStateNormal];
    NSString *selectedTitle = [button titleForState:UIControlStateSelected];
    NSString *accessibilityLabel = button.accessibilityLabel;
    if ([self isLanguageSwitchTitle:normalTitle] || [self isLanguageSwitchTitle:selectedTitle] ||
        [self isLanguageSwitchTitle:accessibilityLabel]) {
      button.hidden = YES;
      button.alpha = 0.0;
      button.userInteractionEnabled = NO;
    }
  }

  for (UIView *subview in view.subviews) {
    [self hideSdkTopRightButtonsInView:subview];
  }
}

- (BOOL)isLanguageSwitchTitle:(NSString *)title {
  if (![title isKindOfClass:[NSString class]]) {
    return NO;
  }
  NSString *normalized = [[title stringByTrimmingCharactersInSet:
                                     [NSCharacterSet whitespaceAndNewlineCharacterSet]]
      uppercaseString];
  return [normalized isEqualToString:@"EN"] || [normalized isEqualToString:@"ZH_CN"] ||
         [normalized isEqualToString:@"ZH-CN"];
}

- (void)replaceVisibleTextsInView:(UIView *)view
                     replacements:(NSDictionary<NSString *, NSString *> *)replacements {
  if ([view isKindOfClass:[UILabel class]]) {
    UILabel *label = (UILabel *)view;
    NSString *replacement = replacements[label.text];
    if (replacement != nil) {
      label.text = replacement;
    }
  } else if ([view isKindOfClass:[UIButton class]]) {
    UIButton *button = (UIButton *)view;
    NSString *normalTitle = [button titleForState:UIControlStateNormal];
    NSString *replacement = replacements[normalTitle];
    if (replacement != nil) {
      [button setTitle:replacement forState:UIControlStateNormal];
      [button setTitle:replacement forState:UIControlStateHighlighted];
      [button setTitle:replacement forState:UIControlStateSelected];
      [button setTitle:replacement forState:UIControlStateDisabled];
    }
  }

  for (UIView *subview in view.subviews) {
    [self replaceVisibleTextsInView:subview replacements:replacements];
  }
}

- (void)applyLocalizationToTipConfig:(BDFaceBaseKitLivenessTipCustomConfigItem *)tipConfig
                          localeCode:(NSString *)localeCode {
  tipConfig.faceLivenessZoomInText = [self localizedStringForLocale:localeCode
                                                            chinese:@"请将脸部靠近屏幕"
                                                            english:@"Please move your face closer to the screen"
                                                 traditionalChinese:@"請將臉部靠近螢幕"
                                                           japanese:@"顔を画面に近づけてください"];
  tipConfig.faceLivenessZoomOutText = [self localizedStringForLocale:localeCode
                                                             chinese:@"请将脸部远离屏幕"
                                                             english:@"Please move your face away from the screen"
                                                  traditionalChinese:@"請將臉部遠離螢幕"
                                                            japanese:@"顔を画面から離してください"];
  tipConfig.faceLivenessHeadUpText = [self localizedStringForLocale:localeCode
                                                            chinese:@"请略微抬头"
                                                            english:@"Tilt your head slightly upwards"
                                                 traditionalChinese:@"請略微抬頭"
                                                           japanese:@"少し上を向いてください"];
  tipConfig.faceLivenessHeadDownText = [self localizedStringForLocale:localeCode
                                                              chinese:@"请略微低头"
                                                              english:@"Tilt your head slightly downwards"
                                                   traditionalChinese:@"請略微低頭"
                                                             japanese:@"少し下を向いてください"];
  tipConfig.faceLivenessHeadLeftText = [self localizedStringForLocale:localeCode
                                                              chinese:@"请略微向左转头"
                                                              english:@"Please turn your head slightly to the left"
                                                   traditionalChinese:@"請略微向左轉頭"
                                                             japanese:@"少し左を向いてください"];
  tipConfig.faceLivenessHeadRightText = [self localizedStringForLocale:localeCode
                                                               chinese:@"请略微向右转头"
                                                               english:@"Please turn your head slightly to the right"
                                                    traditionalChinese:@"請略微向右轉頭"
                                                              japanese:@"少し右を向いてください"];
  tipConfig.faceLivenessLeftEyeOccludedText = [self localizedStringForLocale:localeCode
                                                                      chinese:@"左眼有遮挡"
                                                                      english:@"Left eye obstructed"
                                                           traditionalChinese:@"左眼有遮擋"
                                                                     japanese:@"左目が隠れています"];
  tipConfig.faceLivenessRightEyeOccludedText = [self localizedStringForLocale:localeCode
                                                                       chinese:@"右眼有遮挡"
                                                                       english:@"Right eye obstructed"
                                                            traditionalChinese:@"右眼有遮擋"
                                                                      japanese:@"右目が隠れています"];
  tipConfig.faceLivenessNoseOccludedText = [self localizedStringForLocale:localeCode
                                                                   chinese:@"鼻子有遮挡"
                                                                   english:@"Nose obstructed"
                                                        traditionalChinese:@"鼻子有遮擋"
                                                                  japanese:@"鼻が隠れています"];
  tipConfig.faceLivenessMouthOccludedText = [self localizedStringForLocale:localeCode
                                                                    chinese:@"嘴部有遮挡"
                                                                    english:@"Mouth obstructed"
                                                         traditionalChinese:@"嘴部有遮擋"
                                                                   japanese:@"口元が隠れています"];
  tipConfig.faceLivenessLeftCheekOccludedText = [self localizedStringForLocale:localeCode
                                                                        chinese:@"左脸颊有遮挡"
                                                                        english:@"Left cheek obstructed"
                                                             traditionalChinese:@"左臉頰有遮擋"
                                                                       japanese:@"左頬が隠れています"];
  tipConfig.faceLivenessRightCheekOccludedText = [self localizedStringForLocale:localeCode
                                                                         chinese:@"右脸颊有遮挡"
                                                                         english:@"Right cheek obstructed"
                                                              traditionalChinese:@"右臉頰有遮擋"
                                                                        japanese:@"右頬が隠れています"];
  tipConfig.faceLivenessChinOccludedText = [self localizedStringForLocale:localeCode
                                                                   chinese:@"下巴有遮挡"
                                                                   english:@"Chin obstructed"
                                                        traditionalChinese:@"下巴有遮擋"
                                                                  japanese:@"あごが隠れています"];
  tipConfig.faceLivenessIlliumPoorText = [self localizedStringForLocale:localeCode
                                                                chinese:@"请使环境光线再亮些"
                                                                english:@"Please brighten the ambient light"
                                                     traditionalChinese:@"環境光線過暗，請調整"
                                                               japanese:@"周囲が暗すぎます。明るくしてください"];
  tipConfig.faceLivenessIlliumMuchText = [self localizedStringForLocale:localeCode
                                                                chinese:@"请使环境光线再暗些"
                                                                english:@"Please dim the ambient light"
                                                     traditionalChinese:@"環境光線過亮，請調整"
                                                               japanese:@"周囲が明るすぎます。調整してください"];
  tipConfig.faceLivenessblurredText = [self localizedStringForLocale:localeCode
                                                             chinese:@"请握稳手机，视线正对屏幕"
                                                             english:@"Please hold your phone steady and look directly at the screen"
                                                  traditionalChinese:@"請握穩手機，視線正對螢幕"
                                                            japanese:@"スマートフォンをしっかり持ち、画面を正面から見てください"];
  tipConfig.faceLivenessLeftEyeNotOpenText = [self localizedStringForLocale:localeCode
                                                                     chinese:@"左眼未睁开"
                                                                     english:@"Your left eye is not open"
                                                          traditionalChinese:@"左眼未睜開"
                                                                    japanese:@"左目が開いていません"];
  tipConfig.faceLivenessRightEyeNotOpenText = [self localizedStringForLocale:localeCode
                                                                      chinese:@"右眼未睁开"
                                                                      english:@"Your right eye is not open"
                                                           traditionalChinese:@"右眼未睜開"
                                                                     japanese:@"右目が開いていません"];
  tipConfig.faceLivenessActionEyeText = [self localizedStringForLocale:localeCode
                                                               chinese:@"眨眨眼"
                                                               english:@"Blink slowly"
                                                    traditionalChinese:@"眨眨眼"
                                                              japanese:@"まばたきしてください"];
  tipConfig.faceLivenessActionMouthText = [self localizedStringForLocale:localeCode
                                                                 chinese:@"张张嘴"
                                                                 english:@"Open your mouth"
                                                      traditionalChinese:@"張張嘴"
                                                                japanese:@"口を開けてください"];
  tipConfig.faceLivenessActionHeadLeftText = [self localizedStringForLocale:localeCode
                                                                    chinese:@"请向左缓慢转头"
                                                                    english:@"Slowly turn your head to the left"
                                                         traditionalChinese:@"請緩慢向左轉頭"
                                                                   japanese:@"ゆっくり左を向いてください"];
  tipConfig.faceLivenessActionHeadRightText = [self localizedStringForLocale:localeCode
                                                                     chinese:@"请向右缓慢转头"
                                                                     english:@"Slowly turn your head to the right"
                                                          traditionalChinese:@"請緩慢向右轉頭"
                                                                    japanese:@"ゆっくり右を向いてください"];
  tipConfig.faceLivenessActionHeadUpText = [self localizedStringForLocale:localeCode
                                                                  chinese:@"请缓慢抬头"
                                                                  english:@"Slowly raise your head"
                                                       traditionalChinese:@"請緩慢抬頭"
                                                                 japanese:@"ゆっくり上を向いてください"];
  tipConfig.faceLivenessActionHeadDownText = [self localizedStringForLocale:localeCode
                                                                    chinese:@"请缓慢低头"
                                                                    english:@"Slowly lower your head"
                                                         traditionalChinese:@"請緩慢低頭"
                                                                   japanese:@"ゆっくり下を向いてください"];
  tipConfig.faceLivenessActionUpDownText = [self localizedStringForLocale:localeCode
                                                                  chinese:@"上下点头"
                                                                  english:@"Nod your head"
                                                       traditionalChinese:@"點點頭"
                                                                 japanese:@"うなずいてください"];
  tipConfig.faceLivenessActionYawText = [self localizedStringForLocale:localeCode
                                                               chinese:@"左右摇头"
                                                               english:@"Shake your head"
                                                    traditionalChinese:@"左右搖頭"
                                                              japanese:@"首を左右に振ってください"];
  tipConfig.faceLivenessScreenWillFlash = [self localizedStringForLocale:localeCode
                                                                 chinese:@"屏幕即将闪烁，请保持正脸"
                                                                 english:@"The screen will flicker, please keep your face straight"
                                                      traditionalChinese:@"螢幕即將閃爍，請保持正臉"
                                                                japanese:@"画面が点滅します。正面を向いたままにしてください"];
  tipConfig.faceLivenessScreenColorChanging = [self localizedStringForLocale:localeCode
                                                                      chinese:@"变光中，请保持正脸"
                                                                      english:@"Light is changing, please keep your face straight"
                                                           traditionalChinese:@"變光中，請保持正臉"
                                                                     japanese:@"画面の光が変化します。正面を向いたままにしてください"];
  tipConfig.faceLivenessCompletionText = [self localizedStringForLocale:localeCode
                                                                chinese:@"非常好"
                                                                english:@"Very good"
                                                     traditionalChinese:@"非常好"
                                                               japanese:@"とても良いです"];
  tipConfig.faceLivenessMovetoFrameText = [self localizedStringForLocale:localeCode
                                                                 chinese:@"把脸移入框内"
                                                                 english:@"Move your face into the frame"
                                                      traditionalChinese:@"請把臉移入框內"
                                                                japanese:@"顔を枠内に入れてください"];
  tipConfig.faceLivenessFacialFaceCorrectionText = [self localizedStringForLocale:localeCode
                                                                           chinese:@"请调整人脸"
                                                                           english:@"Please adjust your facial posture"
                                                                traditionalChinese:@"請調整臉部姿態"
                                                                          japanese:@"顔の向きを調整してください"];
  tipConfig.faceLivenessVerifyFailedText = [self localizedStringForLocale:localeCode
                                                                  chinese:@"验证失败"
                                                                  english:@"Validation failed"
                                                       traditionalChinese:@"驗證失敗"
                                                                 japanese:@"認証に失敗しました"];
  tipConfig.faceLivenessKeepFace = [self localizedStringForLocale:localeCode
                                                          chinese:@"请保持正脸"
                                                          english:@"Please keep facing the screen"
                                               traditionalChinese:@"請保持正臉"
                                                         japanese:@"正面を向いたままにしてください"];
  tipConfig.faceLivenessFaceCovered = [self localizedStringForLocale:localeCode
                                                             chinese:@"脸部有遮挡"
                                                             english:@"Face obstructed"
                                                  traditionalChinese:@"臉部有遮擋"
                                                            japanese:@"顔が隠れています"];
  tipConfig.faceLivenessFaceMoreThan = [self localizedStringForLocale:localeCode
                                                              chinese:@"检测多个人脸"
                                                              english:@"Please ensure only one person is in the frame"
                                                   traditionalChinese:@"檢測到多個人臉"
                                                             japanese:@"1人だけ写るようにしてください"];
  tipConfig.faceLivenessKeepStillText = [self localizedStringForLocale:localeCode
                                                               chinese:@"请保持不动"
                                                               english:@"Please keep facing the screen"
                                                    traditionalChinese:@"請保持不動"
                                                              japanese:@"動かないでください"];
  tipConfig.faceLivenessLittleZoomInText = [self localizedStringForLocale:localeCode
                                                                  chinese:@"请略微靠近"
                                                                  english:@"Please approach slightly"
                                                       traditionalChinese:@"請稍微靠近一些"
                                                                 japanese:@"もう少し近づいてください"];
  tipConfig.faceLivenessLittleZoomOutText = [self localizedStringForLocale:localeCode
                                                                   chinese:@"请略微远离"
                                                                   english:@"Please stay slightly away"
                                                        traditionalChinese:@"請稍微遠離一些"
                                                                  japanese:@"もう少し離れてください"];
  tipConfig.faceLivenessForFaceSlowMoveText = [self localizedStringForLocale:localeCode
                                                                     chinese:@"将采集远景，请缓慢移动远离"
                                                                     english:@"To collect distant views, please move slowly away"
                                                          traditionalChinese:@"即將採集遠景，請緩慢移動並遠離"
                                                                    japanese:@"遠景を収集します。ゆっくり離れてください"];
  tipConfig.faceLivenessNearFaceSlowMoveText = [self localizedStringForLocale:localeCode
                                                                      chinese:@"将采集近景，请缓慢移动靠近"
                                                                      english:@"Close up will be collected, please move slowly to get closer"
                                                           traditionalChinese:@"即將採集近景，請緩慢移動並靠近"
                                                                     japanese:@"近景を収集します。ゆっくり近づいてください"];
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
#endif

- (NSString *)unsupportedSimulatorMessage {
  return [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                chinese:@"iOS 模拟器不支持百度人脸采集，请使用真机调试"
                                english:@"Baidu face collection is unavailable on the iOS simulator. Please use a real device."
                     traditionalChinese:@"iOS 模擬器不支援百度人臉採集，請使用真機調試"
                               japanese:@"iOS シミュレータでは百度の顔認証収集は利用できません。実機で確認してください。"];
}

- (NSDictionary *)payloadFromSdkResult:(NSDictionary *)sdkResult {

  //print the sdkResult for debugging
  NSLog(@"SDK Result: %@", sdkResult);


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

  NSString *imageSrcBase64 = [self resolvedBase64ValueForObject:container
                                                   encryptedKey:@"originalImageEncryptStr"
                                                      plainKey:@"originalImageStr"
                                                      imageKeys:@[@"originalImage", @"originImage"]];
  NSString *imageCropBase64 = [self resolvedBase64ValueForObject:container
                                                    encryptedKey:@"cropImageWithBlackEncryptStr"
                                                       plainKey:@"cropImageWithBlackStr"
                                                       imageKeys:@[@"cropImageWithBlack", @"cropImage"]];
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

- (NSString *)resolvedBase64ValueForObject:(id)object
                              encryptedKey:(NSString *)encryptedKey
                                  plainKey:(NSString *)plainKey
                                  imageKeys:(NSArray<NSString *> *)imageKeys {
  NSString *encrypted = [self stringForKey:encryptedKey inObject:object];
  if (encrypted.length > 0) {
    return encrypted;
  }

  NSString *plain = [self stringForKey:plainKey inObject:object];
  if (plain.length > 0) {
    return plain;
  }

  for (NSString *imageKey in imageKeys) {
    NSString *value = [self base64StringFromValue:[self valueForKey:imageKey inObject:object]];
    if (value.length > 0) {
      return value;
    }
  }

  return nil;
}

- (NSString *)base64StringFromValue:(id)value {
  if (value == nil || value == [NSNull null]) {
    return nil;
  }

  if ([value isKindOfClass:[NSString class]]) {
    NSString *text = [(NSString *)value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return text.length > 0 ? text : nil;
  }

  if ([value isKindOfClass:[NSArray class]]) {
    for (id item in (NSArray *)value) {
      NSString *nested = [self base64StringFromValue:item];
      if (nested.length > 0) {
        return nested;
      }
    }
    return nil;
  }

  if ([value isKindOfClass:[UIImage class]]) {
    return [self base64StringFromImage:(UIImage *)value];
  }

  return nil;
}

- (NSString *)base64StringFromImage:(UIImage *)image {
  if (image == nil) {
    return nil;
  }

  NSData *jpegData = UIImageJPEGRepresentation(image, 0.9);
  if (jpegData == nil || jpegData.length == 0) {
    NSData *pngData = UIImagePNGRepresentation(image);
    if (pngData == nil || pngData.length == 0) {
      return nil;
    }
    return [pngData base64EncodedStringWithOptions:0];
  }

  return [jpegData base64EncodedStringWithOptions:0];
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

#if !TARGET_OS_SIMULATOR
- (NSString *)faceInitErrorMessageForCode:(BDFaceInitRemindCode)code {
  switch (code) {
    case BDFaceInitOK:
      return @"";
    case BDFaceLICENSE_LOCAL_FILE_ERROR:
      return [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                    chinese:@"license文件读取失败"
                                    english:@"Failed to read the license file"
                         traditionalChinese:@"讀取 license 檔案失敗"
                                   japanese:@"license ファイルの読み込みに失敗しました"];
    case BDFaceLICENSE_KEY_CHECK_ERROR:
      return [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                    chinese:@"licenseId或加密Key校验失败"
                                    english:@"licenseId or encrypt key verification failed"
                         traditionalChinese:@"licenseId 或加密 Key 驗證失敗"
                                   japanese:@"licenseId または暗号化キーの検証に失敗しました"];
    case BDFaceLICENSE_FUNCTION_CHECK_ERROR:
      return [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                    chinese:@"当前license未开通采集能力"
                                    english:@"The current license does not include collection capability"
                         traditionalChinese:@"目前 license 未開通採集能力"
                                   japanese:@"現在の license では収集機能が有効になっていません"];
    case BDFaceLICENSE_TIME_EXPIRED:
      return [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                    chinese:@"license已过期"
                                    english:@"The license has expired"
                         traditionalChinese:@"license 已過期"
                                   japanese:@"license の有効期限が切れています"];
    default:
      return [NSString stringWithFormat:[self localizedStringForLocale:[self currentLivenessLocaleCode]
                                                               chinese:@"初始化失败(%ld)"
                                                               english:@"Initialization failed (%ld)"
                                                    traditionalChinese:@"初始化失敗（%ld）"
                                                              japanese:@"初期化に失敗しました（%ld）"],
                                        (long)code];
  }
}

- (NSString *)collectErrorMessageForCode:(BDFaceCompletionStatusCode)code {
  switch (code) {
    case BDFaceStatusSDKNotInit:
      return [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                    chinese:@"SDK未初始化"
                                    english:@"SDK not initialized"
                         traditionalChinese:@"SDK 尚未初始化"
                                   japanese:@"SDK が初期化されていません"];
    case BDFaceStatusSDKNotLoad:
      return [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                    chinese:@"SDK未加载"
                                    english:@"SDK not loaded"
                         traditionalChinese:@"SDK 尚未載入"
                                   japanese:@"SDK が読み込まれていません"];
    case BDFaceStatusCameraError:
      return [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                    chinese:@"没有相机权限"
                                    english:@"Camera permission is missing"
                         traditionalChinese:@"沒有相機權限"
                                   japanese:@"カメラ権限がありません"];
    case BDFaceStatusNetworkError:
      return [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                    chinese:@"网络异常"
                                    english:@"Network error"
                         traditionalChinese:@"網路異常"
                                   japanese:@"ネットワークエラーです"];
    case BDFaceStatusTimeout:
      return [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                    chinese:@"采集超时"
                                    english:@"Collection timed out"
                         traditionalChinese:@"採集逾時"
                                   japanese:@"収集がタイムアウトしました"];
    case BDFaceStatusCropImageError:
      return [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                    chinese:@"抠图失败"
                                    english:@"Failed to crop the image"
                         traditionalChinese:@"擷取圖片失敗"
                                   japanese:@"画像の切り出しに失敗しました"];
    case BDFaceStatusDetectSilentNoPass:
    case BDFaceStatusLivenessSilentNoPass:
      return [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                    chinese:@"活体检测未通过"
                                    english:@"Liveness detection did not pass"
                         traditionalChinese:@"活體檢測未通過"
                                   japanese:@"生体検知に失敗しました"];
    case BDFaceStatusLivenessActionNotMatch:
      return [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                    chinese:@"动作不匹配"
                                    english:@"Action does not match"
                         traditionalChinese:@"動作不匹配"
                                   japanese:@"動作が一致しません"];
    case BDFaceStatusVideoRecordingFail:
      return [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                    chinese:@"视频录制失败"
                                    english:@"Video recording failed"
                         traditionalChinese:@"影片錄製失敗"
                                   japanese:@"動画の録画に失敗しました"];
    case BDFaceStatusResultFail:
      return [self localizedStringForLocale:[self currentLivenessLocaleCode]
                                    chinese:@"图片结果构建失败"
                                    english:@"Failed to build the image result"
                         traditionalChinese:@"建立圖片結果失敗"
                                   japanese:@"画像結果の生成に失敗しました"];
    default:
      return [NSString stringWithFormat:[self localizedStringForLocale:[self currentLivenessLocaleCode]
                                                               chinese:@"采集失败(%ld)"
                                                               english:@"Collection failed (%ld)"
                                                    traditionalChinese:@"採集失敗（%ld）"
                                                              japanese:@"収集に失敗しました（%ld）"],
                                        (long)code];
  }
}
#endif

@end
