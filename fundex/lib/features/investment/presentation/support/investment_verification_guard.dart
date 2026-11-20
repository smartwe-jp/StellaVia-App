import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/domain/repositories/verification_entry_repository.dart';
import '../../../member_profile/presentation/providers/verification_entry_provider.dart';

enum InvestmentAction { fundApplication, secondaryPurchase }

bool canProceedWithInvestment(
  VerificationEntry entry,
  InvestmentAction action,
) {
  if (entry.kind == VerificationEntryKind.corporate) {
    return entry.status == 'CONFIRMED';
  }
  return action == InvestmentAction.secondaryPurchase ||
      entry.personalStatus == 4 ||
      entry.personalStatus == 5;
}

/// Returns the verified entry for this action only. Always reads fresh data.
Future<VerificationEntry?> checkInvestmentAccess(
  BuildContext context,
  WidgetRef ref,
  InvestmentAction action,
) async {
  final VerificationEntry entry;
  try {
    entry = await ref.read(verificationEntryRepositoryProvider).load();
  } catch (_) {
    if (context.mounted && ModalRoute.of(context)?.isCurrent == true) {
      AppNotice.show(context, message: context.l10n.uiErrorRequestFailed);
    }
    return null;
  }
  if (!context.mounted || ModalRoute.of(context)?.isCurrent != true) {
    return null;
  }
  if (canProceedWithInvestment(entry, action)) return entry;
  final l = context.l10n;
  final corporate = entry.kind == VerificationEntryKind.corporate;
  final viewProfile = await AppDialogs.showAdaptiveAlert<bool>(
    context: context,
    title: l.fundApplyVerificationRequiredTitle,
    message: corporate
        ? l.corporateInvestmentVerificationRequired
        : l.fundApplyVerificationRequiredMessage,
    actions: [
      if (corporate) ...[
        AppDialogAction(label: l.commonCancel, value: false),
        AppDialogAction(
          label: l.menuItemEditProfile,
          isDefaultAction: true,
          value: true,
        ),
      ] else
        AppDialogAction(label: l.commonOk, isDefaultAction: true, value: false),
    ],
  );
  if (context.mounted && viewProfile == true) {
    ref.invalidate(verificationEntryProvider);
    await context.push('/member-profile/edit', extra: true);
  }
  return null;
}
