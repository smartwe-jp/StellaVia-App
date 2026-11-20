import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../../domain/repositories/verification_entry_repository.dart';
import '../providers/verification_entry_provider.dart';
import '../support/corporate_form_fields.dart';
import '../widgets/corporate_detail_sections.dart';
import '../widgets/verification_entry_scaffold.dart';
import 'corporate_form_page.dart';

class CorporateDetailPage extends ConsumerWidget {
  const CorporateDetailPage({
    super.key,
    this.correction = false,
    this.readOnly = false,
  });
  final bool correction, readOnly;
  static void open(
    BuildContext context, {
    bool correction = false,
    bool readOnly = false,
  }) {
    final nav = Navigator.of(context);
    ProviderScope.containerOf(
      context,
      listen: false,
    ).invalidate(verificationEntryProvider);
    nav.push(
      MaterialPageRoute<void>(
        settings: RouteSettings(
          name: '$corporateRoutePrefix${correction ? 'correction' : 'detail'}',
        ),
        builder: (_) =>
            CorporateDetailPage(correction: correction, readOnly: readOnly),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n, theme = Theme.of(context);
    const style = ButtonStyle(shape: WidgetStatePropertyAll(StadiumBorder()));
    final result = ref.watch(verificationEntryProvider);
    Widget unavailable() => Column(
      children: [
        Text(l.uiErrorRequestFailed),
        AppButton(
          label: l.commonRetry,
          onPressed: () => ref.invalidate(verificationEntryProvider),
        ),
      ],
    );
    Widget content(VerificationEntry entry) {
      final form = entry.submittedForm;
      if (form == null || entry.kind != VerificationEntryKind.corporate) {
        return unavailable();
      }
      final editing = correction && entry.canCorrect;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            editing ? l.corpDetailEditTitle : l.corpDetailTitle,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(editing ? l.corpDetailPrefill : entry.companyName ?? ''),
          const SizedBox(height: 24),
          Card(
            margin: EdgeInsets.zero,
            color: theme.appColors.surfaceAlt,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    editing
                        ? l.corpDetailScopeTitle
                        : l.corporateStatus(entry.status ?? ''),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(editing ? l.corpDetailScope : l.corpDetailInfo),
                ],
              ),
            ),
          ),
          if (editing) ...[
            const SizedBox(height: 24),
            Text(l.corpBankTitle, style: theme.textTheme.bodySmall),
            Text(l.corpDetailBank),
            const Divider(),
            const SizedBox(height: 16),
            Text(l.corpDetailResubmit, style: theme.textTheme.titleMedium),
            const Divider(),
            const SizedBox(height: 12),
            Text(l.corpDetailChanges),
            const SizedBox(height: 16),
            AppButton(
              label: l.corpDetailView,
              style: style,
              variant: AppButtonVariant.secondary,
              onPressed: () => open(context, readOnly: true),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: l.corpDetailStart,
              style: style,
              onPressed: () {
                final latest = ref
                    .read(verificationEntryProvider)
                    .asData
                    ?.value;
                if (latest?.canCorrect != true ||
                    latest?.submittedForm == null) {
                  return;
                }
                final draft = latest!.submittedForm!.copyForEditing(
                  correction: true,
                );
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    settings: RouteSettings(
                      name: corporateStepRoute(CorporateSection.company),
                    ),
                    builder: (_) => CorporateFormPage(
                      draft: draft,
                      section: CorporateSection.company,
                    ),
                  ),
                );
              },
            ),
          ] else ...[
            CorporateDetailSections(form: form),
            if (entry.canCorrect && !readOnly) ...[
              const SizedBox(height: 24),
              AppButton(
                label: l.corpDetailCorrect,
                style: style,
                onPressed: () => open(context, correction: true),
              ),
            ],
          ],
          const SizedBox(height: 12),
          AppButton(
            label: editing ? l.commonCancel : l.corpDetailHide,
            style: style,
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      );
    }

    return VerificationEntryScaffold(
      resultPage: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          result.when(
            skipLoadingOnRefresh: false,
            data: content,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => unavailable(),
          ),
        ],
      ),
    );
  }
}
