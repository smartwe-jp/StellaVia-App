import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/widgets/global_lottie_playback.dart';
import '../models/benefit_lottery_models.dart';

const String benefitLotteryWinLottieUrl =
    'https://lottie.host/1250b4dc-207e-459d-bbc3-7d722732b960/k7jtRV62H8.lottie';

typedef BenefitLotteryWinPresenter =
    Future<bool> Function(
      BuildContext context, {
      required BenefitLotteryPrize prize,
    });

Future<bool> showBenefitLotteryWinPresentation(
  BuildContext context, {
  required BenefitLotteryPrize prize,
}) async {
  await showGlobalLottiePlayback(context, url: benefitLotteryWinLottieUrl);
  if (!context.mounted) {
    return false;
  }
  return await showBenefitLotteryWinDialog(context, prize: prize) ?? false;
}

Future<bool?> showBenefitLotteryWinDialog(
  BuildContext context, {
  required BenefitLotteryPrize prize,
}) {
  final colors = Theme.of(context).appColors;
  return showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: colors.surface.withValues(alpha: 0),
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: BenefitLotteryWinDialog(prize: prize),
        ),
      );
    },
  );
}

class BenefitLotteryWinDialog extends StatelessWidget {
  const BenefitLotteryWinDialog({required this.prize, super.key});

  final BenefitLotteryPrize prize;

  static final DateTime _mockWonAt = DateTime(2025, 12, 18);
  static final DateTime _mockExpiresAt = DateTime(2026, 6, 30);
  static const String _mockCouponCode = 'SV-A8K2-9XPQ';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFormatter = DateFormat.yMMMMd(locale);
    final amountFormatter = NumberFormat.currency(
      locale: locale,
      symbol: '¥',
      decimalDigits: 0,
    );
    final grade = prize.id.toUpperCase();

    return Material(
      key: const Key('benefit_lottery_win_dialog'),
      color: colors.background,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(UiTokens.radius28),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  UiTokens.spacing24,
                  UiTokens.spacing32,
                  UiTokens.spacing24,
                  UiTokens.spacing20,
                ),
                decoration: BoxDecoration(color: colors.primarySubtle),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 62,
                      height: 62,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(UiTokens.radius16),
                        color: colors.primary,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: colors.primaryAlt.withValues(alpha: 0.45),
                            blurRadius: 26,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Text(
                        grade,
                        style: appText.heroTitle.copyWith(
                          color: colors.onDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: UiTokens.spacing16),
                    Text(
                      l10n.benefitLotteryWinCongratulations,
                      textAlign: TextAlign.center,
                      style: appText.bodyStrong.copyWith(
                        color: colors.infoForeground,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: UiTokens.spacing8),
                    Text(
                      l10n.benefitLotteryWinPrizeMessage(grade),
                      textAlign: TextAlign.center,
                      style: appText.cardTitle.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: UiTokens.spacing8),
                    Text(
                      amountFormatter.format(prize.price),
                      style: appText.numericHeadline.copyWith(
                        color: colors.infoForeground,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: UiTokens.spacing12),
                    Text(
                      l10n.benefitLotteryWinExpiration(
                        dateFormatter.format(_mockExpiresAt),
                      ),
                      style: appText.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  UiTokens.spacing20,
                  0,
                  UiTokens.spacing20,
                  UiTokens.spacing24,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: UiTokens.spacing16,
                        vertical: UiTokens.spacing8,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(UiTokens.radius12),
                        border: Border.all(color: colors.border),
                      ),
                      child: Column(
                        children: <Widget>[
                          _WinMetaRow(
                            label: l10n.benefitLotteryWinDateLabel,
                            value: dateFormatter.format(_mockWonAt),
                          ),
                          _WinMetaRow(
                            label: l10n.benefitLotteryWinFundLabel,
                            value: l10n.benefitLotteryWinMockFundName,
                          ),
                          _WinMetaRow(
                            label: l10n.benefitLotteryWinCouponCodeLabel,
                            value: _mockCouponCode,
                            isCode: true,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: UiTokens.spacing16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        key: const Key('benefit_lottery_win_confirm'),
                        onPressed: () => Navigator.of(context).pop(true),
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onDark,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              UiTokens.radius12,
                            ),
                          ),
                        ),
                        child: Text(
                          l10n.benefitLotteryWinConfirmAction,
                          style: appText.button.copyWith(
                            color: colors.onDark,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: UiTokens.spacing8),
                    Text(
                      l10n.benefitLotteryWinHistoryNote,
                      textAlign: TextAlign.center,
                      style: appText.micro.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WinMetaRow extends StatelessWidget {
  const _WinMetaRow({
    required this.label,
    required this.value,
    this.isCode = false,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool isCode;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: UiTokens.spacing12),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(bottom: BorderSide(color: colors.border))
            : null,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: appText.caption.copyWith(color: colors.textSecondary),
            ),
          ),
          const SizedBox(width: UiTokens.spacing12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: appText.caption.copyWith(
                color: isCode ? colors.infoForeground : colors.heroStart,
                fontWeight: FontWeight.w700,
                letterSpacing: isCode ? 1.4 : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
