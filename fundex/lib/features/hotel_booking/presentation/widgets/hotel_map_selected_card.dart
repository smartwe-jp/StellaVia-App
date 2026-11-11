import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_discount_badge.dart';
import 'hotel_remaining_rooms_label.dart';

class HotelMapSelectedCard extends StatelessWidget {
  const HotelMapSelectedCard({
    super.key,
    required this.hotel,
    required this.presenter,
    required this.onTap,
    this.onDiscountTap,
    this.showStayBenefitUnavailable = false,
  });

  final HotelSummary hotel;
  final HotelBookingPresenter presenter;
  final VoidCallback onTap;
  final VoidCallback? onDiscountTap;
  final bool showStayBenefitUnavailable;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final price = presenter.price(hotel.lowestPrice);
    final oldPrice = _shouldShowOldPrice
        ? presenter.price(hotel.beforeDiscountPrice)
        : '';
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Material(
          color: colors.brandWhite,
          borderRadius: BorderRadius.circular(28),
          elevation: 16,
          shadowColor: colors.brandPrimaryDark.withValues(alpha: 0.16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: IntrinsicHeight(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 146),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: SizedBox(
                              width: 126,
                              height: 126,
                              child: AppRemoteImage(
                                imageUrl: hotel.imageUrl,
                                fit: BoxFit.cover,
                                errorWidget: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: colors.textTertiary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          HotelRemainingRoomsLabel(
                            count: hotel.isBookable
                                ? hotel.remainingRooms ?? -1
                                : 0,
                            unit: hotelRemainingUnitForHotelSummary(
                              buildingCode: hotel.buildingCode,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  hotel.name.isEmpty
                                      ? context.l10n.hotelUnnamedProperty
                                      : hotel.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: colors.brandPrimaryDark,
                                        fontWeight: FontWeight.w900,
                                        height: 1.15,
                                      ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  _locationText(context),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: colors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                HotelDiscountBadge(
                                  name: hotel.discountName,
                                  discount: hotel.discount,
                                  onTap: onDiscountTap,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (oldPrice.isNotEmpty)
                                  Text(
                                    oldPrice,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: colors.textTertiary,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                  ),
                                Text(
                                  price.isEmpty
                                      ? context.l10n.hotelPriceAsk
                                      : '$price${context.l10n.hotelPricePerNight}',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: colors.brandPrimaryDark,
                                        fontWeight: FontWeight.w900,
                                        height: 1.1,
                                      ),
                                ),
                                if (showStayBenefitUnavailable) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    context
                                        .l10n
                                        .hotelStayBenefitStatusDateUnavailable,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: colors.textTertiary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _locationText(BuildContext context) {
    if (hotel.address.isNotEmpty) {
      return hotel.address;
    }
    if (hotel.area.isNotEmpty) {
      return hotel.area;
    }
    return context.l10n.hotelDefaultDestination;
  }

  bool get _shouldShowOldPrice {
    final current = hotel.lowestPrice;
    final before = hotel.beforeDiscountPrice;
    if (current == null || before == null) {
      return false;
    }
    return before > current;
  }
}
