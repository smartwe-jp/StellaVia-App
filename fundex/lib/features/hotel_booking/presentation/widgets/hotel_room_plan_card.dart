import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_detail_image_placeholder.dart';
import 'hotel_discount_badge.dart';
import 'hotel_remaining_rooms_label.dart';

class HotelRoomPlanCard extends StatelessWidget {
  const HotelRoomPlanCard({
    super.key,
    required this.room,
    required this.presenter,
    required this.quantity,
    required this.nights,
    this.isBusy = false,
    this.showQuantityControls = true,
    this.canIncrementQuantity = true,
    this.remainingUnit = HotelRemainingUnit.room,
    this.extraGuestCount = 0,
    this.extraGuestPrice,
    this.onTap,
    this.onDiscountTap,
    required this.onDecrement,
    required this.onIncrement,
  });

  final HotelRoomPlan room;
  final HotelBookingPresenter presenter;
  final int quantity;
  final int nights;
  final bool isBusy;
  final bool showQuantityControls;
  final bool canIncrementQuantity;
  final HotelRemainingUnit remainingUnit;
  final int extraGuestCount;
  final num? extraGuestPrice;
  final VoidCallback? onTap;
  final VoidCallback? onDiscountTap;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final price = presenter.price(room.price);
    final oldPrice = _shouldShowOldPrice
        ? presenter.price(room.beforeDiscountPrice)
        : '';
    final imageUrl = room.images.isEmpty ? '' : room.images.first.url;
    final facts = _roomFacts(context);
    final hasDiscount =
        room.discountName.isNotEmpty && (room.discount ?? 0) > 0;
    final remainingRooms = room.remainingRooms;
    final minimumStayNights = room.minimumStayNights;
    final meetsMinimumStay =
        minimumStayNights == null ||
        minimumStayNights <= 0 ||
        nights >= minimumStayNights;
    final canIncrement =
        meetsMinimumStay &&
        canIncrementQuantity &&
        (remainingRooms == null ||
            remainingRooms < 0 ||
            quantity < remainingRooms);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandWhite,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.brandPrimaryDark.withValues(alpha: 0.08),
            blurRadius: UiTokens.radius16,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: colors.brandWhite,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(UiTokens.radius16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: _RoomPlanCardContent(
              room: room,
              quantity: quantity,
              nights: nights,
              imageUrl: imageUrl,
              facts: facts,
              price: price,
              oldPrice: oldPrice,
              hasDiscount: hasDiscount,
              remainingRooms: remainingRooms,
              minimumStayNights: meetsMinimumStay ? null : minimumStayNights,
              remainingUnit: remainingUnit,
              canIncrement: canIncrement,
              isBusy: isBusy,
              showQuantityControls: showQuantityControls,
              extraGuestCount: extraGuestCount,
              extraGuestPrice: extraGuestPrice,
              onDiscountTap: onDiscountTap,
              onDecrement: onDecrement,
              onIncrement: onIncrement,
            ),
          ),
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
      ...room.beds
          .where((bed) => bed.name.trim().isNotEmpty)
          .map(
            (bed) => _RoomFact(
              Icons.king_bed_outlined,
              _formatBedSummary(context, bed),
            ),
          ),
    ];
  }

  String _formatBedSummary(BuildContext context, HotelRoomBed bed) {
    final unit = _isFuton(bed.name)
        ? context.l10n.hotelRoomBedUnitFuton
        : context.l10n.hotelRoomBedUnitDefault;
    final summary = context.l10n.hotelRoomBedSummary(
      bed.name.trim(),
      bed.quantity ?? 1,
      unit,
    );
    final width = _formatBedWidth(context, bed.width);
    if (width.isEmpty) {
      return summary;
    }
    return context.l10n.hotelRoomBedSummaryWithWidth(summary, width);
  }

  String _formatBedWidth(BuildContext context, String raw) {
    final value = _normalizeBedWidth(raw);
    if (value.isEmpty) {
      return '';
    }
    return context.l10n.hotelRoomBedWidth(value);
  }

  String _normalizeBedWidth(String raw) {
    return raw
        .trim()
        .replaceAll(RegExp(r'cm$', caseSensitive: false), '')
        .replaceAll(RegExp(r'^(幅|宽|寬)'), '')
        .trim();
  }

  bool _isFuton(String name) {
    final lower = name.toLowerCase();
    return name.contains('布団') ||
        name.contains('布团') ||
        lower.contains('futon');
  }

  bool get _shouldShowOldPrice {
    final current = room.price;
    final original = room.beforeDiscountPrice;
    if (current == null || original == null) {
      return false;
    }
    return original > current;
  }
}

class _RoomPlanCardContent extends StatelessWidget {
  const _RoomPlanCardContent({
    required this.room,
    required this.quantity,
    required this.nights,
    required this.imageUrl,
    required this.facts,
    required this.price,
    required this.oldPrice,
    required this.hasDiscount,
    required this.remainingRooms,
    required this.minimumStayNights,
    required this.remainingUnit,
    required this.canIncrement,
    required this.isBusy,
    required this.showQuantityControls,
    required this.extraGuestCount,
    required this.extraGuestPrice,
    required this.onDiscountTap,
    required this.onDecrement,
    required this.onIncrement,
  });

  final HotelRoomPlan room;
  final int quantity;
  final int nights;
  final String imageUrl;
  final List<_RoomFact> facts;
  final String price;
  final String oldPrice;
  final bool hasDiscount;
  final int? remainingRooms;
  final int? minimumStayNights;
  final HotelRemainingUnit remainingUnit;
  final bool canIncrement;
  final bool isBusy;
  final bool showQuantityControls;
  final int extraGuestCount;
  final num? extraGuestPrice;
  final VoidCallback? onDiscountTap;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(UiTokens.radius12),
              child: SizedBox(
                width: 116,
                height: 126,
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colors.brandPrimaryDark,
                      fontWeight: FontWeight.w900,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: facts
                        .map(
                          (fact) =>
                              _RoomFactChip(icon: fact.icon, label: fact.label),
                        )
                        .toList(growable: false),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  HotelDiscountBadge(
                    name: room.discountName,
                    discount: room.discount,
                    onTap: onDiscountTap,
                  ),
                  if (hasDiscount) const SizedBox(height: 8),
                  if (oldPrice.isNotEmpty)
                    Text(
                      oldPrice,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
                                fontWeight: FontWeight.w800,
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
            //if (showQuantityControls)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  if (extraGuestCount > 0) ...<Widget>[
                    _ExtraGuestPriceNotice(
                      extraGuestCount: extraGuestCount,
                      extraGuestPrice: extraGuestPrice,
                    ),
                    const SizedBox(height: 8),
                  ],
                  _RoomQuantityStepper(
                    quantity: quantity,
                    remainingRooms: remainingRooms,
                    minimumStayNights: minimumStayNights,
                    remainingUnit: remainingUnit,
                    onDecrement: isBusy ? null : onDecrement,
                    onIncrement: isBusy || !canIncrement ? null : onIncrement,
                  ),
                ],
              )
            //else if (remainingRooms != null && remainingRooms! >= 0)
              // HotelRemainingRoomsLabel(
              //   count: remainingRooms!,
              //   unit: remainingUnit,
              //   textAlign: TextAlign.end,
              // ),
          ],
        ),
      ],
    );
  }
}

class _ExtraGuestPriceNotice extends StatelessWidget {
  const _ExtraGuestPriceNotice({
    required this.extraGuestCount,
    required this.extraGuestPrice,
  });

  final int extraGuestCount;
  final num? extraGuestPrice;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final priceText = presenter.price(extraGuestPrice);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primaryAlt.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(UiTokens.radius8),
        border: Border.all(color: colors.primaryAlt.withValues(alpha: 0.32)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              context.l10n.hotelDetailExtraGuestCount(extraGuestCount),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colors.brandPrimaryDark,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (priceText.isNotEmpty)
              Text(
                context.l10n.hotelDetailExtraGuestPrice(priceText),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.brandPrimaryDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
          ],
        ),
      ),
    );
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
        Flexible(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _RoomQuantityStepper extends StatelessWidget {
  const _RoomQuantityStepper({
    required this.quantity,
    required this.remainingRooms,
    required this.minimumStayNights,
    required this.remainingUnit,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final int? remainingRooms;
  final int? minimumStayNights;
  final HotelRemainingUnit remainingUnit;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    if (remainingRooms == 0 && quantity == 0 && onIncrement == null) return const HotelFullBadge();
    final shouldShowRemaining = remainingRooms != null && remainingRooms! >= 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (minimumStayNights != null || shouldShowRemaining) ...<Widget>[
          if (minimumStayNights != null && remainingRooms != 0)
            Text(
              context.l10n.hotelDetailMinimumStay(minimumStayNights!),
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colors.danger,
                fontWeight: FontWeight.w700,
              ),
            )
          else if (shouldShowRemaining)
            HotelRemainingRoomsLabel(
              count: remainingRooms!,
              unit: remainingUnit,
              showFullBadge: false,
              textAlign: TextAlign.end,
            ),
          const SizedBox(height: 6),
        ],
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: colors.primaryAlt.withValues(alpha: 0.50),
            ),
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
        ),
      ],
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
    final isEnabled = onTap != null;
    final buttonContent = SizedBox(
      width: 46,
      height: 46,
      child: Icon(
        icon,
        color: isEnabled ? colors.brandPrimaryDark : colors.disabled,
        size: 24,
      ),
    );
    return Semantics(
      button: true,
      enabled: isEnabled,
      child: isEnabled
          ? InkWell(
              onTap: onTap,
              excludeFromSemantics: true,
              borderRadius: BorderRadius.circular(18),
              child: buttonContent,
            )
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _absorbDisabledStepperTap,
              excludeFromSemantics: true,
              child: buttonContent,
            ),
    );
  }
}

void _absorbDisabledStepperTap() {}

class _RoomFact {
  const _RoomFact(this.icon, this.label);

  final IconData icon;
  final String label;
}
