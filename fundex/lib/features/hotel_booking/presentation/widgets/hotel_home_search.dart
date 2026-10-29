import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_search_conditions_sheet.dart';

class HotelHomeSearch extends ConsumerWidget {
  const HotelHomeSearch({
    super.key,
    required this.criteria,
    required this.onApply,
    this.allowMultiNightBenefits = false,
  });
  final bool allowMultiNightBenefits;
  final HotelSearchCriteria criteria;
  final Future<void> Function(HotelSearchCriteria) onApply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final filters =
        ref.watch(hotelBuildingFiltersProvider).asData?.value ??
        const <HotelBuildingFilter>[];
    final colors = context.appColors;
    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.borderSoft),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: const Key('hotel_home_search'),
        onTap: () => showModalBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          builder: (_) => HotelSearchConditionsSheet(
            allowMultiNightBenefits: allowMultiNightBenefits,
            criteria: criteria,
            presenter: presenter,
            buildingFilters: filters,
            onApply: onApply,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.hotelHomeDatesGuests,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${presenter.stayRange(criteria)} · ${context.l10n.hotelGuestDetailedSummary(criteria.occupancy, criteria.kids, criteria.roomCount)}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 28,
                backgroundColor: colors.primary,
                child: Icon(Icons.search, color: colors.onDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HotelHomeFilters extends StatelessWidget {
  const HotelHomeFilters({
    super.key,
    required this.criteria,
    required this.onApply,
  });
  final HotelSearchCriteria criteria;
  final Future<void> Function(HotelSearchCriteria) onApply;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 12,
    runSpacing: 8,
    children: [
      PopupMenuButton<String>(
        initialValue: criteria.area,
        onSelected: (area) => onApply(criteria.copyWith(area: area)),
        itemBuilder: (_) => [
          for (final area in hotelAreaOptions(context))
            PopupMenuItem(value: area.value, child: Text(area.label)),
        ],
        child: _FilterPill(
          label: criteria.area.isEmpty
              ? context.l10n.hotelHomeArea
              : hotelAreaLabel(context, criteria.area),
        ),
      ),
      PopupMenuButton<HotelPriceSort>(
        initialValue: criteria.priceSort,
        onSelected: (sort) => onApply(criteria.copyWith(priceSort: sort)),
        itemBuilder: (_) => [
          PopupMenuItem(
            value: HotelPriceSort.ascending,
            child: Text(context.l10n.hotelSortPriceAscending),
          ),
          PopupMenuItem(
            value: HotelPriceSort.descending,
            child: Text(context.l10n.hotelSortPriceDescending),
          ),
        ],
        child: _FilterPill(label: context.l10n.hotelToolbarSort),
      ),
    ],
  );
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 36, minWidth: 100),
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
    decoration: BoxDecoration(
      border: Border.all(color: context.appColors.borderSoft),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(width: 8),
        const Icon(Icons.keyboard_arrow_down, size: 14),
      ],
    ),
  );
}
