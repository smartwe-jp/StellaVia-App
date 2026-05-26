import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_booking_payment_section.dart';
import 'hotel_booking_section_card.dart';

class HotelBookingResultCard extends StatelessWidget {
  const HotelBookingResultCard({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.paymentMethod,
    required this.presenter,
    required this.onBackToOrders,
    required this.onPay,
  });

  final String orderId;
  final num totalAmount;
  final HotelBookingPaymentMethod paymentMethod;
  final HotelBookingPresenter presenter;
  final VoidCallback onBackToOrders;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return HotelBookingSectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          _ResultLine(
            label: context.l10n.hotelBookingResultOrderNumber,
            value: orderId,
          ),
          const SizedBox(height: 14),
          _ResultLine(
            label: context.l10n.hotelBookingResultPaymentMethod,
            value: _paymentMethodLabel(context, paymentMethod),
          ),
          const SizedBox(height: 14),
          _ResultLine(
            label: context.l10n.hotelBookingResultPaymentAmount,
            value:
                '${presenter.price(totalAmount)}${context.l10n.hotelCurrencyCode}',
            valueColor: colors.brandAlert,
          ),
          const SizedBox(height: 24),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.warningSubtle,
              borderRadius: BorderRadius.circular(UiTokens.radius8),
              border: Border.all(
                color: colors.warningForeground.withValues(alpha: 0.24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                context.l10n.hotelBookingResultNotice,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w700,
                  height: 1.45,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: onBackToOrders,
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.textTertiary,
                      foregroundColor: colors.onDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(UiTokens.radius8),
                      ),
                    ),
                    child: Text(
                      context.l10n.hotelBookingResultBackToOrders,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.onDark,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: onPay,
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.highlightGold,
                      foregroundColor: colors.onDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(UiTokens.radius8),
                      ),
                    ),
                    child: Text(
                      context.l10n.hotelBookingResultPay,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.onDark,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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

class _ResultLine extends StatelessWidget {
  const _ResultLine({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: valueColor ?? colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
