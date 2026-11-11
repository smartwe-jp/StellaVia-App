import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../support/hotel_reference_miles_display.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_detail_display.dart';
import '../support/hotel_detail_styles.dart';
import 'hotel_detail_image_placeholder.dart';

class HotelDetailRoomCard extends StatelessWidget {
  const HotelDetailRoomCard({
    super.key,
    required this.room,
    required this.quantity,
    required this.nights,
    required this.miles,
    this.remaining,
    this.allowanceExhausted = false,
    this.shortfall,
    this.extraGuests,
    required this.onDetails,
    required this.onMinus,
    required this.onPlus,
  });
  final HotelRoomPlan room;
  final int quantity;
  final int nights;
  final bool miles;
  final int? remaining;
  final bool allowanceExhausted;
  final num? shortfall;
  final HotelRoomTypeExtraGuestPrice? extraGuests;
  final VoidCallback onDetails;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  @override
  Widget build(BuildContext c) {
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(c).toLanguageTag(),
    );
    final minimum = room.minimumStayNights;
    final left = remaining ?? room.remainingRooms;
    final String? availability;
    if (miles && room.remainingRooms == 0) {
      availability = c.l10n.hotelDetailNoVacancy;
    } else if (miles && allowanceExhausted) {
      availability = c.l10n.hotelDetailRoomAllowanceUsed;
    } else if (left != null && left >= 0) {
      availability = c.l10n.hotelDetailRemainingRoomsShort(left);
    } else {
      availability = null;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: c.appColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: quantity > 0 ? c.appColors.primary : c.appColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: onDetails,
              child: SizedBox(
                height: 143,
                child: AppRemoteImage(
                  imageUrl: room.images.isEmpty ? '' : room.images.first.url,
                  fit: BoxFit.cover,
                  placeholder: const HotelDetailImagePlaceholder(),
                  errorWidget: const HotelDetailImagePlaceholder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name.isEmpty ? c.l10n.hotelUnnamedProperty : room.name,
                    style: HotelDetailStyles.label(c),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final fact in hotelDetailRoomFacts(c, room))
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: HotelDetailStyles.chipBorder(c),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/hotel-detail-${fact.$1}.svg',
                                  width: 12,
                                  height: 12,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    fact.$2,
                                    style: HotelDetailStyles.caption(
                                      c,
                                    ).copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onDetails,
                      style: TextButton.styleFrom(
                        minimumSize: const Size(48, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(c.l10n.hotelRoomDescriptionTitle),
                          const SizedBox(width: 8),
                          RotatedBox(
                            quarterTurns: 3,
                            child: SvgPicture.asset(
                              'assets/images/hotel-detail-chevron.svg',
                              width: 9.5,
                              height: 5.81066,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: c.appColors.borderSoft, height: 1),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        miles
                            ? (room.pointsRequired == null
                                  ? c.l10n.hotelStayBenefitUnavailableForDate
                                  : hotelReferenceMilesLabel(
                                      c,
                                      room.pointsRequired!,
                                    ))
                            : (room.price == null
                                  ? '—'
                                  : presenter.price(room.price)),
                        style: HotelDetailStyles.roomPrice(c),
                      ),
                      Text(
                        c.l10n.hotelDetailPerStay(nights),
                        style: HotelDetailStyles.roomMetadata(c),
                      ),
                    ],
                  ),
                  if (extraGuests case final row?
                      when miles && quantity > 0) ...[
                    const SizedBox(height: 6),
                    Text(
                      row.extraGuestPoints == null
                          ? c.l10n.hotelRoomExtraGuests(row.extraGuestCount)
                          : c.l10n.hotelRoomExtraGuestsMiles(
                              row.extraGuestCount,
                              presenter.amount(row.extraGuestPoints!),
                            ),
                      style: HotelDetailStyles.roomMetadata(
                        c,
                      ).copyWith(color: c.appColors.primary),
                    ),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: availability != null
                            ? Text(
                                availability,
                                style: HotelDetailStyles.roomMetadata(c),
                              )
                            : const SizedBox.shrink(),
                      ),
                      _QuantityButton(
                        asset: 'minus',
                        tooltip: c.l10n.hotelDetailDecreaseRoom,
                        onPressed: onMinus,
                      ),
                      SizedBox(
                        width: 32,
                        child: Text(
                          '$quantity',
                          textAlign: TextAlign.center,
                          style: HotelDetailStyles.heading(c),
                        ),
                      ),
                      _QuantityButton(
                        asset: 'plus',
                        tooltip: c.l10n.hotelDetailIncreaseRoom,
                        onPressed: onPlus,
                      ),
                    ],
                  ),
                  if ((shortfall ?? 0) > 0 && left != 0)
                    Text(
                      c.l10n.hotelDetailMilesShortfall(
                        presenter.amount(shortfall!),
                      ),
                      style: HotelDetailStyles.caption(c),
                    ),
                  if (minimum != null && minimum > nights) ...[
                    const SizedBox(height: 8),
                    Text(
                      c.l10n.hotelDetailMinimumStay(minimum),
                      style: HotelDetailStyles.caption(c),
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

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.asset,
    required this.tooltip,
    this.onPressed,
  });
  final String asset;
  final String tooltip;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext c) => SizedBox(
    width: 44,
    height: 44,
    child: Center(
      child: SizedBox.square(
        dimension: 36,
        child: IconButton(
          tooltip: tooltip,
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          style: IconButton.styleFrom(
            side: BorderSide(color: c.appColors.border),
            shape: const CircleBorder(),
          ),
          icon: Opacity(
            opacity: onPressed == null ? .3 : 1,
            child: SvgPicture.asset(
              'assets/images/hotel-detail-$asset.svg',
              colorFilter: ColorFilter.mode(
                c.appColors.textPrimary,
                BlendMode.srcIn,
              ),
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    ),
  );
}
