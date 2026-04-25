import 'package:core_identity_auth/core_identity_auth.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/identity_auth_sdk_providers.dart';
import '../../../settings/presentation/providers/settings_two_factor_providers.dart';
import 'identity_auth_message_resolver.dart';

Future<bool> ensureSensitiveActionAuthorized(
  BuildContext context,
  WidgetRef ref, {
  String? identifyGroupId,
  bool refreshVerificationStatus = true,
}) async {
  if (refreshVerificationStatus) {
    await refreshRemoteVerificationStatus(ref);
  }

  final isIdentityAuthEnabled = ref.read(identityAuthFeatureEnabledProvider);
  if (!isIdentityAuthEnabled) {
    return true;
  }

  final coordinator = ref.read(identityAuthCoordinatorProvider);
  final firstResult = await coordinator.authenticateSensitiveAction(
    identifyGroupId: identifyGroupId,
  );
  if (firstResult.action == IdentityAuthAction.allowTargetAction) {
    return true;
  }

  if (!context.mounted) {
    return false;
  }

  if (firstResult.action == IdentityAuthAction.startRealPersonEnrollment) {
    final enrolled = await context.push<bool>('/auth/real-person');
    if (enrolled != true || !context.mounted) {
      return false;
    }

    final secondResult = await coordinator.authenticateSensitiveAction(
      identifyGroupId: identifyGroupId,
    );
    if (secondResult.action == IdentityAuthAction.allowTargetAction) {
      return true;
    }

    if (context.mounted) {
      AppNotice.show(
        context,
        message: resolveIdentityAuthMessage(
          context.l10n,
          reasonCode: secondResult.reasonCode,
          errorMessage: secondResult.errorMessage,
          fallbackMessage: context.l10n.identityAuthSensitiveBlocked,
        ),
      );
    }
    return false;
  }

  AppNotice.show(
    context,
    message: resolveIdentityAuthMessage(
      context.l10n,
      reasonCode: firstResult.reasonCode,
      errorMessage: firstResult.errorMessage,
      fallbackMessage: context.l10n.identityAuthSensitiveBlocked,
    ),
  );
  return false;
}

Future<bool> ensureRealPersonVerifiedAndAuthorizeSensitiveAction(
  BuildContext context,
  WidgetRef ref, {
  required String faceVerificationTitle,
  required String faceVerificationMessage,
  String? identifyGroupId,
}) async {
  await refreshRemoteVerificationStatus(ref);

  final faceVerified = await ref
      .read(settingsRealPersonVerifiedProvider.future)
      .catchError((Object _) => false);
  if (!context.mounted) {
    return false;
  }

  if (!faceVerified) {
    final shouldStartVerification =
        await AppDialogs.showAdaptiveAlert<bool>(
          context: context,
          title: faceVerificationTitle,
          message: faceVerificationMessage,
          actions: <AppDialogAction<bool>>[
            AppDialogAction<bool>(
              label: context.l10n.commonCancel,
              value: false,
            ),
            AppDialogAction<bool>(
              label: context.l10n.identityAuthStartAction,
              value: true,
              isDefaultAction: true,
            ),
          ],
        ) ??
        false;
    if (!context.mounted) {
      return false;
    }
    if (shouldStartVerification) {
      context.push('/profile/settings/two-factor/face');
    }
    return false;
  }

  return ensureSensitiveActionAuthorized(
    context,
    ref,
    identifyGroupId: identifyGroupId,
    refreshVerificationStatus: false,
  );
}

Future<void> refreshRemoteVerificationStatus(WidgetRef ref) async {
  ref.invalidate(settingsRemoteVerificationStatusProvider);
  ref.invalidate(settingsPhoneVerifiedProvider);
  ref.invalidate(settingsEmailVerifiedProvider);
  ref.invalidate(settingsVerifiedEmailProvider);
  ref.invalidate(settingsRealPersonVerifiedProvider);

  await ref
      .refresh(settingsRemoteVerificationStatusProvider.future)
      .catchError((Object _) => null);

  ref.invalidate(settingsPhoneVerifiedProvider);
  ref.invalidate(settingsEmailVerifiedProvider);
  ref.invalidate(settingsVerifiedEmailProvider);
  ref.invalidate(settingsRealPersonVerifiedProvider);
}
