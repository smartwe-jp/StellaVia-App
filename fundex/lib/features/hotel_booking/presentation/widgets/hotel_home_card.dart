import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
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
    final codeLabel = hotelBuildingTypeLabelForCode(
      context,
      hotel.buildingCode,
    );
    final type = codeLabel.isNotEmpty
        ? codeLabel
        : hotel.buildingType.isNotEmpty
        ? hotel.buildingType
        : hotel.bookingTypeLabel;
    final miles = requiredMiles;
    final isMiles = hostMilesMode || miles != null;
    return AppCard(
      backgroundColor: colors.surface,
      borderColor: colors.borderSoft,
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 334 / 164,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (previewImageAsset != null)
                    Image.asset(previewImageAsset!, fit: BoxFit.cover)
                  else
                    AppRemoteImage(
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
                  if (type.isNotEmpty)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          type,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.labelSmall?.copyWith(
                            color: colors.onDark,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: onMapTap,
            child: Text(
              hotel.address.isNotEmpty ? hotel.address : hotel.area,
              style: text.labelSmall?.copyWith(color: colors.brandSecondary),
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
            Text(
              hotel.stayBenefitParticipate
                  ? context.l10n.hotelMilesDateEligible
                  : context.l10n.hotelStayBenefitUnavailableForDate,
              style: text.labelSmall?.copyWith(color: colors.brandSecondary),
            )
          else
            HotelDiscountBadge(
              name: hotel.discountName,
              discount: hotel.discount,
              onTap: onDiscountTap,
            ),
          const Divider(height: 12),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              HotelRemainingRoomsLabel(
                color: colors.brandSecondary,
                count: hotel.isBookable ? hotel.remainingRooms ?? 0 : 0,
                unit: hotelRemainingUnitForHotelSummary(
                  buildingCode: hotel.buildingCode,
                ),
              ),
              Column(
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
                              : context.l10n.hotelMilesPerNight(miles)
                        : hotel.lowestPrice == null
                        ? context.l10n.hotelPriceAsk
                        : '${presenter.price(hotel.lowestPrice)}${context.l10n.hotelPricePerNight}',
                    style: HotelHomeTextStyles.sectionTitle(context),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
