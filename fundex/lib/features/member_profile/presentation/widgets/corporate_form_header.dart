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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading ?? title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
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
