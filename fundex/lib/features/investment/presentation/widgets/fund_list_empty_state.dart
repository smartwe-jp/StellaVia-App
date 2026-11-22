import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

/// Successful empty results, distinct from loading and request failures.
class FundListEmptyState extends StatelessWidget {
  const FundListEmptyState({super.key, required this.isPreparing});

  final bool isPreparing;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.appColors;
    final text = context.appTextTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary.withValues(alpha: 0.06),
              border: Border.all(color: colors.primary.withValues(alpha: 0.12)),
            ),
            child: Icon(
              isPreparing ? Icons.holiday_village_outlined : Icons.search_off,
              size: 44,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isPreparing ? l.fundListComingSoonLabel : l.fundListNoMatchLabel,
            textAlign: TextAlign.center,
            style: text.caption.copyWith(color: colors.primary),
          ),
          const SizedBox(height: 12),
          Text(
            isPreparing ? l.fundListPreparingTitle : l.fundListEmpty,
            textAlign: TextAlign.center,
            style: text.sectionTitle.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 12),
          Text(
            isPreparing ? l.fundListPreparingBody : l.fundListNoMatchBody,
            textAlign: TextAlign.center,
            style: text.bodyMuted.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
