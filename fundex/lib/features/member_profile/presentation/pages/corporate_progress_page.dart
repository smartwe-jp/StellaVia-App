import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/verification_entry_provider.dart';
import '../../domain/repositories/verification_entry_repository.dart';
import 'corporate_mail_action_page.dart';
import '../widgets/corporate_application_summary.dart';
import '../widgets/corporate_flow_scaffold.dart';
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
    final current = entry.asData?.value;
    if (current?.kind == VerificationEntryKind.corporate &&
        current?.status == 'CONFIRMED') {
      return VerificationEntryScaffold(
        resultPage: true,
        child: CorporateVerifiedContent(companyName: current?.companyName),
      );
    }
    return CorporateFlowScaffold(
      title: l.corpProgressHeading,

      refresh: () => ref.invalidate(verificationEntryProvider),
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
          final progress = CorporateProgress.fromEntry(e);
          final status = e.status ?? '';
          final notice = CorporateProgress.latestNotice(e.auditLogs);
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
                if (e.companyName?.isNotEmpty == true)
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Text(e.companyName!),
                  ),
                const SizedBox(height: 24),
                CorporateStatusNotice(entry: e),
                const SizedBox(height: 16),
                for (final action in CorporateMailAction.values)
                  if (e.userOps.contains(action.code))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppButton(
                        minHeight: 55,
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
                const SizedBox(height: 20),
                if (progress != null)
                  Text(l.corpFlowLabel, style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),
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
                CorporateApplicationLinks(entry: e),
              ],
            ),
          );
        },
      ),
    );
  }
}
