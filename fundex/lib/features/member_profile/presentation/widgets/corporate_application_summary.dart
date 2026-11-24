import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/repositories/verification_entry_repository.dart';
import '../pages/corporate_detail_page.dart';
import '../support/corporate_progress.dart';

class CorporateStatusNotice extends StatelessWidget {
  const CorporateStatusNotice({
    super.key,
    required this.entry,
    this.overview = false,
  });
  final VerificationEntry entry;
  final bool overview;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n, theme = Theme.of(context);
    final (title, description) = corporateStatusSummary(
      l,
      entry,
      overview: overview,
    );
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.appColors.surfaceAlt,
        borderRadius: BorderRadius.circular(UiTokens.radius8),
      ),
      padding: const EdgeInsets.all(UiTokens.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.corpStatusLabel,
            style: theme.appTextTheme.helper.copyWith(
              color: theme.appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.appTextTheme.cardTitle.copyWith(
              color: theme.appColors.primary,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.appTextTheme.body.copyWith(
                color: theme.appColors.textPrimary,
                height: 1.55,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CorporateApplicationLinks extends StatelessWidget {
  const CorporateApplicationLinks({super.key, required this.entry});
  final VerificationEntry entry;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n, theme = Theme.of(context);
    return Column(
      children: [
        for (final (label, icon, correction) in [
          (l.corpDetailView, CupertinoIcons.doc_text, false),
          if (entry.canCorrect)
            (l.corpDetailCorrect, CupertinoIcons.pencil, true),
        ]) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            minTileHeight: 54,
            leading: Icon(icon, size: 20, color: theme.colorScheme.primary),
            title: Text(label, style: theme.textTheme.titleSmall),
            trailing: const Icon(CupertinoIcons.chevron_right, size: 16),
            onTap: () =>
                CorporateDetailPage.open(context, correction: correction),
          ),
          const Divider(height: 1),
        ],
      ],
    );
  }
}
