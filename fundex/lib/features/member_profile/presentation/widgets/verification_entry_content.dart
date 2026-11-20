import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../pages/corporate_form_page.dart';
import 'verification_entry_scaffold.dart';
import '../pages/corporate_detail_page.dart';
import '../pages/corporate_progress_page.dart';
import '../support/corporate_progress.dart';
import '../support/corporate_form_fields.dart';
import '../../domain/repositories/verification_entry_repository.dart';

class InvestorChoice extends StatefulWidget {
  const InvestorChoice({
    super.key,
    required this.onPersonal,
    required this.onCorporate,
  });
  final VoidCallback onPersonal, onCorporate;
  @override
  State<InvestorChoice> createState() => _InvestorChoiceState();
}

class _InvestorChoiceState extends State<InvestorChoice> {
  bool? corporate;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(l.investorTypeTitle, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 20),
        for (final option in [false, true])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: corporate == option
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant,
                ),
              ),
              child: ListTile(
                selected: corporate == option,
                leading: Icon(
                  corporate == option
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                title: Text(option ? l.corporateInvestor : l.personalInvestor),
                subtitle: Text(
                  option ? l.corporateInvestorNote : l.personalInvestorNote,
                ),
                onTap: () => setState(() => corporate = option),
              ),
            ),
          ),
        AppButton(
          label: l.profileNextStep,
          onPressed: corporate == null
              ? null
              : corporate!
              ? widget.onCorporate
              : widget.onPersonal,
        ),
      ],
    );
  }
}

class CorporateEntryContent extends StatefulWidget {
  const CorporateEntryContent({super.key, this.entry, this.onRefresh});
  static Future<void> openPreparation(BuildContext context) =>
      Navigator.of(context, rootNavigator: true).push<void>(
        MaterialPageRoute<void>(
          settings: const RouteSettings(
            name: 'corporate-verification/preparation',
          ),
          builder: (_) =>
              const VerificationEntryScaffold(child: CorporateEntryContent()),
        ),
      );

  final VerificationEntry? entry;
  final VoidCallback? onRefresh;
  @override
  State<CorporateEntryContent> createState() => _CorporateEntryContentState();
}

class _CorporateEntryContentState extends State<CorporateEntryContent> {
  bool _opened = false;
  late final draftForm =
      widget.entry?.submittedForm?.copyForEditing(
        correction: widget.entry!.isCorrection,
      ) ??
      CorporateFormDraft(
        companyName: widget.entry?.companyName,
        isCorrection: widget.entry?.isCorrection ?? false,
      );
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final entry = widget.entry;
    final onRefresh = widget.onRefresh;
    final status = entry?.status;
    final draft = status == null || status.isEmpty || status == 'DRAFT';
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          l.corporateVerificationTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        if (entry?.companyName?.isNotEmpty == true)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(entry!.companyName!),
          ),
        const SizedBox(height: 16),
        if (entry != null)
          Card(
            child: ListTile(
              title: Text(l.corporateStatusTitle),
              subtitle: Text(l.corporateStatus(draft ? 'DRAFT' : status)),
            ),
          ),
        if (draft && entry?.isCorrection != true) ...[
          const SizedBox(height: 16),
          Text(
            l.corporatePrepareTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(l.corporatePrepareBody),
          const SizedBox(height: 16),
          Text(l.corporateProcessNote),
          const SizedBox(height: 24),
          AppButton(
            label: draftForm.hasEntries && _opened
                ? l.corpFormResume
                : l.corpFormStart,
            onPressed: () async {
              _opened = true;
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  settings: RouteSettings(
                    name: corporateStepRoute(CorporateSection.company),
                  ),
                  builder: (_) => CorporateFormPage(
                    draft: draftForm,
                    section: CorporateSection.company,
                  ),
                ),
              );
              if (mounted) setState(() {});
            },
          ),
        ],
        if (entry != null &&
            status != 'CONFIRMED' &&
            CorporateProgress.fromEntry(entry) != null)
          AppButton(
            label: l.corpProgressOpen,
            onPressed: () => CorporateProgressPage.open(context),
          ),
        if (entry?.submittedForm != null) ...[
          const SizedBox(height: 12),
          AppButton(
            label: l.corpDetailView,
            variant: AppButtonVariant.secondary,
            onPressed: () => CorporateDetailPage.open(context),
          ),
          if (entry!.canCorrect) ...[
            const SizedBox(height: 12),
            AppButton(
              label: l.corpDetailCorrect,
              onPressed: () =>
                  CorporateDetailPage.open(context, correction: true),
            ),
          ],
        ],
        if (onRefresh != null) ...[
          const SizedBox(height: 20),
          AppButton(
            variant: AppButtonVariant.secondary,
            label: l.corporateRefresh,
            onPressed: onRefresh,
          ),
        ],
      ],
    );
  }
}
