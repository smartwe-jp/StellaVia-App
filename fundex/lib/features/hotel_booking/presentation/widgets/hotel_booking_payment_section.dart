import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import 'hotel_booking_section_card.dart';

enum HotelBookingPaymentMethod { creditCard, accountBalance, alipay, wechatPay }

class HotelBookingPaymentSection extends StatelessWidget {
  const HotelBookingPaymentSection({
    super.key,
    required this.selected,
    required this.registeredCardCount,
    required this.accountBalance,
    required this.isAccountBalanceLoading,
    required this.payableAmount,
    required this.onChanged,
  });

  final HotelBookingPaymentMethod selected;
  final int registeredCardCount;
  final num? accountBalance;
  final bool isAccountBalanceLoading;
  final num payableAmount;
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
            value: HotelBookingPaymentMethod.accountBalance,
            selected: selected,
            title: context.l10n.hotelBookingAccountBalancePay,
            subtitle: isAccountBalanceLoading
                ? context.l10n.hotelBookingAccountBalanceLoading
                : context.l10n.hotelBookingAccountBalanceAvailable(
                    accountBalance ?? 0,
                  ),
            isEnabled:
                isAccountBalanceLoading ||
                (accountBalance ?? 0) >= payableAmount,
            onChanged: onChanged,
          ),
          _PaymentTile(
            value: HotelBookingPaymentMethod.alipay,
            selected: selected,
            title: context.l10n.hotelBookingAlipay,
            onChanged: onChanged,
            isVisible: false,
          ),
          _PaymentTile(
            value: HotelBookingPaymentMethod.wechatPay,
            selected: selected,
            title: context.l10n.hotelBookingWechatPay,
            onChanged: onChanged,
            isVisible: false,
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
    this.isVisible = true,
    this.isEnabled = true,
  });

  final HotelBookingPaymentMethod value;
  final HotelBookingPaymentMethod selected;
  final String title;
  final String? subtitle;
  final bool isVisible;
  final bool isEnabled;
  final ValueChanged<HotelBookingPaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }
    final colors = Theme.of(context).appColors;
    final isSelected = selected == value;
    return InkWell(
      onTap: isEnabled ? () => onChanged(value) : null,
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
                      color: isEnabled
                          ? colors.textPrimary
                          : colors.textTertiary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isEnabled
                            ? colors.textSecondary
                            : colors.textTertiary,
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
          color: isSelected ? colors.primary : colors.border,
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
              color: colors.infoForeground,
            ),
          ),
        ),
      ),
    );
  }
}
