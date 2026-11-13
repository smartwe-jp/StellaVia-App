import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/support/mypage_section_support.dart';

class SecondaryPurchaseBreakdown extends StatelessWidget {
  const SecondaryPurchaseBreakdown({super.key, required this.record});

  final MyPageApplyRecord record;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final text = context.appTextTheme;
    final currency = NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );
    final rows = [
      (
        l.myPageApplySubmittedAtLabel,
        formatDateTimeOrNull(record.applyTime) ?? '—',
      ),
      (
        l.secondaryApprovedUnits,
        record.passNum == null
            ? '—'
            : '${record.passNum} ${l.myPageResaleUnitsSuffix}',
      ),
      (
        l.secondaryApprovedAmount,
        record.passMoney == null ? '—' : currency.format(record.passMoney),
      ),
      if (formatDateTimeOrNull(record.passTime) case final value?)
        (l.secondaryApprovedAt, value),
      if (formatDateTimeOrNull(record.actualArrivalTime) case final value?)
        (l.secondaryPaymentReceivedAt, value),
    ];
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.secondaryPurchaseBreakdown, style: text.cardTitle),
          const SizedBox(height: 8),
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(child: Text(label, style: text.bodyMuted)),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      value,
                      style: text.bodySemi,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
