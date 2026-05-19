import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import '../widgets/hotel_map_canvas.dart';
import '../widgets/hotel_map_controls.dart';
import '../widgets/hotel_map_selected_card.dart';
import '../widgets/hotel_search_conditions_sheet.dart';
import '../widgets/hotel_state_views.dart';

class HotelMapPage extends ConsumerStatefulWidget {
  const HotelMapPage({super.key, this.initialCriteria});

  final HotelSearchCriteria? initialCriteria;

  @override
  ConsumerState<HotelMapPage> createState() => _HotelMapPageState();
}

class _HotelMapPageState extends ConsumerState<HotelMapPage> {
  String? _selectedHotelId;
  bool _initialCriteriaApplied = false;
  bool _selectionSuppressed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyInitialCriteria();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hotelBookingControllerProvider);
    final colors = Theme.of(context).appColors;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final mapResult = ref.watch(hotelMapSearchProvider(state.criteria));
    final hotels = mapResult.maybeWhen(
      data: (result) => result.hotels,
      orElse: () => state.hotels,
    );
    final selectedHotel = _selectedHotel(hotels);
    _syncSelectedHotel(hotels);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: colors.surfaceAlt,
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: HotelMapCanvas(
                hotels: hotels,
                selectedHotelId: _selectedHotelId,
                fallbackTarget: _fallbackTarget(state.criteria),
                presenter: presenter,
                onHotelSelected: (hotel) {
                  setState(() {
                    _selectedHotelId = hotel.id;
                    _selectionSuppressed = false;
                  });
                },
                onMapTap: () {
                  setState(() {
                    _selectedHotelId = null;
                    _selectionSuppressed = true;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: HotelMapControls(
                criteria: state.criteria,
                presenter: presenter,
                onBack: _showList,
                onOpenFilters: () => _openSearchConditions(state.criteria),
                onShowList: _showList,
                onNearby: () {},
              ),
            ),
            if (mapResult.isLoading && hotels.isEmpty)
              Center(
                child: CircularProgressIndicator(color: colors.brandPrimary),
              ),
            if (mapResult.hasError && hotels.isEmpty)
              Positioned.fill(
                child: ColoredBox(
                  color: colors.surfaceAlt,
                  child: HotelFullPageError(
                    onRetry: () =>
                        ref.invalidate(hotelMapSearchProvider(state.criteria)),
                  ),
                ),
              ),
            if (selectedHotel != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: HotelMapSelectedCard(
                  hotel: selectedHotel,
                  presenter: presenter,
                  onTap: () => _openHotelDetail(selectedHotel, state.criteria),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSearchConditions(HotelSearchCriteria criteria) async {
    final colors = Theme.of(context).appColors;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final filters = ref
        .read(hotelBuildingFiltersProvider)
        .maybeWhen(
          data: (items) => items,
          orElse: () => const <HotelBuildingFilter>[],
        );
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: colors.brandWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) {
        return HotelSearchConditionsSheet(
          criteria: criteria,
          presenter: presenter,
          buildingFilters: filters,
          onApply: (nextCriteria) async {
            setState(() {
              _selectedHotelId = null;
              _selectionSuppressed = false;
            });
            await ref
                .read(hotelBookingControllerProvider.notifier)
                .applyCriteria(nextCriteria);
          },
        );
      },
    );
  }

  void _showList() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go('/hotel-booking');
  }

  void _openHotelDetail(HotelSummary hotel, HotelSearchCriteria criteria) {
    if (hotel.id.trim().isEmpty) {
      return;
    }
    context.push(
      '/hotel-booking/${Uri.encodeComponent(hotel.id)}',
      extra: criteria,
    );
  }

  void _applyInitialCriteria() {
    if (_initialCriteriaApplied || !mounted) {
      return;
    }
    _initialCriteriaApplied = true;
    final initialCriteria = widget.initialCriteria;
    if (initialCriteria == null) {
      return;
    }
    final current = ref.read(hotelBookingControllerProvider).criteria;
    if (_sameCriteria(current, initialCriteria)) {
      return;
    }
    ref
        .read(hotelBookingControllerProvider.notifier)
        .applyCriteria(initialCriteria);
  }

  void _syncSelectedHotel(List<HotelSummary> hotels) {
    final validHotels = hotels
        .where((hotel) => _coordinateFor(hotel) != null)
        .toList(growable: false);
    final selectedHotelId = _selectedHotelId;
    final selectionStillValid =
        selectedHotelId != null &&
        validHotels.any((hotel) => hotel.id == selectedHotelId);
    if (selectionStillValid) {
      return;
    }
    final nextSelectedId = validHotels.isEmpty ? null : validHotels.first.id;
    if (_selectionSuppressed && nextSelectedId != null) {
      return;
    }
    if (nextSelectedId == selectedHotelId) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedHotelId = nextSelectedId;
      });
    });
  }

  HotelSummary? _selectedHotel(List<HotelSummary> hotels) {
    final selectedHotelId = _selectedHotelId;
    if (selectedHotelId == null) {
      return null;
    }
    for (final hotel in hotels) {
      if (hotel.id == selectedHotelId && _coordinateFor(hotel) != null) {
        return hotel;
      }
    }
    return null;
  }

  gmaps.LatLng? _coordinateFor(HotelSummary hotel) {
    final latitude = hotel.latitude;
    final longitude = hotel.longitude;
    if (latitude == null || longitude == null) {
      return null;
    }
    if (latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      return null;
    }
    return gmaps.LatLng(latitude, longitude);
  }

  gmaps.LatLng _fallbackTarget(HotelSearchCriteria criteria) {
    switch (criteria.area.trim()) {
      case 'kyoto':
        return const gmaps.LatLng(35.0028469, 135.7566056);
      case 'tokyo':
        return const gmaps.LatLng(35.6563391, 139.7400959);
      case 'osaka':
      default:
        return const gmaps.LatLng(34.6552488, 135.5011531);
    }
  }

  bool _sameCriteria(HotelSearchCriteria a, HotelSearchCriteria b) {
    return a.checkInDate == b.checkInDate &&
        a.checkOutDate == b.checkOutDate &&
        a.keyword == b.keyword &&
        a.area == b.area &&
        a.bookingType == b.bookingType &&
        a.buildingCode == b.buildingCode &&
        a.priceSort == b.priceSort &&
        a.occupancy == b.occupancy &&
        a.kids == b.kids &&
        a.roomCount == b.roomCount;
  }
}
