import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../localization/app_localizations_ext.dart';

enum AppPermissionKind { camera, photos, location }

Future<void> showAppPermissionSettingsDialog(
  BuildContext context, {
  required AppPermissionKind permission,
}) async {
  final l10n = context.l10n;
  final confirmed = await AppDialogs.showAdaptiveAlert<bool>(
    context: context,
    title: l10n.permissionSettingsTitle,
    message: switch (permission) {
      AppPermissionKind.camera => l10n.permissionSettingsCameraMessage,
      AppPermissionKind.photos => l10n.permissionSettingsPhotosMessage,
      AppPermissionKind.location => l10n.permissionSettingsLocationMessage,
    },
    actions: <AppDialogAction<bool>>[
      AppDialogAction<bool>(label: l10n.commonCancel, value: false),
      AppDialogAction<bool>(
        label: l10n.commonOpenSettings,
        value: true,
        isDefaultAction: true,
      ),
    ],
  );

  if (confirmed == true) {
    await openAppSettings();
  }
}
