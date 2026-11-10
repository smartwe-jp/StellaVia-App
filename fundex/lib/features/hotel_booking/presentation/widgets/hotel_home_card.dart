import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../support/hotel_reference_miles_display.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_discount_badge.dart';
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
    this.previewImageAsset,
  });
  final HotelSummary hotel;
  final HotelBookingPresenter presenter;
  final VoidCallback? onTap;
  final VoidCallback? onMapTap;
  final VoidCallback? onDiscountTap;
  final int? requiredMiles;
  final bool hostMilesMode;
  final String? previewImageAsset;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;
    final miles =
        requiredMiles ?? (hostMilesMode ? hotel.startingPoints : null);
    final isMiles = hostMilesMode || miles != null;
    final disabled = isMiles && !hotel.stayBenefitParticipate;
    final radius = BorderRadius.circular(20);
    final card = AppCard(
      backgroundColor: colors.surface,
      borderColor: colors.borderSoft,
      borderRadius: radius,
      onTap: disabled ? null : onTap,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 334 / 164,
              child: previewImageAsset != null
                  ? Image.asset(previewImageAsset!, fit: BoxFit.cover)
                  : AppRemoteImage(
                      imageUrl: hotel.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: ColoredBox(
                        color: colors.surfaceAlt,
                        child: Icon(
                          Icons.hotel_outlined,
                          color: colors.textTertiary,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: disabled ? null : onMapTap,
            child: Text(
              hotel.address.isNotEmpty ? hotel.address : hotel.area,
              style: text.labelMedium?.copyWith(color: colors.brandSecondary),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hotel.name.isEmpty ? context.l10n.hotelUnnamedProperty : hotel.name,
            style: HotelHomeTextStyles.hotelName(context),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          if (isMiles)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                hotel.stayBenefitParticipate
                    ? context.l10n.hotelMilesDateEligible
                    : context.l10n.hotelMilesDateIneligible,
                textAlign: TextAlign.right,
                style: text.labelSmall?.copyWith(color: colors.brandSecondary),
              ),
            )
          else
            HotelDiscountBadge(
              name: hotel.discountName,
              discount: hotel.discount,
              onTap: onDiscountTap,
            ),
          const Divider(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              HotelRemainingRoomsLabel(
                color: colors.brandSecondary,
                count: hotel.isBookable ? hotel.remainingRooms ?? 0 : 0,
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
          const SizedBox(height: 8),
        ],
      ),
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
