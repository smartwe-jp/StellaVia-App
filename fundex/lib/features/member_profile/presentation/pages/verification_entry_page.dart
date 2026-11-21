import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/repositories/verification_entry_repository.dart';
import '../providers/verification_entry_provider.dart';
import '../widgets/verification_entry_content.dart';
import '../widgets/corporate_flow_scaffold.dart';
import 'corporate_verification_modal.dart';
import 'corporate_progress_page.dart';
import '../widgets/corporate_verified_content.dart';
import '../widgets/verification_entry_scaffold.dart';
import 'member_profile_overview_page.dart';

class VerificationEntryPage extends ConsumerWidget {
  const VerificationEntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(verificationEntryProvider);
    void refresh() => ref.invalidate(verificationEntryProvider);
    return entry.when(
      skipLoadingOnRefresh: false,
      data: (value) => switch (value.kind) {
        VerificationEntryKind.personal => const MemberProfileOverviewPage(),
        VerificationEntryKind.choice => InvestorChoice(
          onPersonal: () async {
            await context.push('/member-profile/onboarding');
            if (context.mounted) refresh();
          },
          onCorporate: () async {
            await openCorporateVerification(context, value);
            if (context.mounted) refresh();
          },
        ),
        VerificationEntryKind.corporate when value.status == 'CONFIRMED' =>
          VerificationEntryScaffold(
            resultPage: true,
            child: CorporateVerifiedContent(companyName: value.companyName),
          ),
        VerificationEntryKind.corporate when value.status == 'EXPIRED' =>
          CorporateFlowScaffold(
            title: context.l10n.corporateVerificationTitle,
            refresh: refresh,
            child: CorporateExpiredContent(entry: value, onRetry: refresh),
          ),
        VerificationEntryKind.corporate
            when value.status?.isNotEmpty == true && value.status != 'DRAFT' =>
          const CorporateProgressPage(),
        VerificationEntryKind.corporate => CorporateFlowScaffold(
          title: context.l10n.corporateVerificationTitle,
          refresh: refresh,
          child: CorporateEntryContent(
            entry: value,
            key: ValueKey(value.isCorrection),
          ),
        ),
      },
      loading: () => const VerificationEntryScaffold(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => VerificationEntryScaffold(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(context.l10n.uiErrorRequestFailed),
            const SizedBox(height: 16),
            AppButton(label: context.l10n.commonRetry, onPressed: refresh),
          ],
        ),
      ),
    );
  }
}
