import '../support/mypage_summary_styles.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../app/localization/app_localizations_ext.dart';

/// My Page composition. Money visibility applies to every amount in this card.
class MyPageAssetSummary extends StatefulWidget {
  const MyPageAssetSummary({
    super.key,
    required this.displayName,
    required this.totalAssetsValue,
    required this.metrics,
    required this.onDeposit,
    required this.onWithdraw,
    this.verificationBadge,
  });
  final String displayName;
  final String totalAssetsValue;
  final List<FundMyPageMetricData> metrics;
  final FundMyPageVerificationBadgeData? verificationBadge;
  final VoidCallback onDeposit;
  final VoidCallback onWithdraw;
  @override
  State<MyPageAssetSummary> createState() => _MyPageAssetSummaryState();
}

class _MyPageAssetSummaryState extends State<MyPageAssetSummary> {
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final text = context.appTextTheme;
    final badge = widget.verificationBadge;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                l10n.myPageAssetGreeting(widget.displayName),
                style: MyPageSummaryStyles(context).heading,
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badge.backgroundColor,
                    border: Border.all(
                      color: badge.borderColor ?? colors.border,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge.label,
                    style: text.micro.copyWith(color: badge.foregroundColor),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.myPageAssetHelper,
            style: text.caption.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 16),
          AppCard(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.myPageTotalAssetsLabel,
                        style: text.caption,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                      width: 40,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        tooltip: _visible
                            ? l10n.myPageHideAmounts
                            : l10n.myPageShowAmounts,
                        icon: Icon(
                          _visible
                              ? Symbols.visibility
                              : Symbols.visibility_off,
                          size: 18,
                          color: colors.textSecondary,
                        ),
                        onPressed: () => setState(() => _visible = !_visible),
                      ),
                    ),
                  ],
                ),
                Text(
                  _visible ? widget.totalAssetsValue : '••••••',
                  style: MyPageSummaryStyles(context).total,
                ),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final twoColumns =
                        constraints.maxWidth >= 300 &&
                        MediaQuery.textScalerOf(context).scale(1) <= 1.2;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        for (final metric
                            in (widget.metrics.length == 3
                                ? [
                                    widget.metrics[0],
                                    widget.metrics[2],
                                    widget.metrics[1],
                                  ]
                                : widget.metrics))
                          SizedBox(
                            width: twoColumns
                                ? (constraints.maxWidth - 16) / 2
                                : constraints.maxWidth,
                            child: InkWell(
                              onTap: metric.onTap,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        metric.label,
                                        style: text.micro.copyWith(
                                          color: colors.textSecondary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        _visible ? metric.value : '••••',
                                        textAlign: TextAlign.end,
                                        style: MyPageSummaryStyles(
                                          context,
                                        ).metric,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: colors.border),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: l10n.myPageDepositAction,
                        minHeight: 46,
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: widget.onDeposit,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        label: l10n.myPageWithdrawAction,
                        minHeight: 46,
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        variant: AppButtonVariant.secondary,
                        onPressed: widget.onWithdraw,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyPageHeaderAction extends StatelessWidget {
  const MyPageHeaderAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.unreadCount = 0,
  });
  final IconData icon;
  final VoidCallback onTap;
  final int unreadCount;
  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onTap,
    tooltip: icon == Symbols.settings
        ? context.l10n.mainTabSettings
        : context.l10n.notificationsTitle,
    icon: Badge(
      isLabelVisible: unreadCount > 0,
      child: Icon(
        icon,
        size: 22,
        color: icon == Symbols.settings
            ? context.appColors.textPrimary
            : context.appColors.primary,
      ),
    ),
  );
}
