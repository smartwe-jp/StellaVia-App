import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';

class HotelSummaryCard extends StatelessWidget {
  const HotelSummaryCard({
    super.key,
    required this.hotel,
    required this.presenter,
    this.onTap,
  });

  final HotelSummary hotel;
  final HotelBookingPresenter presenter;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final price = presenter.price(hotel.lowestPrice);
    final oldPrice = presenter.price(hotel.beforeDiscountPrice);
    final location = _resolveLocation(context);

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
              child: AppRemoteImage(
                imageUrl: hotel.imageUrl,
                fit: BoxFit.cover,
                errorWidget: const _HotelImagePlaceholder(
                  icon: Icons.image_not_supported_outlined,
                ),
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
                  Text(
                    context.l10n.hotelCardMeta(location, 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: _resolveTags(context)
                        .map(
                          (tag) => DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.highlightGold.withValues(
                                alpha: 0.14,
                              ),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              child: Text(
                                tag,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: colors.highlightGold,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text(
                              hotel.isBookable
                                  ? context.l10n.hotelRemainingRooms(2)
                                  : context.l10n.hotelUnavailable,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: colors.brandSecondary,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (price.isNotEmpty)
                        RichText(
                          text: TextSpan(
                            children: <InlineSpan>[
                              TextSpan(
                                text: price,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      color: colors.brandPrimaryDark,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                              TextSpan(
                                text: context.l10n.hotelPricePerNight,
                                style: Theme.of(context).textTheme.labelMedium
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

  List<String> _resolveTags(BuildContext context) {
    final tags = <String>[
      if (hotel.buildingType.isNotEmpty) hotel.buildingType,
      ...hotel.tags,
      if (hotel.discountName.isNotEmpty) hotel.discountName,
    ];
    if (tags.isEmpty) {
      return <String>[
        context.l10n.hotelFilterAllTypes,
        context.l10n.hotelSortRecommended,
      ];
    }
    return tags.take(3).toList(growable: false);
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
