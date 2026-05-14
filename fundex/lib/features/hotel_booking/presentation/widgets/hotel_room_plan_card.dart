import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_detail_image_placeholder.dart';

class HotelRoomPlanCard extends StatelessWidget {
  const HotelRoomPlanCard({
    super.key,
    required this.room,
    required this.presenter,
    required this.quantity,
    required this.nights,
    required this.onDecrement,
    required this.onIncrement,
  });

  final HotelRoomPlan room;
  final HotelBookingPresenter presenter;
  final int quantity;
  final int nights;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final price = presenter.price(room.price);
    final oldPrice = presenter.price(room.beforeDiscountPrice);
    final imageUrl = room.images.isEmpty ? '' : room.images.first.url;
    final facts = _roomFacts(context);
    final discountLabel = _discountLabel(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.highlightGold.withValues(alpha: 0.42)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.brandPrimaryDark.withValues(alpha: 0.08),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 116,
                    height: 116,
                    child: AppRemoteImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: const HotelDetailImagePlaceholder(),
                      errorWidget: const HotelDetailImagePlaceholder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        room.name.isEmpty
                            ? context.l10n.hotelUnnamedProperty
                            : room.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: colors.brandPrimaryDark,
                              fontWeight: FontWeight.w900,
                              height: 1.12,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: facts
                            .map(
                              (fact) => _RoomFactChip(
                                icon: fact.icon,
                                label: fact.label,
                              ),
                            )
                            .toList(growable: false),
                      ),
                      if (discountLabel.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 12),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.brandAlert.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Text(
                              discountLabel,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: colors.brandAlert,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (room.beds.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: room.beds
                    .where((bed) => bed.name.isNotEmpty)
                    .map(
                      (bed) => Text(
                        context.l10n.hotelDetailBedSummary(
                          bed.name,
                          bed.quantity ?? 1,
                          bed.width,
                        ),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ],
            const SizedBox(height: 16),
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
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: colors.textTertiary,
                                decoration: TextDecoration.lineThrough,
                              ),
                        ),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                              text: price.isEmpty
                                  ? context.l10n.hotelPriceAsk
                                  : price,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: colors.brandPrimaryDark,
                                    fontWeight: FontWeight.w900,
                                    height: 1,
                                  ),
                            ),
                            if (price.isNotEmpty)
                              TextSpan(
                                text: context.l10n.hotelDetailPerStay(nights),
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: colors.brandPrimaryDark,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _RoomQuantityStepper(
                  quantity: quantity,
                  onDecrement: onDecrement,
                  onIncrement: onIncrement,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<_RoomFact> _roomFacts(BuildContext context) {
    return <_RoomFact>[
      if (room.occupancy != null)
        _RoomFact(
          Icons.people_alt_outlined,
          context.l10n.hotelDetailRoomCapacity(room.occupancy!),
        ),
      if (room.baseOccupancy != null)
        _RoomFact(
          Icons.person_outline_rounded,
          context.l10n.hotelDetailRoomBaseOccupancy(room.baseOccupancy!),
        ),
      if (room.roomSize.isNotEmpty)
        _RoomFact(
          Icons.square_foot_outlined,
          context.l10n.hotelDetailRoomArea(room.roomSize),
        ),
      if (room.bedroomCount != null)
        _RoomFact(
          Icons.bed_outlined,
          context.l10n.hotelDetailBedrooms(room.bedroomCount!),
        ),
      if (room.bathroomCount != null)
        _RoomFact(
          Icons.bathtub_outlined,
          context.l10n.hotelDetailBathrooms(room.bathroomCount!),
        ),
    ];
  }

  String _discountLabel(BuildContext context) {
    if (room.discountName.isNotEmpty) {
      return room.discountName;
    }
    final discount = room.discount;
    if (discount == null) {
      return '';
    }
    final text = discount % 1 == 0
        ? discount.toInt().toString()
        : discount.toString();
    return context.l10n.hotelDetailDiscount(text);
  }
}

class _RoomFactChip extends StatelessWidget {
  const _RoomFactChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 18, color: colors.textTertiary),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _RoomQuantityStepper extends StatelessWidget {
  const _RoomQuantityStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.highlightGold.withValues(alpha: 0.50)),
      ),
      child: SizedBox(
        height: 46,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _StepperButton(
              icon: Icons.remove_rounded,
              onTap: quantity > 0 ? onDecrement : null,
            ),
            SizedBox(
              width: 44,
              child: Text(
                quantity.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colors.brandPrimaryDark,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            _StepperButton(icon: Icons.add_rounded, onTap: onIncrement),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 46,
        height: 46,
        child: Icon(
          icon,
          color: onTap == null ? colors.disabled : colors.brandPrimaryDark,
          size: 24,
        ),
      ),
    );
  }
}

class _RoomFact {
  const _RoomFact(this.icon, this.label);

  final IconData icon;
  final String label;
}
