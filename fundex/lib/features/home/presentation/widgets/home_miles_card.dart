import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import 'home_data_status.dart';

class HomeMilesCard extends StatelessWidget {
  const HomeMilesCard({
    super.key,
    required this.onTap,
    this.rank = '—',
    this.expiring = '—',
    this.balance = '—',
    this.hasBalance = false,
    this.isLoading = false,
    this.hasError = false,
    this.onRetry,
  });
  final String rank, balance, expiring;
  final bool hasBalance;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final text = context.appTextTheme;
    return AppCard(
      backgroundColor: context.appColors.surfaceAlt,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(l.homeRankLabel, style: text.bodyStrong)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  rank,
                  textAlign: TextAlign.end,
                  style: text.numericTitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.myPageChartMilesBalance, style: text.caption),
                    Semantics(
                      label: hasBalance
                          ? l.homeMilesBalanceLabel(balance)
                          : l.homeMilesUnavailable,
                      excludeSemantics: true,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        spacing: 4,
                        children: [
                          Text(
                            balance,
                            key: const Key('home_available_miles'),
                            style: text.numericTitle,
                          ),
                          Text(l.benefitsMilesUnit, style: text.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l.myPageRankExpiring,
                      textAlign: TextAlign.end,
                      style: text.caption,
                    ),
                    Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      spacing: 4,
                      children: [
                        Text(expiring, style: text.numericTitle),
                        Text(l.benefitsMilesUnit, style: text.caption),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppButton(label: l.homeBookWithMiles, onPressed: onTap),
          if (isLoading || hasError)
            HomeDataStatus(
              isLoading: isLoading,
              hasError: hasError,
              onRetry: onRetry,
            ),
        ],
      ),
    );
  }
}
