import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../pages/corporate_detail_page.dart';
import '../providers/verification_entry_provider.dart';
import '../support/corporate_flow_navigation.dart';

class CorporateVerifiedContent extends ConsumerWidget {
  const CorporateVerifiedContent({super.key, required this.companyName});
  final String? companyName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final name = companyName?.trim() ?? '';
    const capsuleStyle = ButtonStyle(
      shape: WidgetStatePropertyAll(StadiumBorder()),
    );
    return RefreshIndicator(
      onRefresh: () => ref
          .refresh(verificationEntryProvider.future)
          .then<void>((_) {}, onError: (Object _, StackTrace _) {}),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Text(
            l.corpVerifiedTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 16),
          Text(l.corpVerifiedThanks, style: theme.textTheme.bodySmall),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.corporateStatus('CONFIRMED'),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                if (name.isNotEmpty) Text(name),
                Text(l.corpVerifiedInvestorNote),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(l.corpVerifiedNext, style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),
          Text(l.corpVerifiedFundNote, style: theme.textTheme.bodyLarge),
          for (final row in [
            (l.corpVerifiedType, l.corporateInvestor),
            (l.corpVerifiedStatus, l.corpVerifiedDone),
          ]) ...[
            const SizedBox(height: 24),
            Text(row.$1, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(row.$2, style: theme.textTheme.titleSmall),
            const SizedBox(height: 12),
            const Divider(height: 1),
          ],
          const SizedBox(height: 16),
          AppButton(
            label: l.corpVerifiedView,
            variant: AppButtonVariant.secondary,
            minHeight: 50,
            style: capsuleStyle,
            onPressed: () => CorporateDetailPage.open(context),
          ),
          const SizedBox(height: 40),
          AppButton(
            label: l.corpVerifiedFunds,
            minHeight: 55,
            style: capsuleStyle,
            onPressed: () => context.go('/funds'),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: l.commonClose,
            variant: AppButtonVariant.secondary,
            minHeight: 50,
            style: capsuleStyle,
            onPressed: () => leaveCorporateFlow(context),
          ),
        ],
      ),
    );
  }
}
