import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';

class HotelHeroSection extends ConsumerStatefulWidget {
  const HotelHeroSection({
    super.key,
    required this.criteria,
    required this.presenter,
    required this.onSearch,
    required this.onBuildingSelected,
    required this.onGuestsChanged,
  });

  final HotelSearchCriteria criteria;
  final HotelBookingPresenter presenter;
  final Future<void> Function({
    String? keyword,
    String? area,
    DateTime? checkInDate,
    DateTime? checkOutDate,
  })
  onSearch;
  final Future<void> Function(String? buildingCode) onBuildingSelected;
  final Future<void> Function({
    required int adults,
    required int children,
    required int rooms,
  })
  onGuestsChanged;

  @override
  ConsumerState<HotelHeroSection> createState() => _HotelHeroSectionState();
}

class _HotelHeroSectionState extends ConsumerState<HotelHeroSection> {
  static const _navy = Color(0xFF0C1C50);
  static const _navyDeep = Color(0xFF09153B);
  static const _creamLighter = Color(0xFFF8F4EF);
  static const _line = Color(0xFFE3D7C3);
  static const _soft = Color(0xFF7A899F);

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final range = await showDateRangePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: widget.criteria.checkInDate,
        end: widget.criteria.checkOutDate,
      ),
    );
    if (range == null) {
      return;
    }
    await widget.onSearch(checkInDate: range.start, checkOutDate: range.end);
  }

  Future<void> _editDestination() async {
    final controller = TextEditingController(
      text: widget.criteria.keyword.trim().isEmpty
          ? context.l10n.hotelDefaultDestination
          : widget.criteria.keyword.trim(),
    );
    final keyword = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.viewInsetsOf(context).bottom + 28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: controller,
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: context.l10n.hotelDestinationLabel,
                  hintText: context.l10n.hotelSearchKeywordHint,
                ),
                onSubmitted: (value) => Navigator.of(context).pop(value),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(controller.text),
                  child: Text(context.l10n.commonApply),
                ),
              ),
            ],
          ),
        );
      },
    );
    controller.dispose();
    if (keyword == null) {
      return;
    }
    await widget.onSearch(keyword: keyword.trim());
  }

  Future<void> _selectBuildingType(List<HotelBuildingFilter> filters) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(context.l10n.hotelFilterAllTypes),
                onTap: () => Navigator.of(context).pop(''),
              ),
              for (final filter in filters)
                ListTile(
                  title: Text(filter.name),
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
    await widget.onBuildingSelected(selected.isEmpty ? null : selected);
  }

  Future<void> _editGuests() async {
    var adults = widget.criteria.occupancy;
    var children = widget.criteria.kids;
    var rooms = widget.criteria.roomCount;
    final result = await showModalBottomSheet<(int, int, int)>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _StepperRow(
                    label: context.l10n.hotelGuestAdults,
                    value: adults,
                    min: 1,
                    onChanged: (value) => setSheetState(() => adults = value),
                  ),
                  _StepperRow(
                    label: context.l10n.hotelGuestChildren,
                    value: children,
                    min: 0,
                    onChanged: (value) => setSheetState(() => children = value),
                  ),
                  _StepperRow(
                    label: context.l10n.hotelGuestRooms,
                    value: rooms,
                    min: 1,
                    onChanged: (value) => setSheetState(() => rooms = value),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () =>
                          Navigator.of(context).pop((adults, children, rooms)),
                      child: Text(context.l10n.commonApply),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (result == null) {
      return;
    }
    await widget.onGuestsChanged(
      adults: result.$1,
      children: result.$2,
      rooms: result.$3,
    );
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref
        .watch(hotelBuildingFiltersProvider)
        .maybeWhen(
          data: (items) => items,
          orElse: () => const <HotelBuildingFilter>[],
        );
    String? buildingTypeLabel;
    for (final item in filters) {
      if (item.code == widget.criteria.buildingCode) {
        buildingTypeLabel = item.name;
        break;
      }
    }
    final destination = widget.criteria.keyword.trim().isEmpty
        ? context.l10n.hotelDefaultDestination
        : widget.criteria.keyword.trim();

    return SizedBox(
      height: 432,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(bottom: 186, child: _HeroPhoto()),
          Positioned(left: 20, right: 20, top: 94, child: _HeroCopy()),
          Positioned(
            left: 16,
            right: 16,
            top: 224,
            child: _SearchCard(
              destination: destination,
              buildingTypeLabel:
                  buildingTypeLabel ?? context.l10n.hotelFilterAllTypes,
              stayRange: widget.presenter.stayRange(widget.criteria),
              guestsLabel: context.l10n.hotelGuestSummary(
                widget.criteria.occupancy,
                widget.criteria.roomCount,
              ),
              onDestinationTap: _editDestination,
              onBuildingTypeTap: () => _selectBuildingType(filters),
              onDateTap: _pickDates,
              onGuestsTap: _editGuests,
              onSearchTap: () => widget.onSearch(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: _HotelHeroSectionState._navy),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/hotel-booking-ui/detail-room-01.png',
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.72),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  _HotelHeroSectionState._navyDeep.withValues(alpha: 0.30),
                  _HotelHeroSectionState._navyDeep.withValues(alpha: 0.88),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              context.l10n.hotelBrandMark,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
            const Spacer(),
            const CircleAvatar(
              radius: 27,
              backgroundColor: Color(0x55FFFFFF),
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 62),
        Text(
          context.l10n.hotelTabHeadline,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            height: 1.12,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          context.l10n.hotelTabSubtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.80),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({
    required this.destination,
    required this.buildingTypeLabel,
    required this.stayRange,
    required this.guestsLabel,
    required this.onDestinationTap,
    required this.onBuildingTypeTap,
    required this.onDateTap,
    required this.onGuestsTap,
    required this.onSearchTap,
  });

  final String destination;
  final String buildingTypeLabel;
  final String stayRange;
  final String guestsLabel;
  final VoidCallback onDestinationTap;
  final VoidCallback onBuildingTypeTap;
  final VoidCallback onDateTap;
  final VoidCallback onGuestsTap;
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _HotelHeroSectionState._line),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: _HotelHeroSectionState._navy.withValues(alpha: 0.16),
            blurRadius: 34,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: <Widget>[
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 72,
              ),
              children: <Widget>[
                _SearchField(
                  label: context.l10n.hotelDestinationLabel,
                  value: destination,
                  onTap: onDestinationTap,
                ),
                _SearchField(
                  label: context.l10n.hotelPropertyTypeLabel,
                  value: buildingTypeLabel,
                  onTap: onBuildingTypeTap,
                ),
                _SearchField(
                  label: context.l10n.hotelCheckInDateLabel,
                  value: stayRange,
                  onTap: onDateTap,
                ),
                _SearchField(
                  label: context.l10n.hotelGuestFieldLabel,
                  value: guestsLabel,
                  onTap: onGuestsTap,
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _HotelHeroSectionState._navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: onSearchTap,
                child: Text(
                  context.l10n.hotelSearchAction,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
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

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _HotelHeroSectionState._creamLighter,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _HotelHeroSectionState._line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: _HotelHeroSectionState._soft,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _HotelHeroSectionState._navyDeep,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  const _StepperRow({
    required this.label,
    required this.value,
    required this.min,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label)),
          IconButton(
            onPressed: value <= min ? null : () => onChanged(value - 1),
            icon: const Icon(Icons.remove_rounded),
          ),
          SizedBox(
            width: 34,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton(
            onPressed: () => onChanged(value + 1),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}
