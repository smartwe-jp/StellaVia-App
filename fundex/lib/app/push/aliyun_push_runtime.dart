import 'dart:async';

import 'package:aliyun_push_flutter/aliyun_push_flutter.dart';
import 'package:core_tool_kit/core_tool_kit.dart';
import 'package:flutter/foundation.dart';

import 'app_push_runtime.dart';
import 'app_push_settings.dart';

class AliyunPushRuntime implements AppPushRuntime {
  AliyunPushRuntime({
    required AliyunPushCredentials credentials,
    AliyunPushFlutter? push,
    String androidChannelId = 'fundex_push',
    String androidChannelName = 'FUNDEX Push',
    String androidChannelDescription = 'FUNDEX notification channel',
  }) : _credentials = credentials,
       _push = push ?? AliyunPushFlutter(),
       _androidChannelId = androidChannelId,
       _androidChannelName = androidChannelName,
       _androidChannelDescription = androidChannelDescription;

  static const String _successCode = '10000';

  final AliyunPushCredentials _credentials;
  final AliyunPushFlutter _push;
  final String _androidChannelId;
  final String _androidChannelName;
  final String _androidChannelDescription;

  bool _initialized = false;
  String? _latestDeviceId;
  final StreamController<String> _tokenController =
      StreamController<String>.broadcast();

  @override
  String get providerName => 'aliyun';

  @override
  String? get latestToken => _latestDeviceId;

  @override
  Stream<String> get tokenStream => _tokenController.stream;

  @override
  Future<void> initialize({required AppLogger logger}) async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    if (kIsWeb) {
      logger.warning('Aliyun push runtime is disabled on web platform.');
      return;
    }

    final appKey = _credentials.currentPlatformAppKey?.trim() ?? '';
    final appSecret = _credentials.currentPlatformAppSecret?.trim() ?? '';
    if (appKey.isEmpty || appSecret.isEmpty) {
      logger.warning(
        'Aliyun push credentials are missing for current platform; skip initialization.',
        context: <String, Object?>{'platform': defaultTargetPlatform.name},
      );
      return;
    }

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _setupAndroidChannel(logger: logger);
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _setupIosForegroundBehavior(logger: logger);
      }

      final result = await _push.initPush(appKey: appKey, appSecret: appSecret);
      final code = '${result['code'] ?? ''}'.trim();
      if (!_isSuccess(code)) {
        logger.error(
          'Aliyun push initialization failed.',
          context: <String, Object?>{
            'code': code,
            'errorMsg': '${result['errorMsg'] ?? ''}',
          },
        );
        return;
      }

      logger.info(
        'Aliyun push initialized.',
        context: <String, Object?>{
          'platform': defaultTargetPlatform.name,
          'code': code,
        },
      );

      await _resolveDeviceId(logger: logger);
      _setupReceivers(logger: logger);
    } catch (error, stackTrace) {
      logger.error(
        'Aliyun push initialize failed unexpectedly.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _setupAndroidChannel({required AppLogger logger}) async {
    final result = await _push.createAndroidChannel(
      _androidChannelId,
      _androidChannelName,
      4,
      _androidChannelDescription,
    );
    final code = '${result['code'] ?? ''}'.trim();
    if (_isSuccess(code)) {
      logger.info(
        'Aliyun Android push channel created.',
        context: <String, Object?>{'channelId': _androidChannelId},
      );
      return;
    }
    logger.warning(
      'Aliyun Android push channel setup failed.',
      context: <String, Object?>{
        'channelId': _androidChannelId,
        'code': code,
        'errorMsg': '${result['errorMsg'] ?? ''}',
      },
    );
  }

  Future<void> _setupIosForegroundBehavior({required AppLogger logger}) async {
    await _push.showIOSNoticeWhenForeground(true);
    final channelOpened = await _push.isIOSChannelOpened();
    logger.info(
      'Aliyun iOS notification channel state.',
      context: <String, Object?>{'opened': channelOpened},
    );
  }

  Future<void> _resolveDeviceId({required AppLogger logger}) async {
    final deviceId = (await _push.getDeviceId()).trim();
    if (deviceId.isEmpty) {
      logger.warning('Aliyun push deviceId is empty after initialization.');
      return;
    }
    _latestDeviceId = deviceId;
    _tokenController.add(deviceId);
    logger.info(
      'Aliyun push deviceId resolved.',
      context: <String, Object?>{'deviceId': deviceId},
    );
  }

  void _setupReceivers({required AppLogger logger}) {
    _push.addMessageReceiver(
      onNotificationOpened: (Map<dynamic, dynamic> message) async {
        logger.info(
          'Aliyun notification opened.',
          context: <String, Object?>{'message': message.toString()},
        );
        return null;
      },
      onNotification: (Map<dynamic, dynamic> message) async {
        logger.info(
          'Aliyun notification received.',
          context: <String, Object?>{'message': message.toString()},
        );
        return null;
      },
      onMessage: (Map<dynamic, dynamic> message) async {
        logger.info(
          'Aliyun data message received.',
          context: <String, Object?>{'message': message.toString()},
        );
        return null;
      },
      onNotificationRemoved: (Map<dynamic, dynamic> message) async {
        logger.info(
          'Aliyun notification removed.',
          context: <String, Object?>{'message': message.toString()},
        );
        return null;
      },
    );
  }

  bool _isSuccess(String code) {
    return code == _successCode || code == '0';
  }
}
