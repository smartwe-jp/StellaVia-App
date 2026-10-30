import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
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
    required this.onDetails,
    required this.onMinus,
    required this.onPlus,
  });
  final HotelRoomPlan room;
  final int quantity;
  final int nights;
  final bool miles;
  final VoidCallback onDetails;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  @override
  Widget build(BuildContext c) {
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(c).toLanguageTag(),
    );
    final minimum = room.minimumStayNights;
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
                height: 238,
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
                                    style: HotelDetailStyles.spec(c),
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              miles
                                  ? c.l10n.hotelDetailMilesQuoteAfterSelection
                                  : (room.price == null
                                        ? '—'
                                        : presenter.price(room.price)),
                              style: miles
                                  ? HotelDetailStyles.caption(c)
                                  : HotelDetailStyles.amount(c),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              c.l10n.hotelDetailPerStay(nights),
                              style: HotelDetailStyles.spec(c),
                            ),
                          ],
                        ),
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
                          style: HotelDetailStyles.label(c),
                        ),
                      ),
                      _QuantityButton(
                        asset: 'plus',
                        tooltip: c.l10n.hotelDetailIncreaseRoom,
                        onPressed: onPlus,
                      ),
                    ],
                  ),
                  if (room.remainingRooms != null &&
                      room.remainingRooms! >= 0) ...[
                    const SizedBox(height: 12),
                    Text(
                      c.l10n.hotelDetailRemainingRoomsShort(
                        room.remainingRooms!,
                      ),
                      style: HotelDetailStyles.spec(c),
                    ),
                  ],
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
