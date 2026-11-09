import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_booking_section_card.dart';
import 'hotel_detail_image_placeholder.dart';

class HotelBookingOrderSummaryCard extends StatelessWidget {
  const HotelBookingOrderSummaryCard({
    super.key,
    required this.seed,
    required this.presenter,
    required this.amount,
    required this.originalAmount,
    required this.selectedCoupon,
    required this.onEdit,
    this.selectedFundBenefitTicket,
    this.showOriginalAmount = false,
  });

  final HotelBookingConfirmSeed seed;
  final HotelBookingPresenter presenter;
  final num? amount;
  final num? originalAmount;
  final HotelCoupon? selectedCoupon;
  final VoidCallback onEdit;
  final HotelFundBenefitTicket? selectedFundBenefitTicket;
  final bool showOriginalAmount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final imageUrl = seed.detail.images.isEmpty
        ? ''
        : seed.detail.images.first.url;
    final shouldShowOriginalPrice =
        (selectedCoupon != null || showOriginalAmount) &&
        originalAmount != null &&
        amount != null &&
        originalAmount! > amount!;
    final couponBadgeText = _couponBadgeText(
      context,
      selectedCoupon,
      selectedFundBenefitTicket,
    );
    return HotelBookingSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _DateBlock(
                  label: context.l10n.hotelBookingCheckInDate,
                  value: _wireDate(seed.criteria.checkInDate),
                ),
              ),
              SizedBox(
                width: 1,
                height: 50,
                child: ColoredBox(color: colors.borderSoft),
              ),
              Expanded(
                child: _DateBlock(
                  label: context.l10n.hotelBookingCheckOutDate,
                  value: _wireDate(seed.criteria.checkOutDate),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: colors.borderSoft),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(UiTokens.radius8),
                child: SizedBox(
                  width: 104,
                  height: 104,
                  child: AppRemoteImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: const HotelDetailImagePlaceholder(),
                    errorWidget: const HotelDetailImagePlaceholder(),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.primaryAlt.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(UiTokens.radius8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Text(
                          context.l10n.hotelBookingOfficialBooking,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: colors.infoForeground,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      seed.detail.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      seed.detail.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Divider(color: colors.borderSoft),
          const SizedBox(height: 18),
          Text(
            context.l10n.hotelBookingSelectedRooms,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          ...seed.selectedRooms.map(
            (selection) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      selection.room.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '* ${selection.quantity}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: onEdit,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 40),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                context.l10n.hotelBookingEditContent,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colors.warningForeground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Divider(color: colors.borderSoft),
          const SizedBox(height: 18),
          Text(
            context.l10n.hotelDetailPayableAmount,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                context.l10n.hotelSearchNights(seed.criteria.nights),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    if (couponBadgeText != null) ...<Widget>[
                      _CouponSummaryBadge(label: couponBadgeText),
                      const SizedBox(height: 8),
                    ],
                    Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      spacing: 8,
                      runSpacing: 4,
                      children: <Widget>[
                        if (shouldShowOriginalPrice)
                          Text(
                            _priceWithCurrencyCode(context, originalAmount),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: colors.textTertiary,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: colors.textTertiary,
                                ),
                          ),
                        Text(
                          _priceWithCurrencyCode(context, amount),
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: colors.brandAlert,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _wireDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  String? _couponBadgeText(
    BuildContext context,
    HotelCoupon? coupon,
    HotelFundBenefitTicket? fundBenefitTicket,
  ) {
    if (fundBenefitTicket != null) {
      final amount = fundBenefitTicket.benefitAmount;
      return amount == null
          ? context.l10n.hotelStayBenefitTicketConfirmTitle
          : '宿泊特典・${_formatNumber(amount)}円';
    }
    if (coupon == null || coupon.type == 2) {
      return null;
    }
    if (coupon.type == 3 && coupon.discount != null && coupon.discount! > 0) {
      return context.l10n.hotelDetailDiscount(_formatNumber(coupon.discount!));
    }
    final amountText = coupon.amountEvery.isNotEmpty
        ? coupon.amountEvery
        : _formatNullableNumber(coupon.amount);
    return amountText == null || amountText.isEmpty ? null : '$amountText JPY';
  }

  String _priceWithCurrencyCode(BuildContext context, num? value) {
    final priceText = presenter.price(value);
    return priceText.isEmpty
        ? priceText
        : '$priceText ${context.l10n.hotelCurrencyCode}';
  }

  String _formatNumber(num value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  String? _formatNullableNumber(num? value) {
    return value == null ? null : _formatNumber(value);
  }
}

class _CouponSummaryBadge extends StatelessWidget {
  const _CouponSummaryBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.warningSubtle,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.confirmation_number_rounded,
              size: 16,
              color: colors.warningForeground,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colors.warningForeground,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateBlock extends StatelessWidget {
  const _DateBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
