import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import 'home_data_status.dart';
import '../support/home_text_styles.dart';
import 'home_action_icon.dart';

class HomeMilesCard extends StatelessWidget {
  const HomeMilesCard({
    super.key,
    required this.onTap,
    this.balance = '—',
    this.hasBalance = false,
    this.isLoading = false,
    this.hasError = false,
    this.onRetry,
  });
  final String balance;
  final bool hasBalance;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              const HomeActionIcon(Icons.card_giftcard_outlined),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.homeHostMiles,
                      style: context.appTextTheme.caption,
                    ),
                    const SizedBox(height: 4),
                    Semantics(
                      label: hasBalance
                          ? context.l10n.homeMilesBalanceLabel(balance)
                          : context.l10n.homeMilesUnavailable,
                      child: ExcludeSemantics(
                        child: Text(
                          balance,
                          key: const Key('home_available_miles'),
                          style: context.appTextTheme.numericTitle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Text(
                  context.l10n.homeBookWithMiles,
                  textAlign: TextAlign.end,
                  style: HomeTextStyles.smallLink(context),
                ),
              ),

              Icon(
                Icons.chevron_right,
                size: 16,
                color: context.appColors.primary,
              ),
            ],
          ),
        ),
        HomeDataStatus(
          isLoading: isLoading,
          hasError: hasError,
          onRetry: onRetry,
        ),
      ],
    ),
  );
}
