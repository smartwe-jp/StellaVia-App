import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import 'hotel_booking_section_card.dart';

enum HotelBookingPaymentMethod { creditCard, alipay, wechatPay }

class HotelBookingPaymentSection extends StatelessWidget {
  const HotelBookingPaymentSection({
    super.key,
    required this.selected,
    required this.registeredCardCount,
    required this.onChanged,
  });

  final HotelBookingPaymentMethod selected;
  final int registeredCardCount;
  final ValueChanged<HotelBookingPaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return HotelBookingSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.hotelBookingPaymentTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          _PaymentTile(
            value: HotelBookingPaymentMethod.creditCard,
            selected: selected,
            title: context.l10n.hotelBookingCreditCardPay,
            subtitle: registeredCardCount > 0
                ? context.l10n.hotelBookingRegisteredCards(registeredCardCount)
                : context.l10n.hotelBookingAddCreditCard,
            onChanged: onChanged,
          ),
          _PaymentTile(
            value: HotelBookingPaymentMethod.alipay,
            selected: selected,
            title: context.l10n.hotelBookingAlipay,
            onChanged: onChanged,
          ),
          _PaymentTile(
            value: HotelBookingPaymentMethod.wechatPay,
            selected: selected,
            title: context.l10n.hotelBookingWechatPay,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.value,
    required this.selected,
    required this.title,
    required this.onChanged,
    this.subtitle,
  });

  final HotelBookingPaymentMethod value;
  final HotelBookingPaymentMethod selected;
  final String title;
  final String? subtitle;
  final ValueChanged<HotelBookingPaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final isSelected = selected == value;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(UiTokens.radius8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            _PaymentIndicator(isSelected: isSelected),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentIndicator extends StatelessWidget {
  const _PaymentIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? colors.highlightGold : colors.border,
          width: 3,
        ),
      ),
      child: SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            width: isSelected ? 10 : 0,
            height: isSelected ? 10 : 0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.highlightGold,
            ),
          ),
        ),
      ),
    );
  }
}
