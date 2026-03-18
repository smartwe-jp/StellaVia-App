import 'aliyun_push_runtime.dart';
import 'app_push_provider.dart';
import 'app_push_runtime.dart';
import 'app_push_settings.dart';
import 'firebase_push_runtime.dart';

AppPushRuntime createAppPushRuntime({required AppPushSettings settings}) {
  switch (settings.provider) {
    case AppPushProvider.aliyun:
      return AliyunPushRuntime(credentials: settings.aliyunCredentials);
    case AppPushProvider.fcm:
      return const FirebasePushRuntime();
  }
}
