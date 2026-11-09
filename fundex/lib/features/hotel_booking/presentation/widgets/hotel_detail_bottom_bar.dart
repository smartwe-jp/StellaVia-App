import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../support/hotel_booking_presenter.dart';

class HotelDetailBottomBar extends StatelessWidget {
  const HotelDetailBottomBar({
    super.key,
    required this.amount,
    required this.nights,
    required this.rooms,
    required this.presenter,
    this.isLoading = false,
    this.useStayBenefitAccent = false,
    String? buttonLabel,
    required this.onBookNow,
  }) : buttonLabel = buttonLabel ?? '';

  final num? amount;
  final int nights;
  final int rooms;
  final HotelBookingPresenter presenter;
  final bool isLoading;
  final bool useStayBenefitAccent;
  final String buttonLabel;
  final VoidCallback onBookNow;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final amountText = presenter.amount(amount);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandWhite,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.brandPrimaryDark.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 18, 0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      context.l10n.hotelDetailPayableAmount,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _BottomBarAmountText(
                      amountText: amountText,
                      presenter: presenter,
                      useStayBenefitAccent: useStayBenefitAccent,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.hotelDetailTaxNote(nights, rooms),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              SizedBox(
                width: 150,
                height: 58,
                child: FilledButton(
                  onPressed: isLoading ? null : onBookNow,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(UiTokens.radius16),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: colors.onDark,
                          ),
                        )
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            buttonLabel.isEmpty
                                ? context.l10n.hotelDetailBookNow
                                : buttonLabel,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: colors.onDark,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBarAmountText extends StatelessWidget {
  const _BottomBarAmountText({
    required this.amountText,
    required this.presenter,
    required this.useStayBenefitAccent,
  });

  final String amountText;
  final HotelBookingPresenter presenter;
  final bool useStayBenefitAccent;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final baseStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: colors.brandAlert,
      fontWeight: FontWeight.w900,
      height: 1,
    );
    if (amountText.isEmpty) {
      return Text(
        context.l10n.hotelPriceAsk,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: baseStyle,
      );
    }
    final currencyCode = context.l10n.hotelCurrencyCode;
    if (!useStayBenefitAccent) {
      return Text(
        '¥ $amountText $currencyCode',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: baseStyle,
      );
    }
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: '¥ ',
            style: baseStyle?.copyWith(color: colors.textTertiary),
          ),
          TextSpan(
            text: amountText,
            style: baseStyle?.copyWith(
              color: colors.textTertiary,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const TextSpan(text: '  '),
          TextSpan(
            text: presenter.amount(0),
            style: baseStyle?.copyWith(color: colors.textPrimary),
          ),
          TextSpan(
            text: ' $currencyCode',
            style: baseStyle?.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
