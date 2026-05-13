import 'package:core_ui_kit/core_ui_kit.dart';
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
    final colors = Theme.of(context).appColors;
    return Material(
        color: colors.brandWhite.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: colors.borderSoft),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _ToolbarSegment(
                  icon: Icons.swap_vert_rounded,
                  label: context.l10n.hotelToolbarSort,
                  onTap: () {
                    final next =
                        state.criteria.priceSort == HotelPriceSort.ascending
                        ? HotelPriceSort.descending
                        : HotelPriceSort.ascending;
                    onPriceSortSelected(next);
                  },
                ),
              ),
              _ToolbarDivider(color: colors.borderSoft),
              Expanded(
                child: _ToolbarSegment(
                  icon: Icons.tune_rounded,
                  label: context.l10n.hotelToolbarFilter,
                  onTap: () {},
                ),
              ),
              _ToolbarDivider(color: colors.borderSoft),
              Expanded(
                child: _ToolbarSegment(
                  icon: Icons.map_outlined,
                  label: context.l10n.hotelToolbarMap,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      
    );
  }
}

class _ToolbarSegment extends StatelessWidget {
  const _ToolbarSegment({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: colors.brandPrimary, size: 30),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.brandPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolbarDivider extends StatelessWidget {
  const _ToolbarDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 72,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: color)),
          ),
        ),
      ),
    );
  }
}
