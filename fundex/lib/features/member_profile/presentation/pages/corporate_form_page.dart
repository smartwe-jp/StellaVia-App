import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../support/corporate_form_fields.dart';
import '../widgets/verification_entry_scaffold.dart';
import '../widgets/corporate_form_inputs.dart';
import '../widgets/corporate_form_header.dart';
import 'corporate_documents_page.dart';
import '../widgets/beneficial_owner_list.dart';

class CorporateFormPage extends StatefulWidget {
  const CorporateFormPage({
    super.key,
    required this.draft,
    required this.section,
  });
  final CorporateFormDraft draft;
  final CorporateSection section;
  @override
  State<CorporateFormPage> createState() => _CorporateFormPageState();
}

class _CorporateFormPageState extends State<CorporateFormPage> {
  final form = GlobalKey<FormState>();
  CorporateSection? get nextSection {
    final sections = widget.draft.sections.toList();
    final next = sections.indexOf(widget.section) + 1;
    return next == sections.length ? null : sections[next];
  }

  Future<void> advance() async {
    final invalid = form.currentState!.validateGranularly();
    if (invalid.isNotEmpty) {
      await Scrollable.ensureVisible(invalid.first.context, alignment: 0.18);
      return;
    }
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    final section = nextSection;
    final next = section == CorporateSection.documents
        ? CorporateDocumentsPage(draft: widget.draft)
        : CorporateFormPage(draft: widget.draft, section: section!);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: RouteSettings(name: corporateStepRoute(section!)),
        builder: (_) => next,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, section = widget.section;
    return VerificationEntryScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CorporateFormHeader(section: section),
              const SizedBox(height: 24),
              if (section == CorporateSection.bank)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Card(
                    child: ListTile(
                      title: Text(l.corpBankNoticeTitle),
                      subtitle: Text(l.corpBankNotice),
                    ),
                  ),
                ),
              if (section == CorporateSection.handler)
                CorporateHandlerChoice(
                  draft: widget.draft,
                  onChanged: () => setState(() {}),
                ),
              if (section == CorporateSection.owners)
                BeneficialOwnerList(draft: widget.draft),
              for (final field in widget.draft.fields(section))
                Padding(
                  key: ValueKey(field),
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CorporateFormInput(
                    draft: widget.draft,
                    section: section,
                    field: field,
                    onStructureChanged: () => setState(() {}),
                  ),
                ),
              AppButton(
                label: nextSection == null
                    ? l.corpFormReview
                    : sectionTitle(l, nextSection!),
                onPressed: advance,
                style: const ButtonStyle(
                  shape: WidgetStatePropertyAll(StadiumBorder()),
                ),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: l.profilePrevStep,
                variant: AppButtonVariant.secondary,
                onPressed: () => Navigator.of(context).pop(),
                style: const ButtonStyle(
                  shape: WidgetStatePropertyAll(StadiumBorder()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
