import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../pages/corporate_form_page.dart';
import 'corporate_application_summary.dart';
import '../pages/corporate_progress_page.dart';
import '../support/corporate_progress.dart';
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
  const CorporateEntryContent({super.key, this.entry, this.seed});
  final VerificationEntry? entry, seed;
  @override
  State<CorporateEntryContent> createState() => _CorporateEntryContentState();
}

class _CorporateEntryContentState extends State<CorporateEntryContent> {
  bool _opened = false;
  VerificationEntry? get source => widget.seed ?? widget.entry;
  late final CorporateFormDraft? draftForm = _initialDraft();

  CorporateFormDraft? _initialDraft() {
    final entry = source;
    if (entry != null &&
        (entry.isCorrection ||
            (entry.status?.isNotEmpty == true && entry.status != 'DRAFT'))) {
      return entry.correctionDraft();
    }
    return entry?.submittedForm?.copyForEditing(correction: false) ??
        CorporateFormDraft(companyName: entry?.companyName);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final entry = widget.entry;
    final status = entry?.status;
    final draft = status == null || status.isEmpty || status == 'DRAFT';
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (entry != null) ...[
          if (entry.companyName?.isNotEmpty == true)
            Text(
              entry.companyName!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 36),
          Text(
            l.corporateVerificationTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          CorporateStatusNotice(entry: entry, overview: true),
          const SizedBox(height: 16),
        ],
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
            label: draftForm?.hasEntries == true && _opened
                ? l.corpFormResume
                : l.corpFormStart,
            onPressed: draftForm == null
                ? null
                : () async {
                    _opened = true;
                    await CorporateFormPage.start(context, draftForm!);
                    if (mounted) setState(() {});
                  },
          ),
        ],
        if (entry == null) ...[
          const SizedBox(height: 12),
          AppButton(
            label: l.profilePrevStep,
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
        if (entry != null &&
            status != 'CONFIRMED' &&
            CorporateProgress.fromEntry(entry) != null)
          AppButton(
            label: l.corpProgressOpen,
            minHeight: 55,
            style: const ButtonStyle(
              shape: WidgetStatePropertyAll(StadiumBorder()),
            ),
            onPressed: () => CorporateProgressPage.open(context),
          ),
        if (entry?.submittedForm != null) ...[
          const SizedBox(height: 40),
          Text(
            l.corpApplicationLabel,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 8),
          CorporateApplicationLinks(entry: entry!),
        ],
      ],
    );
  }
}
