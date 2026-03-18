enum AppPushProvider { aliyun, fcm }

AppPushProvider parseAppPushProvider(String raw) {
  switch (raw.trim().toLowerCase()) {
    case 'fcm':
      return AppPushProvider.fcm;
    case 'aliyun':
    default:
      return AppPushProvider.aliyun;
  }
}
