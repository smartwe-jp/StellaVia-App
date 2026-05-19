import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../controllers/hotel_booking_controller.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_search_conditions_sheet.dart';

class HotelFilterSection extends ConsumerWidget {
  const HotelFilterSection({
    super.key,
    required this.state,
    required this.presenter,
    required this.onPriceSortSelected,
    required this.onCriteriaApplied,
    this.onMapTap,
  });

  final HotelBookingState state;
  final HotelBookingPresenter presenter;
  final Future<void> Function(HotelPriceSort priceSort) onPriceSortSelected;
  final Future<void> Function(HotelSearchCriteria criteria) onCriteriaApplied;
  final VoidCallback? onMapTap;

  Future<void> _openSearchConditions(
    BuildContext context,
    List<HotelBuildingFilter> filters,
  ) async {
    final colors = Theme.of(context).appColors;
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: colors.brandWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UiTokens.radius28),
        ),
      ),
      builder: (_) {
        return HotelSearchConditionsSheet(
          criteria: state.criteria,
          presenter: presenter,
          buildingFilters: filters,
          onApply: onCriteriaApplied,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final filters = ref
        .watch(hotelBuildingFiltersProvider)
        .maybeWhen(
          data: (items) => items,
          orElse: () => const <HotelBuildingFilter>[],
        );
    return Material(
      color: colors.brandWhite.withValues(alpha: 0.88),
      borderRadius: BorderRadius.circular(28),
      child: Ink(
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: colors.borderSoft),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _SortToolbarSegment(
                label: context.l10n.hotelToolbarSort,
                currentSort: state.criteria.priceSort,
                onSelected: (priceSort) {
                  if (priceSort != state.criteria.priceSort) {
                    onPriceSortSelected(priceSort);
                  }
                },
              ),
            ),
            _ToolbarDivider(color: colors.borderSoft),
            Expanded(
              child: _ToolbarSegment(
                icon: Icons.tune_rounded,
                label: context.l10n.hotelToolbarFilter,
                onTap: () => _openSearchConditions(context, filters),
              ),
            ),
            _ToolbarDivider(color: colors.borderSoft),
            Expanded(
              child: _ToolbarSegment(
                icon: Icons.map_outlined,
                label: context.l10n.hotelToolbarMap,
                onTap: onMapTap ?? () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortToolbarSegment extends StatelessWidget {
  const _SortToolbarSegment({
    required this.label,
    required this.currentSort,
    required this.onSelected,
  });

  final String label;
  final HotelPriceSort currentSort;
  final ValueChanged<HotelPriceSort> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return PopupMenuButton<HotelPriceSort>(
      padding: EdgeInsets.zero,
      position: PopupMenuPosition.under,
      color: colors.brandWhite,
      surfaceTintColor: colors.brandWhite,
      shadowColor: colors.brandPrimaryDark.withValues(alpha: 0.18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.borderSoft),
      ),
      onSelected: onSelected,
      itemBuilder: (context) => <PopupMenuEntry<HotelPriceSort>>[
        PopupMenuItem<HotelPriceSort>(
          value: HotelPriceSort.ascending,
          child: _SortMenuItem(
            label: context.l10n.hotelSortPriceAscending,
            selected: currentSort == HotelPriceSort.ascending,
          ),
        ),
        PopupMenuItem<HotelPriceSort>(
          value: HotelPriceSort.descending,
          child: _SortMenuItem(
            label: context.l10n.hotelSortPriceDescending,
            selected: currentSort == HotelPriceSort.descending,
          ),
        ),
      ],
      child: SizedBox.expand(
        child: _ToolbarSegmentBody(icon: Icons.swap_vert_rounded, label: label),
      ),
    );
  }
}

class _SortMenuItem extends StatelessWidget {
  const _SortMenuItem({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      children: <Widget>[
        SizedBox(
          width: 26,
          child: selected
              ? Icon(Icons.check_rounded, color: colors.brandPrimary, size: 22)
              : null,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.brandPrimaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
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
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: SizedBox.expand(
        child: _ToolbarSegmentBody(icon: icon, label: label),
      ),
    );
  }
}

class _ToolbarSegmentBody extends StatelessWidget {
  const _ToolbarSegmentBody({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: colors.brandPrimary, size: 20),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.brandPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
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
