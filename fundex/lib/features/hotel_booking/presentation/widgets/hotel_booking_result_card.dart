import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_booking_payment_section.dart';

class HotelBookingResultHero extends StatelessWidget {
  const HotelBookingResultHero({
    super.key,
    required this.title,
    required this.onClose,
  });

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandPrimaryDark,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(34)),
      ),
      child: SizedBox(
        height: 166,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 12,
              right: 12,
              child: _HeroCloseButton(onTap: onClose),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    DecoratedBox(
                      decoration: ShapeDecoration(
                        color: colors.onDark.withValues(alpha: 0.16),
                        shape: CircleBorder(
                          side: BorderSide(
                            color: colors.onDark.withValues(alpha: 0.20),
                          ),
                        ),
                      ),
                      child: SizedBox.square(
                        dimension: 74,
                        child: Center(
                          child: Text(
                            '!',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  color: colors.highlightGold,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: colors.onDark,
                            fontWeight: FontWeight.w800,
                            height: 1.16,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCloseButton extends StatelessWidget {
  const _HeroCloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Material(
      color: colors.onDark.withValues(alpha: 0.14),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        padding: EdgeInsets.zero,
        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        onPressed: onTap,
        icon: Icon(Icons.close_rounded, color: colors.onDark),
      ),
    );
  }
}

class HotelBookingResultCard extends StatelessWidget {
  const HotelBookingResultCard({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.paymentMethod,
    required this.presenter,
  });

  final String orderId;
  final num totalAmount;
  final HotelBookingPaymentMethod paymentMethod;
  final HotelBookingPresenter presenter;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Material(
      color: colors.brandWhite,
      elevation: 2,
      shadowColor: colors.brandPrimaryDark.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(UiTokens.radius28),
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UiTokens.radius28),
          border: Border.all(color: colors.borderSoft),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
          child: Column(
            children: <Widget>[
              _ResultLine(
                label: context.l10n.hotelBookingResultOrderNumber,
                value: orderId,
              ),
              _ResultDivider(color: colors.borderSoft),
              _ResultLine(
                label: context.l10n.hotelBookingResultPaymentMethod,
                value: _paymentMethodLabel(context, paymentMethod),
              ),
              _ResultDivider(color: colors.borderSoft),
              _ResultLine(
                label: context.l10n.hotelBookingResultPaymentAmount,
                value:
                    '${presenter.price(totalAmount)} ${context.l10n.hotelCurrencyCode}',
                valueColor: colors.brandAlert,
                emphasized: true,
              ),
              _ResultDivider(color: colors.borderSoft),
              _PaymentDeadlineNotice(),
            ],
          ),
        ),
      ),
    );
  }

  String _paymentMethodLabel(
    BuildContext context,
    HotelBookingPaymentMethod method,
  ) {
    return switch (method) {
      HotelBookingPaymentMethod.creditCard =>
        context.l10n.hotelBookingCreditCardPay,
      HotelBookingPaymentMethod.alipay => context.l10n.hotelBookingAlipay,
      HotelBookingPaymentMethod.wechatPay => context.l10n.hotelBookingWechatPay,
    };
  }
}

class HotelBookingResultActions extends StatelessWidget {
  const HotelBookingResultActions({
    super.key,
    required this.onPay,
    required this.onBackToOrders,
  });

  final VoidCallback onPay;
  final VoidCallback onBackToOrders;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          height: 58,
          child: FilledButton(
            onPressed: onPay,
            style: FilledButton.styleFrom(
              backgroundColor: colors.brandPrimaryDark,
              foregroundColor: colors.onDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiTokens.radius16),
              ),
            ),
            child: Text(
              context.l10n.hotelBookingResultPay,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.onDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: onBackToOrders,
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.brandPrimaryDark,
              side: BorderSide(color: colors.borderSoft),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiTokens.radius16),
              ),
              backgroundColor: colors.surface,
            ),
            child: Text(
              context.l10n.hotelBookingResultBackToOrders,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colors.brandPrimaryDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({
    required this.label,
    required this.value,
    this.valueColor,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text(
            _trimLabel(label),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Flexible(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                (emphasized
                        ? Theme.of(context).textTheme.headlineSmall
                        : Theme.of(context).textTheme.titleMedium)
                    ?.copyWith(
                      color: valueColor ?? colors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
          ),
        ),
      ],
    );
  }

  String _trimLabel(String label) {
    return label.replaceFirst(RegExp(r'[：:]\s*$'), '');
  }
}

class _ResultDivider extends StatelessWidget {
  const _ResultDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Divider(height: 1, thickness: 1, color: color),
    );
  }
}

class _PaymentDeadlineNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.highlightGold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(UiTokens.radius20),
        border: Border.all(color: colors.highlightGold.withValues(alpha: 0.40)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DecoratedBox(
              decoration: ShapeDecoration(
                color: colors.highlightGold,
                shape: const CircleBorder(),
              ),
              child: SizedBox.square(
                dimension: 48,
                child: Center(
                  child: Text(
                    '15',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colors.onDark,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.l10n.hotelBookingResultNoticeTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.brandPrimaryDark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.hotelBookingResultNotice,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w500,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
