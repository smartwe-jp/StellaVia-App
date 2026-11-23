import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../support/hotel_reference_miles_display.dart';
import '../support/hotel_miles_display.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_discount_badge.dart';
import 'hotel_property_card.dart';
import 'hotel_remaining_rooms_label.dart';
import '../support/hotel_home_text_styles.dart';

/// Home-only composition; legacy detail/map/stay-benefit cards remain intact.
class HotelHomeCard extends StatelessWidget {
  const HotelHomeCard({
    super.key,
    required this.hotel,
    required this.presenter,
    this.onTap,
    this.onMapTap,
    this.onDiscountTap,
    this.requiredMiles,
    this.hostMilesMode = false,
    this.memberRoomLimit,
    this.previewImageAsset,
  });
  final HotelSummary hotel;
  final HotelBookingPresenter presenter;
  final VoidCallback? onTap;
  final VoidCallback? onMapTap;
  final VoidCallback? onDiscountTap;
  final int? requiredMiles;
  final bool hostMilesMode;
  final int? memberRoomLimit;
  final String? previewImageAsset;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;
    final miles =
        requiredMiles ?? (hostMilesMode ? hotel.startingPoints : null);
    final isMiles = hostMilesMode || miles != null;
    final disabled = isMiles && !hotel.stayBenefitParticipate;
    final stock = hotel.isBookable ? hotel.remainingRooms : 0;
    final count = isMiles
        ? milesBookableRoomCount(stock, memberRoomLimit)
        : stock;
    final radius = BorderRadius.circular(20);
    final card = HotelPropertyCard(
      name: hotel.name,
      location: hotel.address.isNotEmpty ? hotel.address : hotel.area,
      imageUrl: hotel.imageUrl,
      previewImageAsset: previewImageAsset,
      onTap: disabled ? null : onTap,
      onMapTap: disabled ? null : onMapTap,
      details: [
        if (disabled) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              context.l10n.hotelMilesDateIneligible,
              textAlign: TextAlign.right,
              style: text.labelSmall?.copyWith(color: colors.textSecondary),
            ),
          ),
        ] else if (!isMiles) ...[
          const SizedBox(height: 10),
          HotelDiscountBadge(
            name: hotel.discountName,
            discount: hotel.discount,
            onTap: onDiscountTap,
          ),
        ],
        const Divider(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            HotelRemainingRoomsLabel(
              count: count ?? -1,
              textColor: isMiles ? colors.textPrimary : null,
              showFullBadge: stock == 0 || !isMiles,
              unit: hotelRemainingUnitForHotelSummary(
                buildingCode: hotel.buildingCode,
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isMiles &&
                      hotel.lowestPrice != null &&
                      (hotel.beforeDiscountPrice ?? 0) > hotel.lowestPrice!)
                    Text(
                      presenter.price(hotel.beforeDiscountPrice),
                      style: text.labelSmall?.copyWith(
                        color: colors.textTertiary,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    isMiles
                        ? miles == null
                              ? context.l10n.hotelMilesRequiredUnknown
                              : hotelReferenceMilesLabel(
                                  context,
                                  miles,
                                  starting: true,
                                )
                        : hotel.lowestPrice == null
                        ? context.l10n.hotelPriceAsk
                        : '${presenter.price(hotel.lowestPrice)}${context.l10n.hotelPricePerNight}',
                    style: HotelHomeTextStyles.sectionTitle(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
    if (!disabled) return card;
    return Semantics(
      enabled: false,
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          color: colors.surface.withValues(alpha: 0.32),
          borderRadius: radius,
        ),
        child: card,
      ),
    );
  }
}
