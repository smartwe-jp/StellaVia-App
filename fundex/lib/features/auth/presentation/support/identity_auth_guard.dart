import 'package:core_identity_auth/core_identity_auth.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/identity_auth_sdk_providers.dart';
import 'identity_auth_message_resolver.dart';

Future<bool> ensureSensitiveActionAuthorized(
  BuildContext context,
  WidgetRef ref, {
  String? identifyGroupId,
}) async {
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
