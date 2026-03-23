import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../providers/mypage_providers.dart';

const String _defaultApplyWithdrawRemark = 'キャンセル';

Future<bool> _confirmAndSubmitAction(
  BuildContext context, {
  required String confirmBody,
  required Future<void> Function() submit,
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
    await submit();
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

Future<bool> confirmAndSubmitMyPageWithdraw(
  BuildContext context,
  WidgetRef ref, {
  required String processId,
  required String confirmBody,
  Future<void> Function()? onSuccessRefresh,
}) {
  return _confirmAndSubmitAction(
    context,
    confirmBody: confirmBody,
    onSuccessRefresh: onSuccessRefresh,
    submit: () => ref
        .read(submitMyPageUserWithdrawUseCaseProvider)
        .call(processId: processId, remark: _defaultApplyWithdrawRemark),
  );
}

Future<bool> confirmAndSubmitMyPageSecondaryMarketInvalidate(
  BuildContext context,
  WidgetRef ref, {
  required String id,
  required String fromProcessId,
  required int sellNum,
  required int price,
  required int thisTimeSoldNum,
  required String confirmBody,
  Future<void> Function()? onSuccessRefresh,
}) {
  return _confirmAndSubmitAction(
    context,
    confirmBody: confirmBody,
    onSuccessRefresh: onSuccessRefresh,
    submit: () => ref
        .read(submitMyPageSecondaryMarketModifyUseCaseProvider)
        .call(
          id: id,
          fromProcessId: fromProcessId,
          sellNum: sellNum,
          price: price,
          status: 'INVALID',
          thisTimeSoldNum: thisTimeSoldNum,
        ),
  );
}
