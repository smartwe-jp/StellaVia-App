import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'model.dart';

class FlutterBdfaceCollect extends _ServiceApi {
  FlutterBdfaceCollect._();

  static FlutterBdfaceCollect instance = FlutterBdfaceCollect._();
}

class _ServiceApi {
  static const String _ChannelName = 'com.fluttercandies.bdface_collect';
  final MethodChannel _methodChannel = MethodChannel(_ChannelName);

  Future<String?> get platformVersion async {
    final String? version = await _methodChannel
        .invokeMethod<String>(MethodConstants.GetPlatformVersion);
    return version;
  }

  /// 初始化
  Future<String?> init(String licenseId) async {
    // var s = await Permission.camera.status;
    // if (![PermissionStatus.granted, PermissionStatus.limited].contains(s)) {
    //   s = await Permission.camera.request();
    //   if (![PermissionStatus.granted, PermissionStatus.limited].contains(s)) {
    //     return "errCode: OTHER_ERROR, errMsg: 无相机使用权限";
    //   }
    // }
    // if (Platform.isAndroid) {
    //   s = await Permission.storage.status;
    //   if (![PermissionStatus.granted, PermissionStatus.limited].contains(s)) {
    //     s = await Permission.storage.request();
    //     if (![PermissionStatus.granted, PermissionStatus.limited].contains(s)) {
    //       return "errCode: OTHER_ERROR, errMsg: 无本地存储权限";
    //     }
    //   }
    // }
    final String? err = await _methodChannel.invokeMethod<String>(
      MethodConstants.Init,
      <String, dynamic>{
        'licenseId': licenseId,
        'localeTag': _currentLocaleTag(),
      },
    );
    return err;
  }

  /// 采集
  Future<CollectResult> collect(FaceConfig config) async {
    final bool shouldDisableVoicePrompt = _shouldDisableVoicePrompt();
    final Map<String, dynamic> arguments = <String, dynamic>{
      ...config.toMap(),
      'sound': shouldDisableVoicePrompt ? false : config.sound,
      'localeTag': _currentLocaleTag(),
    };
    final Map<String, dynamic>? result = await _methodChannel.invokeMapMethod(
      MethodConstants.Collect,
      arguments,
    );
    if (result == null) {
      return CollectResult(error: _localizedCancelMessage());
    }
    return CollectResult.fromMap(result);
  }

  /// 释放
  Future<void> unInit() async {
    await _methodChannel.invokeMethod(MethodConstants.UnInit);
  }

  String _localizedCancelMessage() {
    final locale = PlatformDispatcher.instance.locale;
    final languageCode = locale.languageCode.toLowerCase();
    final scriptCode = locale.scriptCode?.toLowerCase();
    final countryCode = locale.countryCode?.toLowerCase();

    if (languageCode == 'ja') {
      return '認証をキャンセルしました';
    }
    if (languageCode == 'en') {
      return 'Recognition cancelled';
    }
    if (languageCode == 'zh' &&
        (scriptCode == 'hant' ||
            countryCode == 'tw' ||
            countryCode == 'hk' ||
            countryCode == 'mo')) {
      return '已取消辨識';
    }
    return '已取消识别';
  }

  String _currentLocaleTag() {
    return PlatformDispatcher.instance.locale.toLanguageTag();
  }

  bool _shouldDisableVoicePrompt() {
    final locale = PlatformDispatcher.instance.locale;
    return locale.languageCode.toLowerCase() == 'ja';
  }
}
