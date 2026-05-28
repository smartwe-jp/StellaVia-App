import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_booking_payment_section.dart';
import 'hotel_booking_section_card.dart';

class HotelPaymentOrderSummaryCard extends StatelessWidget {
  const HotelPaymentOrderSummaryCard({
    super.key,
    required this.orderId,
    required this.amount,
    required this.presenter,
  });

  final String orderId;
  final num amount;
  final HotelBookingPresenter presenter;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return HotelBookingSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${context.l10n.hotelPaymentOrderIdLabel}: $orderId',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${context.l10n.hotelBookingResultPaymentAmount}: ${presenter.price(amount)} ${context.l10n.hotelCurrencyCode}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class HotelPaymentCreditCardSection extends StatelessWidget {
  const HotelPaymentCreditCardSection({
    super.key,
    required this.cards,
    required this.selectedCard,
    required this.isLoading,
    required this.onCardChanged,
    required this.onAddCard,
  });

  final List<HotelCreditCard> cards;
  final HotelCreditCard? selectedCard;
  final bool isLoading;
  final ValueChanged<HotelCreditCard?> onCardChanged;
  final VoidCallback onAddCard;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return HotelBookingSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLoading)
            LinearProgressIndicator(
              color: colors.brandSecondary,
              backgroundColor: colors.borderSoft,
            )
          else if (cards.isEmpty)
            _NoCardNotice()
          else
            _CreditCardDropdown(
              cards: cards,
              selectedCard: selectedCard,
              onChanged: onCardChanged,
            ),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              onPressed: onAddCard,
              icon: const Icon(Icons.add_rounded),
              label: Text(context.l10n.hotelPaymentAddCreditCardAndPay),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.brandPrimaryDark,
                side: BorderSide(color: colors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(UiTokens.radius28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditCardDropdown extends StatelessWidget {
  const _CreditCardDropdown({
    required this.cards,
    required this.selectedCard,
    required this.onChanged,
  });

  final List<HotelCreditCard> cards;
  final HotelCreditCard? selectedCard;
  final ValueChanged<HotelCreditCard?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DropdownButtonFormField<String>(
      initialValue: selectedCard?.id,
      isExpanded: true,
      icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiTokens.radius8),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiTokens.radius8),
          borderSide: BorderSide(color: colors.brandPrimaryDark, width: 1.4),
        ),
      ),
      items: cards
          .map((card) {
            return DropdownMenuItem<String>(
              value: card.id,
              child: Text(_cardLabel(context, card)),
            );
          })
          .toList(growable: false),
      onChanged: (id) {
        for (final card in cards) {
          if (card.id == id) {
            onChanged(card);
            return;
          }
        }
        onChanged(null);
      },
    );
  }

  String _cardLabel(BuildContext context, HotelCreditCard card) {
    final number = card.maskedNumber.trim();
    if (number.isNotEmpty) {
      return number;
    }
    return context.l10n.creditCardMaskedCardFallback;
  }
}

class _NoCardNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.warningSubtle,
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        border: Border.all(color: colors.warningBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          context.l10n.hotelPaymentNoCreditCard,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class HotelPaymentBottomBar extends StatelessWidget {
  const HotelPaymentBottomBar({
    super.key,
    required this.onPay,
    required this.isSubmitting,
  });

  final VoidCallback onPay;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.brandPrimaryDark.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: SizedBox(
            width: double.infinity,
            height: 58,
            child: FilledButton(
              onPressed: isSubmitting ? null : onPay,
              style: FilledButton.styleFrom(
                backgroundColor: colors.brandPrimary,
                disabledBackgroundColor: colors.brandPrimary.withValues(
                  alpha: 0.64,
                ),
                foregroundColor: colors.onDark,
                disabledForegroundColor: colors.onDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(UiTokens.radius28),
                ),
              ),
              child: isSubmitting
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: colors.onDark,
                      ),
                    )
                  : Text(
                      context.l10n.hotelBookingResultPay,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.onDark,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

HotelBookingPaymentMethod hotelPaymentMethodFromCode(String code) {
  return switch (code.trim()) {
    '2' => HotelBookingPaymentMethod.wechatPay,
    '3' => HotelBookingPaymentMethod.alipay,
    '4' => HotelBookingPaymentMethod.creditCard,
    _ => HotelBookingPaymentMethod.creditCard,
  };
}
