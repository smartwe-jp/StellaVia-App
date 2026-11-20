import 'corporate_stage_indicator.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../support/corporate_form_fields.dart';

class CorporateFormHeader extends StatelessWidget {
  const CorporateFormHeader({
    super.key,
    required this.section,
    this.heading,
    this.review = false,
  });
  final CorporateSection section;
  final String? heading;
  final bool review;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n,
        theme = Theme.of(context),
        title = review ? l.corpFormReviewTitle : sectionTitle(l, section);
    final index = review ? 6 : section.index;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CorporateStageIndicator(
          current: section == CorporateSection.documents ? 2 : 1,
        ),
        const SizedBox(height: 24),
        Text(
          '${l.corpFormStep} ${index + 1} / 7 ・ $title',
          style: theme.textTheme.labelLarge,
        ),
        AppStepProgressBar(
          stepCount: 7,
          currentStep: index,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        Text(heading ?? title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          review
              ? l.corpReviewHint
              : switch (section) {
                  CorporateSection.company => l.corpFormCompanyHint,
                  CorporateSection.representative => l.corpFormRepHint,
                  CorporateSection.handler => l.corpFormHandlerHint,
                  CorporateSection.bank => l.corpBankHint,
                  CorporateSection.documents => l.corpDocsHint,
                  CorporateSection.owners => l.corpOwnerHint,
                },
        ),
      ],
    );
  }
}
