import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import 'hotel_booking_section_card.dart';

class HotelBookingCouponRow extends StatelessWidget {
  const HotelBookingCouponRow({
    super.key,
    required this.availableCount,
    required this.onTap,
  });

  final int availableCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return HotelBookingSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                context.l10n.hotelBookingCoupons,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Text(
              availableCount > 0
                  ? context.l10n.hotelBookingCouponsAvailable(availableCount)
                  : context.l10n.hotelBookingNoCoupons,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.textTertiary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded, color: colors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class HotelBookingInvoiceSection extends StatelessWidget {
  const HotelBookingInvoiceSection({
    super.key,
    required this.controller,
    required this.useGuestName,
    required this.onUseGuestNameChanged,
  });

  final TextEditingController controller;
  final bool useGuestName;
  final ValueChanged<bool> onUseGuestNameChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return HotelBookingSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.hotelBookingInvoice,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: useGuestName,
            activeColor: colors.brandPrimary,
            onChanged: (value) => onUseGuestNameChanged(value ?? false),
            title: Text(
              context.l10n.hotelBookingUseGuestName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          HotelBookingTextField(
            controller: controller,
            hintText: context.l10n.hotelBookingInvoiceTitle,
          ),
        ],
      ),
    );
  }
}

class HotelBookingMessageSection extends StatelessWidget {
  const HotelBookingMessageSection({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return HotelBookingSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.hotelBookingMessageTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.hotelBookingMessageHint,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          HotelBookingTextField(controller: controller, maxLines: 4),
        ],
      ),
    );
  }
}

class HotelBookingConfirmBottomBar extends StatelessWidget {
  const HotelBookingConfirmBottomBar({
    super.key,
    required this.amount,
    required this.amountLabel,
    required this.onConfirm,
  });

  final String amount;
  final String amountLabel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandWhite,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.brandPrimaryDark.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      amountLabel,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      amount,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: colors.brandAlert,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 150,
                height: 54,
                child: FilledButton(
                  onPressed: onConfirm,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.brandPrimary,
                    foregroundColor: colors.onDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(UiTokens.radius16),
                    ),
                  ),
                  child: Text(
                    context.l10n.hotelBookingConfirmAction,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.onDark,
                      fontWeight: FontWeight.w900,
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
