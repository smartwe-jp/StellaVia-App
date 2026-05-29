import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/hotel_booking_providers.dart';

Future<void> runHotelOrderCancelFlow({
  required BuildContext context,
  required WidgetRef ref,
  required String languageCode,
  required String orderId,
  Future<void> Function()? onCancelled,
}) async {
  final trimmedOrderId = orderId.trim();
  if (trimmedOrderId.isEmpty) {
    return;
  }
  final l10n = context.l10n;
  try {
    final rule = await AppLoadingDialog.run(
      context,
      () => ref.read(fetchHotelOrderCancelRuleUseCaseProvider)(
        languageCode: languageCode,
        orderId: trimmedOrderId,
      ),
    );
    if (!context.mounted) {
      return;
    }
    final shouldCancel = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: l10n.hotelOrdersCancelAction,
      message: rule.message,
      barrierDismissible: false,
      actions: rule.canCancel
          ? <AppDialogAction<bool>>[
              AppDialogAction<bool>(label: l10n.commonCancel, value: false),
              AppDialogAction<bool>(
                label: l10n.commonConfirm,
                value: true,
                isDefaultAction: true,
              ),
            ]
          : <AppDialogAction<bool>>[
              AppDialogAction<bool>(
                label: l10n.commonConfirm,
                value: false,
                isDefaultAction: true,
              ),
            ],
    );
    if (!context.mounted || !rule.canCancel || shouldCancel != true) {
      return;
    }
    final message = await AppLoadingDialog.run(
      context,
      () => ref.read(cancelHotelOrderUseCaseProvider)(
        languageCode: languageCode,
        orderId: trimmedOrderId,
      ),
    );
    if (!context.mounted) {
      return;
    }
    AppNotice.show(
      context,
      message: message.trim().isEmpty ? l10n.hotelOrdersCancelFailed : message,
    );
    await onCancelled?.call();
  } catch (error) {
    if (!context.mounted) {
      return;
    }
    AppNotice.show(context, message: _cancelErrorMessage(error, l10n));
  }
}

String _cancelErrorMessage(Object error, AppLocalizations l10n) {
  if (error is StateError) {
    final message = error.message.trim();
    if (message.isNotEmpty) {
      return message;
    }
  }
  return l10n.hotelOrdersCancelFailed;
}
