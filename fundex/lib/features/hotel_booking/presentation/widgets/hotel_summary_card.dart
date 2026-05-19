import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_discount_badge.dart';
import 'hotel_remaining_rooms_label.dart';
import 'hotel_type_badge.dart';

class HotelSummaryCard extends StatelessWidget {
  const HotelSummaryCard({
    super.key,
    required this.hotel,
    required this.presenter,
    this.onTap,
    this.onMapTap,
  });

  final HotelSummary hotel;
  final HotelBookingPresenter presenter;
  final VoidCallback? onTap;
  final VoidCallback? onMapTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final price = presenter.price(hotel.lowestPrice);
    final shouldShowOldPrice = _shouldShowOldPrice;
    final oldPrice = shouldShowOldPrice
        ? presenter.price(hotel.beforeDiscountPrice)
        : '';
    final location = _resolveLocation(context);
    final remainingRooms = hotel.remainingRooms;

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandWhite,
        borderRadius: BorderRadius.circular(UiTokens.radius20),
        border: Border.all(color: colors.borderSoft.withValues(alpha: 0.58)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.brandPrimary.withValues(alpha: 0.10),
            blurRadius: 34,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(UiTokens.radius20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 154,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  AppRemoteImage(
                    imageUrl: hotel.imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: const _HotelImagePlaceholder(
                      icon: Icons.image_not_supported_outlined,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: HotelTypeBadge(label: _resolveTypeLabel()),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    hotel.name.isEmpty
                        ? context.l10n.hotelUnnamedProperty
                        : hotel.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colors.brandPrimaryDark,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 28,
                          height: 20,
                        ),
                        visualDensity: VisualDensity.compact,
                        iconSize: 22,
                        icon: Icon(
                          Icons.location_on_outlined,
                          color: onMapTap == null
                              ? colors.textTertiary
                              : colors.brandSecondary,
                        ),
                        onPressed: onMapTap,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          context.l10n.hotelCardMeta(location, 10),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            HotelDiscountBadge(
                              name: hotel.discountName,
                              discount: hotel.discount,
                            ),
                            if (hotel.discountName.isNotEmpty &&
                                (hotel.discount ?? 0) > 0)
                              const SizedBox(height: 8),
                            HotelRemainingRoomsLabel(
                              count: hotel.isBookable ? remainingRooms ?? 0 : 0,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          if (oldPrice.isNotEmpty)
                            Text(
                              oldPrice,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colors.textTertiary,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                          if (price.isNotEmpty)
                            RichText(
                              text: TextSpan(
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: price,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: colors.brandPrimaryDark,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                  TextSpan(
                                    text: context.l10n.hotelPricePerNight,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: colors.brandPrimaryDark,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Text(
                              context.l10n.hotelPriceAsk,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: colors.brandPrimaryDark,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (onTap == null) {
      return card;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: card,
    );
  }

  String _resolveLocation(BuildContext context) {
    if (hotel.address.isNotEmpty) {
      return hotel.address;
    }
    if (hotel.area.isNotEmpty) {
      return hotel.area;
    }
    return context.l10n.hotelDefaultDestination;
  }

  String _resolveTypeLabel() {
    if (hotel.buildingType.isNotEmpty) {
      return hotel.buildingType;
    }
    return hotel.bookingTypeLabel;
  }

  bool get _shouldShowOldPrice {
    final current = hotel.lowestPrice;
    final original = hotel.beforeDiscountPrice;
    if (current == null || original == null) {
      return false;
    }
    return original > current;
  }
}

class _HotelImagePlaceholder extends StatelessWidget {
  const _HotelImagePlaceholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.surface),
      child: Center(child: Icon(icon, color: colors.textTertiary, size: 32)),
    );
  }
}
