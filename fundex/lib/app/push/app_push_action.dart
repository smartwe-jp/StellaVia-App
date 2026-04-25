import 'dart:convert';

import 'app_push_runtime.dart';

enum AppPushAction { appBlock, appUpdate, campaignDialog, homeCelebration }

class AppPushCommand {
  const AppPushCommand({
    required this.token,
    required this.action,
    required this.source,
    required this.title,
    required this.body,
    this.primaryLabel,
    this.secondaryLabel,
    this.iosUrl,
    this.androidUrl,
    this.webUrl,
    this.imageUrl,
    this.lottieUrl,
    this.targetVersion,
    this.minBuild,
    this.maxBuild,
    this.dismissible = true,
    this.showOnce = true,
    this.requiresAuth = false,
    this.expiresAt,
  });

  final String token;
  final AppPushAction action;
  final String source;
  final String title;
  final String body;
  final String? primaryLabel;
  final String? secondaryLabel;
  final String? iosUrl;
  final String? androidUrl;
  final String? webUrl;
  final String? imageUrl;
  final String? lottieUrl;
  final String? targetVersion;
  final int? minBuild;
  final int? maxBuild;
  final bool dismissible;
  final bool showOnce;
  final bool requiresAuth;
  final DateTime? expiresAt;

  bool get isExpired {
    final expiresAt = this.expiresAt;
    if (expiresAt == null) {
      return false;
    }
    return DateTime.now().toUtc().isAfter(expiresAt.toUtc());
  }
}

AppPushCommand? parseAppPushCommand(AppPushNotificationEvent event) {
  final reader = _PushPayloadReader(event.payload);
  final action = _parseAction(
    reader.string('PUSH_ACTION') ?? reader.string('ACTION'),
    legacyTargetPage: reader.string('TARGET_PAGE'),
  );
  if (action == null) {
    return null;
  }

  final title =
      reader.string('TITLE') ??
      reader.string('NOTIFICATION_TITLE') ??
      reader.string('title') ??
      '';
  final body =
      reader.string('BODY') ??
      reader.string('NOTIFICATION_BODY') ??
      reader.string('body') ??
      '';
  return AppPushCommand(
    token: _resolveToken(reader, event),
    action: action,
    source: event.kind,
    title: title,
    body: body,
    primaryLabel: reader.string('PRIMARY_LABEL'),
    secondaryLabel: reader.string('SECONDARY_LABEL'),
    iosUrl: reader.string('IOS_URL'),
    androidUrl: reader.string('ANDROID_URL'),
    webUrl: reader.string('WEB_URL'),
    imageUrl: reader.string('IMAGE_URL'),
    lottieUrl: reader.string('LOTTIE_URL'),
    targetVersion: reader.string('TARGET_VERSION'),
    minBuild: reader.integer('MIN_BUILD'),
    maxBuild: reader.integer('MAX_BUILD'),
    dismissible: reader.boolean('DISMISSIBLE') ?? true,
    showOnce: reader.boolean('SHOW_ONCE') ?? true,
    requiresAuth: reader.boolean('REQUIRES_AUTH') ?? false,
    expiresAt: reader.dateTime('EXPIRES_AT'),
  );
}

String _resolveToken(
  _PushPayloadReader reader,
  AppPushNotificationEvent event,
) {
  final explicitToken = reader.string('PUSH_ID') ?? reader.string('MESSAGE_ID');
  if (explicitToken != null) {
    return explicitToken;
  }
  final legacyMessageId =
      reader.string('_ALIYUN_NOTIFICATION_MSG_ID_') ?? reader.string('msg_id');
  if (legacyMessageId != null) {
    return 'push-$legacyMessageId';
  }
  return 'push-${event.kind}-${event.payload.toString()}';
}

AppPushAction? _parseAction(String? raw, {String? legacyTargetPage}) {
  final normalized = _normalizeKey(raw ?? '');
  return switch (normalized) {
    'appblock' || 'forceapp' || 'forceblock' => AppPushAction.appBlock,
    'appupdate' || 'update' || 'versionupdate' => AppPushAction.appUpdate,
    'campaigndialog' ||
    'campaign' ||
    'activitydialog' => AppPushAction.campaignDialog,
    'homecelebration' || 'celebration' => AppPushAction.homeCelebration,
    _ =>
      _normalizeKey(legacyTargetPage ?? '') == 'homecelebration'
          ? AppPushAction.homeCelebration
          : null,
  };
}

class _PushPayloadReader {
  _PushPayloadReader(Map<String, Object?> payload)
    : _maps = _collectMaps(payload);

  final List<Map<String, Object?>> _maps;

  String? string(String key) {
    final value = _value(key);
    if (value == null) {
      return null;
    }
    final text = '$value'.trim();
    return text.isEmpty ? null : text;
  }

  bool? boolean(String key) {
    final value = string(key)?.toLowerCase();
    if (value == null) {
      return null;
    }
    if (value == 'true' || value == '1' || value == 'yes' || value == 'y') {
      return true;
    }
    if (value == 'false' || value == '0' || value == 'no' || value == 'n') {
      return false;
    }
    return null;
  }

  int? integer(String key) {
    final value = string(key);
    return value == null ? null : int.tryParse(value);
  }

  DateTime? dateTime(String key) {
    final value = string(key);
    return value == null ? null : DateTime.tryParse(value);
  }

  Object? _value(String key) {
    final normalizedKey = _normalizeKey(key);
    for (final map in _maps) {
      for (final entry in map.entries) {
        if (_normalizeKey(entry.key) == normalizedKey) {
          return entry.value;
        }
      }
    }
    return null;
  }

  static List<Map<String, Object?>> _collectMaps(Map<String, Object?> root) {
    final maps = <Map<String, Object?>>[root];
    for (final key in const <String>['extraMap', 'exts', 'data', 'payload']) {
      final child = _readMap(root[key]);
      if (child.isNotEmpty) {
        maps.add(child);
      }
    }
    return maps;
  }

  static Map<String, Object?> _readMap(Object? value) {
    if (value is Map<String, Object?>) {
      return value;
    }
    if (value is Map) {
      return value.map(
        (dynamic key, dynamic mapValue) =>
            MapEntry('$key', mapValue as Object?),
      );
    }
    if (value is String && value.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map) {
          return decoded.map(
            (dynamic key, dynamic mapValue) =>
                MapEntry('$key', mapValue as Object?),
          );
        }
      } catch (_) {
        return const <String, Object?>{};
      }
    }
    return const <String, Object?>{};
  }
}

String _normalizeKey(String raw) {
  return raw.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
}
