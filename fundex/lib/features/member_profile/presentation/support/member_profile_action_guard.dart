import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/member_profile_providers.dart';
import 'member_profile_edit_step.dart';

class MemberProfileActionGuard {
  const MemberProfileActionGuard(this._ref);

  final Ref _ref;

  Future<bool> ensureCompleted(
    BuildContext context, {
    String? actionLabel,
  }) async {
    bool completed;
    try {
      completed = await _ref.read(isMemberProfileCompletedProvider.future);
    } catch (_) {
      completed = false;
    }

    if (completed) {
      return true;
    }

    if (!context.mounted) {
      return false;
    }

    final l10n = context.l10n;
    final result = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: l10n.profileGuardTitle,
      message: actionLabel == null || actionLabel.trim().isEmpty
          ? l10n.profileGuardMessage
          : l10n.profileGuardMessageWithAction(actionLabel),
      actions: <AppDialogAction<bool>>[
        AppDialogAction<bool>(label: l10n.profileGuardCancel, value: false),
        AppDialogAction<bool>(
          label: l10n.profileGuardGoFill,
          value: true,
          isDefaultAction: true,
        ),
      ],
    );

    if (!context.mounted) {
      return false;
    }

    if (result == true) {
      context.push(
        '/member-profile/onboarding',
      );
    }
    return false;
  }
}

final memberProfileActionGuardProvider = Provider<MemberProfileActionGuard>((
  ref,
) {
  return MemberProfileActionGuard(ref);
});
