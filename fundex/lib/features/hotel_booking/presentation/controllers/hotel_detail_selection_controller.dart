import 'package:flutter/foundation.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_detail_route_args.dart';

/// Selection belongs to one hotel/date/guest/account snapshot. Disposing it
/// invalidates pending assignments and quotes when any of those inputs change.
class HotelDetailSelectionController extends ChangeNotifier {
  HotelDetailSelectionController({
    required this.detail,
    required this.criteria,
    required this.mode,
    required this.assign,
    required this.quote,
    required this.languageCode,
  });
  final HotelDetail detail;
  final HotelSearchCriteria criteria;
  final HotelBookingMode mode;
  final String languageCode;
  final Future<HotelAssignOccupancyResult> Function(List<HotelSelectedRoom>)
  assign;
  final Future<HotelBookingQuote> Function(HotelBookingQuoteRequest) quote;
  Map<int, int> quantities = {};
  HotelAssignOccupancyResult? assignment;
  HotelBookingQuote? quotation;
  bool busy = false;
  bool failed = false;
  bool _disposed = false;
  int _revision = 0;

  List<HotelSelectedRoom> selectionsFor(Map<int, int> values) => [
    for (final entry in values.entries)
      if (entry.value > 0)
        HotelSelectedRoom(
          room: detail.roomPlans[entry.key],
          quantity: entry.value,
        ),
  ];
  List<HotelSelectedRoom> get selections => selectionsFor(quantities);
  int get roomCount => quantities.values.fold(0, (a, b) => a + b);
  num? get amount => mode == HotelBookingMode.hostMiles
      ? quotation?.pointTotal
      : assignment?.price;

  bool canAdd(int index, {int? roomLimit}) {
    final room = detail.roomPlans[index];
    final stock = room.remainingRooms;
    return !busy &&
        detail.isBookable &&
        (room.minimumStayNights == null ||
            criteria.nights >= room.minimumStayNights!) &&
        (stock == null || stock < 0 || (quantities[index] ?? 0) < stock) &&
        (roomLimit == null || roomCount < roomLimit);
  }

  Future<void> change(int index, int quantity, {int? roomLimit}) async {
    if (busy || quantity < 0 || index < 0 || index >= detail.roomPlans.length) {
      return;
    }
    if (quantity > (quantities[index] ?? 0) &&
        !canAdd(index, roomLimit: roomLimit)) {
      return;
    }
    final stock = detail.roomPlans[index].remainingRooms;
    final nextCount = roomCount - (quantities[index] ?? 0) + quantity;
    if (quantity > (quantities[index] ?? 0) &&
        ((stock != null && stock >= 0 && quantity > stock) ||
            (roomLimit != null && nextCount > roomLimit))) {
      return;
    }
    final next = {...quantities};
    if (quantity == 0) {
      next.remove(index);
    } else {
      next[index] = quantity;
    }
    // Commit the desired selection, clear stale totals, and expose retry on error.
    quantities = next;
    await refreshQuote();
  }

  Future<void> refreshQuote() async {
    if (busy || _disposed) return;
    final revision = ++_revision;
    assignment = null;
    quotation = null;
    failed = false;
    final selected = selections;
    if (selected.isEmpty) {
      notifyListeners();
      return;
    }
    busy = true;
    notifyListeners();
    try {
      final assigned = await assign(selected);
      if (_disposed || revision != _revision) return;
      HotelBookingQuote? quoted;
      if (mode == HotelBookingMode.hostMiles) {
        if (assigned.roomTypeCustNums.isEmpty) {
          throw StateError('Missing assigned occupancy for miles quote');
        }
        quoted = await quote(
          HotelBookingQuoteRequest(
            hotelId: detail.id,
            checkIn: criteria.checkInDate,
            checkOut: criteria.checkOutDate,
            languageCode: languageCode,
            rooms: [
              for (final room in assigned.roomTypeCustNums)
                HotelBookingQuoteRoom(
                  roomTypeId: room.roomTypeId,
                  occupancy: room.occupancy,
                ),
            ],
            coupons: const [],
            usesRoomPlanSelection: detail.bookingType == 0,
            selectedRooms: selected,
          ),
        );
      }
      if (_disposed || revision != _revision) return;
      assignment = assigned;
      quotation = quoted;
    } catch (_) {
      if (_disposed || revision != _revision) return;
      failed = true;
    }
    busy = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _revision++;
    super.dispose();
  }
}
