import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';

const String _hotelHeroBannerBaseUrl = 'https://stellavia.co.jp/img';
const int _hotelHeroBannerImageCount = 3;
final String _hotelHeroBannerCacheVersion = DateTime.now()
    .millisecondsSinceEpoch
    .toString();

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

  Future<void> _selectDestination() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        final colors = Theme.of(context).appColors;
        final options = _hotelAreaOptions(context);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final option in options)
                ListTile(
                  title: Text(option.label),
                  trailing: widget.criteria.area == option.value
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
    await widget.onSearch(area: selected);
  }

  Future<void> _selectBuildingType(List<HotelBuildingFilter> filters) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        final colors = Theme.of(context).appColors;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final filter in filters)
                ListTile(
                  title: Text(filter.name),
                  trailing: (widget.criteria.buildingCode ?? '') == filter.code
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
    await widget.onBuildingSelected(selected);
  }

  Future<void> _editGuests() async {
    var adults = widget.criteria.occupancy;
    var children = widget.criteria.kids;
    var rooms = widget.criteria.roomCount;
    final result = await showModalBottomSheet<(int, int, int)>(
      context: context,
      useRootNavigator: true,
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
      if (item.code == (widget.criteria.buildingCode ?? '')) {
        buildingTypeLabel = item.name;
        break;
      }
    }
    final destination = _hotelAreaLabel(context, widget.criteria.area);

    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16 / 9,
          child: _HeroPhoto(),
        ),
        Transform.translate(
            offset: const Offset(0, -16),
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _SearchCard(
                  destination: destination,
                  buildingTypeLabel:
                      buildingTypeLabel ?? context.l10n.hotelFilterAllTypes,
                  stayRange: widget.presenter.stayRange(widget.criteria),
                  guestsLabel: context.l10n.hotelGuestSummary(
                    widget.criteria.occupancy,
                    widget.criteria.roomCount,
                  ),
                  onDestinationTap: _selectDestination,
                  onBuildingTypeTap: () => _selectBuildingType(filters),
                  onDateTap: _pickDates,
                  onGuestsTap: _editGuests,
                  onSearchTap: () => widget.onSearch(),
            ),
          )
        )
        
      ],
    );
  }
}

class _HotelAreaOption {
  const _HotelAreaOption({required this.value, required this.label});

  final String value;
  final String label;
}

List<_HotelAreaOption> _hotelAreaOptions(BuildContext context) {
  return <_HotelAreaOption>[
    _HotelAreaOption(value: '', label: context.l10n.hotelDefaultDestination),
    _HotelAreaOption(value: 'osaka', label: context.l10n.hotelAreaOsaka),
    _HotelAreaOption(value: 'kyoto', label: context.l10n.hotelAreaKyoto),
    _HotelAreaOption(value: 'tokyo', label: context.l10n.hotelAreaTokyo),
  ];
}

String _hotelAreaLabel(BuildContext context, String area) {
  final normalized = area.trim();
  for (final option in _hotelAreaOptions(context)) {
    if (option.value == normalized) {
      return option.label;
    }
  }
  return context.l10n.hotelDefaultDestination;
}

class _HeroPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final heroImageUrls = _hotelHeroImageUrls(Localizations.localeOf(context));
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.brandPrimary),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _HeroImagePlaceholder(
            colors: colors,
            icon: Icons.image_not_supported_outlined,
          ),
          FundHeroMediaBackground(
            gradientColors: <Color>[colors.heroMiddle, colors.primaryAlt],
            imageUrls: heroImageUrls,
            showArtworkOverlay: false,
            autoPlay: heroImageUrls.length > 1,
            autoPlayInterval: const Duration(seconds: 25),
          ),
          
          if (heroImageUrls.isEmpty)
            _HeroImagePlaceholder(
              colors: colors,
              icon: Icons.image_not_supported_outlined,
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  colors.brandPrimaryDark.withValues(alpha: 0.10),
                  colors.brandPrimaryDark.withValues(alpha: 0.88),
                ],
              ),
            ),
          ),
          Positioned(left: 20, top: 120, child: _HeroCopy()),
        ],
      ),
    );
  }
}

List<String> _hotelHeroImageUrls(Locale locale) {
  final localeSuffix = _hotelHeroLocaleSuffix(locale);
  return List<String>.generate(
    _hotelHeroBannerImageCount,
    (index) =>
        '$_hotelHeroBannerBaseUrl/banner.${index + 1}.$localeSuffix.jpg'
        '?v=$_hotelHeroBannerCacheVersion',
    growable: false,
  );
}

String _hotelHeroLocaleSuffix(Locale locale) {
  final languageCode = locale.languageCode.toLowerCase();
  if (languageCode == 'ja') {
    return 'ja';
  }
  if (languageCode == 'zh') {
    final scriptCode = locale.scriptCode?.toLowerCase();
    return scriptCode == 'hant' ? 'zh-hant' : 'zh-hans';
  }
  return 'en';
}

class _HeroImagePlaceholder extends StatelessWidget {
  const _HeroImagePlaceholder({required this.colors, this.icon});

  final AppSemanticColorTheme colors;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[colors.heroStart, colors.heroMiddle],
        ),
      ),
      child: icon == null
          ? null
          : Center(
              child: Icon(
                icon,
                color: colors.onDark.withValues(alpha: 0.72),
                size: 40,
              ),
            ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.l10n.hotelBrandMark,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colors.onDark,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          context.l10n.hotelTabSubtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colors.onDark.withValues(alpha: 0.80),
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
        color: colors.brandWhite.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderSoft),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.brandPrimary.withValues(alpha: 0.16),
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
              padding: EdgeInsets.zero,
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
                  backgroundColor: colors.brandPrimary,
                  foregroundColor: colors.onDark,
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
    final colors = Theme.of(context).appColors;
    return Material(
      color: colors.surfaceAlt,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.borderSoft),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.textTertiary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.brandPrimaryDark,
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
