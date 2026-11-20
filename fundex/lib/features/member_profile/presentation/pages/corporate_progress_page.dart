import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/verification_entry_provider.dart';
import '../../domain/repositories/verification_entry_repository.dart';
import 'corporate_mail_action_page.dart';
import 'corporate_detail_page.dart';
import '../support/corporate_progress.dart';
import '../widgets/corporate_progress_timeline.dart';
import '../widgets/corporate_verified_content.dart';
import '../widgets/verification_entry_scaffold.dart';

class CorporateProgressPage extends ConsumerWidget {
  const CorporateProgressPage({super.key});
  static void open(BuildContext context) {
    ProviderScope.containerOf(
      context,
      listen: false,
    ).invalidate(verificationEntryProvider);
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const CorporateProgressPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n, theme = Theme.of(context);
    final entry = ref.watch(verificationEntryProvider);
    return VerificationEntryScaffold(
      resultPage: true,
      child: entry.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(l.uiErrorRequestFailed),
            AppButton(
              label: l.commonRetry,
              onPressed: () => ref.invalidate(verificationEntryProvider),
            ),
          ],
        ),
        data: (e) {
          if (e.kind == VerificationEntryKind.corporate &&
              e.status == 'CONFIRMED') {
            return CorporateVerifiedContent(companyName: e.companyName);
          }
          final progress = CorporateProgress.fromEntry(e);
          final status = e.status ?? '';
          final heading = status == 'REJECTED'
              ? l.corpProgressCorrection
              : l.corpProgressTitle;
          final notice = CorporateProgress.latestNotice(e.auditLogs);
          final calloutTitle = switch (progress?.current) {
            CorporateStage.originalMail when progress?.actionRequired == true =>
              l.corpProgressSendOriginal,
            CorporateStage.receipt when progress?.actionRequired == true =>
              l.corpProgressCheckReceipt,
            _ => l.corporateStatus(status),
          };
          final description = switch (status) {
            'SUBMITTED' when progress?.actionRequired == true =>
              l.corpProgressMailHint,
            'CUSTOMER_MAILED' => l.corpProgressReviewing,
            'ADMIN_MAILED' || 'MAILED' when progress?.actionRequired == true =>
              l.corpProgressReceiptHint,
            'REJECTED' =>
              progress?.message?.isNotEmpty == true
                  ? progress!.message!
                  : l.corpProgressCorrection,
            _ => l.corporateStatus(status),
          };
          return RefreshIndicator(
            onRefresh: () async {
              // The provider renders its error state with a retry action.
              await ref
                  .refresh(verificationEntryProvider.future)
                  .then<void>((_) {}, onError: (Object _, StackTrace _) {});
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                Text(heading, style: theme.textTheme.headlineSmall),
                if (e.companyName?.isNotEmpty == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(e.companyName!),
                  ),
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
                        Text(
                          calloutTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        if (description != calloutTitle) ...[
                          const SizedBox(height: 8),
                          Text(description),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (progress != null)
                  CorporateProgressTimeline(progress: progress, status: status),
                if (notice != null &&
                    notice.customerMessage != progress?.message) ...[
                  Text(l.corpProgressLatest, style: theme.textTheme.labelLarge),
                  Text(
                    MaterialLocalizations.of(
                      context,
                    ).formatMediumDate(notice.createdAt!.toLocal()),
                  ),
                  Text(notice.customerMessage!),
                  const Divider(),
                ],
                for (final action in CorporateMailAction.values)
                  if (e.userOps.contains(action.code))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppButton(
                        label: action == CorporateMailAction.sent
                            ? l.corpMailSent
                            : l.corpMailReceived,
                        style: const ButtonStyle(
                          shape: WidgetStatePropertyAll(StadiumBorder()),
                        ),
                        onPressed: (e.applicationId ?? 0) <= 0
                            ? null
                            : () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => CorporateMailActionPage(
                                    action: action,
                                    id: e.applicationId!,
                                  ),
                                ),
                              ),
                      ),
                    ),
                AppButton(
                  label: l.corpDetailView,
                  variant: AppButtonVariant.secondary,
                  style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(StadiumBorder()),
                  ),
                  onPressed: () => CorporateDetailPage.open(context),
                ),
                if (e.canCorrect) ...[
                  const SizedBox(height: 12),
                  AppButton(
                    label: l.corpDetailCorrect,
                    style: const ButtonStyle(
                      shape: WidgetStatePropertyAll(StadiumBorder()),
                    ),
                    onPressed: () =>
                        CorporateDetailPage.open(context, correction: true),
                  ),
                ],
                const SizedBox(height: 12),
                AppButton(
                  label: l.corporateRefresh,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => ref.invalidate(verificationEntryProvider),
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: l.corpProgressMyPage,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => context.go('/profile'),
                  style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(StadiumBorder()),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
