import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

typedef AppVersionResolver = Future<String> Function();

class AppClientMetadataInterceptor extends Interceptor {
  AppClientMetadataInterceptor({AppVersionResolver? appVersionResolver})
    : _appVersionResolver = appVersionResolver ?? _resolvePackageVersion;

  static const String _clientTypeHeader = 'x-client-type';
  static const String _clientType = 'Stellavia-App';
  static const String _appVersionHeader = 'app-version';

  final AppVersionResolver _appVersionResolver;

  Future<String>? _versionFuture;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers[_clientTypeHeader] = _clientType;

    try {
      final version = await _resolveAppVersion();
      if (version.isNotEmpty) {
        options.headers[_appVersionHeader] = version;
      }
    } catch (_) {
      // Version metadata should not block the request if platform metadata is
      // unavailable in a test or early startup environment.
    }

    handler.next(options);
  }

  Future<String> _resolveAppVersion() {
    return _versionFuture ??= _appVersionResolver().then((value) {
      final version = value.trim();
      return version.isEmpty ? '1.1.0' : version;
    });
  }

  static Future<String> _resolvePackageVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version.trim();
  }
}
