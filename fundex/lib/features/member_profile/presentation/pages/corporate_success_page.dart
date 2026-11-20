import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/verification_entry_provider.dart';
import '../widgets/corporate_stage_indicator.dart';
import '../widgets/verification_entry_scaffold.dart';
import 'corporate_progress_page.dart';

class CorporateSuccessPage extends ConsumerWidget {
  const CorporateSuccessPage({super.key, required this.companyName});
  final String companyName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n, theme = Theme.of(context);
    final entry = ref.watch(verificationEntryProvider).asData?.value;
    final name = entry?.companyName ?? companyName;
    const buttonStyle = ButtonStyle(
      shape: WidgetStatePropertyAll(StadiumBorder()),
    );
    return VerificationEntryScaffold(
      resultPage: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          const CorporateStageIndicator(current: 2),
          const SizedBox(height: 24),
          Text(l.corpProgressSuccess, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(l.corpProgressSuccessBody),
          const SizedBox(height: 24),
          Card(
            color: theme.appColors.surfaceAlt,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.corpProgressNext, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(l.corpProgressMailHint),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (name.isNotEmpty) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l.corpProgressApplicant,
                style: theme.textTheme.bodySmall,
              ),
              subtitle: Text(name, style: theme.textTheme.titleMedium),
            ),
            const Divider(),
          ],
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              l.corporateStatusTitle,
              style: theme.textTheme.bodySmall,
            ),
            subtitle: Text(
              l.corporateStatus(entry?.status ?? 'SUBMITTED'),
              style: theme.textTheme.titleMedium,
            ),
          ),
          const Divider(),
          const SizedBox(height: 12),
          Text(l.corpProgressTrading, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(l.corpProgressTradingHint),
          const SizedBox(height: 32),
          AppButton(
            label: l.corpProgressOpen,
            onPressed: () => CorporateProgressPage.open(context),
            style: buttonStyle,
          ),
          const SizedBox(height: 12),
          AppButton(
            label: l.corpProgressMyPage,
            variant: AppButtonVariant.secondary,
            onPressed: () => context.go('/profile'),
            style: buttonStyle,
          ),
        ],
      ),
    );
  }
}
