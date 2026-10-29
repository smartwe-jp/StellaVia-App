import '../support/mypage_summary_styles.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import 'my_page_active_fund_summary_card.dart';

/// Redesigned summary card; the legacy card remains available to other pages.
class MyPageHoldingCard extends StatelessWidget {
  const MyPageHoldingCard({super.key, required this.data});
  final MyPageActiveFundSummaryCardData data;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = context.appTextTheme;
    final l10n = context.l10n;
    final image = data.imageUrls
        .where((url) => url.trim().isNotEmpty)
        .firstOrNull;
    final placeholder = ColoredBox(
      color: colors.surfaceAlt,
      child: Icon(Icons.apartment_rounded, color: colors.textSecondary),
    );
    return AppCard(
      onTap: data.onTap,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 72,
                  height: 90,
                  child: image == null
                      ? placeholder
                      : AppRemoteImage(
                          imageUrl: image,
                          fit: BoxFit.cover,
                          errorWidget: placeholder,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: data.statusBackgroundColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        data.statusLabel,
                        style: text.micro.copyWith(
                          color: data.statusForegroundColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.title,
                      style: MyPageSummaryStyles(context).fundTitle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _HoldingRow(
            label:
                '${data.investmentAmountLabel} / ${data.investmentUnitsLabel ?? ''}',
            value:
                '${data.investmentAmountValue} / ${data.investmentUnitsValue ?? '—'}',
          ),
          const SizedBox(height: 8),
          _HoldingRow(
            label: data.accumulatedEarningsLabel,
            value: data.accumulatedEarningsValue,
          ),
          const SizedBox(height: 8),
          _HoldingRow(
            label: l10n.fundListPeriodLabel,
            value: data.periodText ?? '—',
          ),
        ],
      ),
    );
  }
}

class _HoldingRow extends StatelessWidget {
  const _HoldingRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 2,
        child: Text(
          label,
          style: context.appTextTheme.caption.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        flex: 3,
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: MyPageSummaryStyles(context).value,
        ),
      ),
    ],
  );
}
