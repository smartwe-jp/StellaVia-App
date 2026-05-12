import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../controllers/hotel_booking_controller.dart';

class HotelFilterSection extends StatelessWidget {
  const HotelFilterSection({
    super.key,
    required this.state,
    required this.onPriceSortSelected,
  });

  final HotelBookingState state;
  final Future<void> Function(HotelPriceSort priceSort) onPriceSortSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: <Widget>[
          _ToolbarChip(
            label: context.l10n.hotelSortRecommended,
            selected: state.criteria.priceSort == HotelPriceSort.none,
            onTap: () => onPriceSortSelected(HotelPriceSort.none),
          ),
          _ToolbarChip(
            label: context.l10n.hotelSortPriceLow,
            selected: state.criteria.priceSort != HotelPriceSort.none,
            onTap: () {
              final next = state.criteria.priceSort == HotelPriceSort.ascending
                  ? HotelPriceSort.descending
                  : HotelPriceSort.ascending;
              onPriceSortSelected(next);
            },
          ),
          _ToolbarChip(label: context.l10n.hotelToolbarFilter, onTap: () {}),
          _ToolbarChip(label: context.l10n.hotelToolbarMap, onTap: () {}),
        ],
      ),
    );
  }
}

class _ToolbarChip extends StatelessWidget {
  const _ToolbarChip({
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0C1C50);
    const line = Color(0xFFE3D7C3);
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Material(
        color: selected ? navy : Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: selected ? navy : line),
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: selected ? Colors.white : navy,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
