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
    required this.couponsAvailableCount,
    required this.onEdit,
  });

  final HotelBookingConfirmSeed seed;
  final HotelBookingPresenter presenter;
  final num? amount;
  final int couponsAvailableCount;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final imageUrl = seed.detail.images.isEmpty
        ? ''
        : seed.detail.images.first.url;
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
                        color: colors.highlightGold.withValues(alpha: 0.22),
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
                                color: colors.highlightGold,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      context.l10n.hotelBookingSelectedRooms,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...seed.selectedRooms.map(
                      (selection) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '${selection.room.name}  * ${selection.quantity}',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onEdit,
                      child: Text(context.l10n.hotelBookingEditContent, style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colors.warningForeground,
                        fontWeight: FontWeight.w600,
                      )),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  if (couponsAvailableCount > 0)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.warningSubtle,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Text(
                          context.l10n.hotelBookingCouponOff,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: colors.warningForeground,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    presenter.price(amount),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colors.brandAlert,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
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
