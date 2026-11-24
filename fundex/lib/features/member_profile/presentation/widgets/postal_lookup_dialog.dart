import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

Future<bool?> showPostalLookupEmptyDialog(BuildContext context) {
  final l = context.l10n;
  return AppDialogs.showAdaptiveAlert<bool>(
    context: context,
    title: l.memberProfileAddressSearchEmpty,
    message: l.corpPostalReentryMessage,
    barrierDismissible: false,
    actions: [
      AppDialogAction(
        label: l.corpPostalReenter,
        value: true,
        isDefaultAction: true,
      ),
    ],
  );
}
