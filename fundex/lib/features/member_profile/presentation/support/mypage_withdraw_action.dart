import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../providers/mypage_providers.dart';

Future<bool> confirmAndSubmitMyPageWithdraw(
  BuildContext context,
  WidgetRef ref, {
  required String processId,
  required String confirmBody,
  Future<void> Function()? onSuccessRefresh,
}) async {
  final l10n = context.l10n;
  final shouldSubmit = await AppDialogs.showAdaptiveAlert<bool>(
    context: context,
    title: l10n.myPageWithdrawConfirmTitle,
    message: confirmBody,
    actions: <AppDialogAction<bool>>[
      AppDialogAction<bool>(
        label: l10n.walletBankSettingsCancelAction,
        value: false,
      ),
      AppDialogAction<bool>(
        label: l10n.myPageWithdrawConfirmAction,
        value: true,
        isDestructive: true,
      ),
    ],
  );

  if (shouldSubmit != true || !context.mounted) {
    return false;
  }

  try {
    await ref
        .read(submitMyPageUserWithdrawUseCaseProvider)
        .call(processId: processId);
    if (!context.mounted) {
      return false;
    }
    AppNotice.show(context, message: l10n.myPageWithdrawSuccess);
    if (onSuccessRefresh != null) {
      await onSuccessRefresh();
    }
    return true;
  } catch (error) {
    if (!context.mounted) {
      return false;
    }
    AppNotice.show(
      context,
      message: resolveAppRequestErrorMessage(error, l10n.myPageWithdrawFailure),
    );
    return false;
  }
}
