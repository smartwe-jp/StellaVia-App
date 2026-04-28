import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

Future<bool> showWalletStandbyPurchaseConfirmDialog(
  BuildContext context, {
  required String projectName,
  required String amountText,
}) async {
  final l10n = context.l10n;
  final confirmed = await AppDialogs.showAdaptiveAlert<bool>(
    context: context,
    title: l10n.lotteryApplyStandbyPurchaseConfirmTitle,
    message: l10n.lotteryApplyStandbyPurchaseConfirmBody(
      projectName,
      amountText,
    ),
    barrierDismissible: false,
    actions: <AppDialogAction<bool>>[
      AppDialogAction<bool>(label: l10n.commonCancel, value: false),
      AppDialogAction<bool>(
        label: l10n.lotteryApplyStandbyPurchaseConfirmAction,
        value: true,
        isDefaultAction: true,
      ),
    ],
  );
  return confirmed == true;
}
