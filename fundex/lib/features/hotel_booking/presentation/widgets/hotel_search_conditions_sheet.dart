import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_search_condition_pickers.dart';

class HotelAreaOption {
  const HotelAreaOption({required this.value, required this.label});

  final String value;
  final String label;
}

List<HotelAreaOption> hotelAreaOptions(BuildContext context) {
  return <HotelAreaOption>[
    HotelAreaOption(value: '', label: context.l10n.hotelDefaultDestination),
    HotelAreaOption(value: 'osaka', label: context.l10n.hotelAreaOsaka),
    HotelAreaOption(value: 'kyoto', label: context.l10n.hotelAreaKyoto),
    HotelAreaOption(value: 'tokyo', label: context.l10n.hotelAreaTokyo),
  ];
}

String hotelAreaLabel(BuildContext context, String area) {
  final normalized = area.trim();
  for (final option in hotelAreaOptions(context)) {
    if (option.value == normalized) {
      return option.label;
    }
  }
  return context.l10n.hotelDefaultDestination;
}

class HotelSearchConditionsSheet extends StatefulWidget {
  const HotelSearchConditionsSheet({
    super.key,
    required this.criteria,
    required this.presenter,
    required this.buildingFilters,
    required this.onApply,
  });

  final HotelSearchCriteria criteria;
  final HotelBookingPresenter presenter;
  final List<HotelBuildingFilter> buildingFilters;
  final Future<void> Function(HotelSearchCriteria criteria) onApply;

  @override
  State<HotelSearchConditionsSheet> createState() =>
      _HotelSearchConditionsSheetState();
}

class _HotelSearchConditionsSheetState
    extends State<HotelSearchConditionsSheet> {
  late HotelSearchCriteria _criteria = widget.criteria;

  List<HotelBuildingFilter> get _buildingFilters {
    if (widget.buildingFilters.isNotEmpty) {
      return widget.buildingFilters;
    }
    return <HotelBuildingFilter>[
      HotelBuildingFilter(code: '', name: context.l10n.hotelFilterAllTypes),
    ];
  }

  String get _buildingTypeLabel {
    final code = _criteria.buildingCode ?? '';
    for (final filter in _buildingFilters) {
      if (filter.code == code) {
        return filter.name;
      }
    }
    return context.l10n.hotelFilterAllTypes;
  }

  Future<void> _selectDestination() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        final colors = Theme.of(context).appColors;
        final options = hotelAreaOptions(context);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final option in options)
                ListTile(
                  title: Text(option.label),
                  trailing: _criteria.area == option.value
                      ? Icon(Icons.check_rounded, color: colors.primary)
                      : null,
                  onTap: () => Navigator.of(context).pop(option.value),
                ),
            ],
          ),
        );
      },
    );
    if (selected == null || !mounted) {
      return;
    }
    setState(() {
      _criteria = _criteria.copyWith(area: selected);
    });
  }

  Future<void> _selectBuildingType() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        final colors = Theme.of(context).appColors;
        final filters = _buildingFilters;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final filter in filters)
                ListTile(
                  title: Text(filter.name),
                  trailing: (_criteria.buildingCode ?? '') == filter.code
                      ? Icon(Icons.check_rounded, color: colors.primary)
                      : null,
                  onTap: () => Navigator.of(context).pop(filter.code),
                ),
            ],
          ),
        );
      },
    );
    if (selected == null || !mounted) {
      return;
    }
    setState(() {
      _criteria = _criteria.copyWith(buildingCode: selected);
    });
  }

  Future<void> _pickDates() async {
    final nextCriteria = await pickHotelStayDates(
      context: context,
      criteria: _criteria,
    );
    if (nextCriteria == null || !mounted) {
      return;
    }
    setState(() => _criteria = nextCriteria);
  }

  Future<void> _editGuests() async {
    final nextCriteria = await editHotelGuests(
      context: context,
      criteria: _criteria,
    );
    if (nextCriteria == null || !mounted) {
      return;
    }
    setState(() => _criteria = nextCriteria);
  }

  Future<void> _apply() async {
    Navigator.of(context).pop();
    await widget.onApply(_criteria);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 14, 20, 20 + bottomPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.borderSoft,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const SizedBox(width: 84, height: 6),
            ),
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                context.l10n.hotelSearchConditionsTitle,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colors.brandPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 22),
            HotelSearchConditionRow(
              label: context.l10n.hotelDestinationLabel,
              value: hotelAreaLabel(context, _criteria.area),
              onTap: _selectDestination,
            ),
            const SizedBox(height: 12),
            HotelSearchConditionRow(
              label: context.l10n.hotelPropertyTypeLabel,
              value: _buildingTypeLabel,
              onTap: _selectBuildingType,
            ),
            const SizedBox(height: 12),
            HotelSearchConditionRow(
              label: context.l10n.hotelCheckInDateLabel,
              value: widget.presenter.stayRange(_criteria),
              onTap: _pickDates,
            ),
            const SizedBox(height: 12),
            HotelSearchConditionRow(
              label: context.l10n.hotelGuestFieldLabel,
              value: context.l10n.hotelGuestDetailedSummary(
                _criteria.occupancy,
                _criteria.kids,
                _criteria.roomCount,
              ),
              onTap: _editGuests,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.brandPrimary,
                  foregroundColor: colors.onDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: _apply,
                child: Text(
                  context.l10n.hotelSearchAction,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colors.onDark,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelSearchConditionRow extends StatelessWidget {
  const HotelSearchConditionRow({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final borderRadius = BorderRadius.circular(12);
    return Material(
      color: colors.surfaceAlt,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Ink(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: colors.borderSoft),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textTertiary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.brandPrimaryDark,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(width: 6),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: colors.textTertiary,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
