import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_detail_route_args.dart';

enum HotelQuoteStage { idle, assigning, quoting }

enum HotelQuoteIssue { missingOccupancy, missingPoints }

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
  HotelQuoteStage stage = HotelQuoteStage.idle;
  HotelQuoteStage? failedStage;
  Object? error;
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
      ? (quotation != null
            ? quotation!.pointsRequired
            : assignment?.pointsRequired)
      : assignment?.price;

  int? remainingAllowance(int? limit) =>
      limit == null ? null : math.max(0, limit - roomCount);

  int? additionalRooms(int index, {int? roomLimit}) {
    final stock = detail.roomPlans[index].remainingRooms;
    final allowance = remainingAllowance(roomLimit);
    if (stock == null || stock < 0) return allowance;
    final left = math.max(0, stock - (quantities[index] ?? 0));
    return allowance == null ? left : math.min(left, allowance);
  }

  // Reference miles only guide the next increment while a quote is unavailable.
  // The booking total always comes from the assignment/quote.
  num? milesShortfall(int index, num? balance, {int count = 1}) {
    final price = detail.roomPlans[index].pointsRequired;
    if (mode != HotelBookingMode.hostMiles ||
        balance == null ||
        price == null) {
      return null;
    }
    final used =
        amount ??
        selections.fold<num>(
          0,
          (total, selected) =>
              total + (selected.room.pointsRequired ?? 0) * selected.quantity,
        );
    return math.max(0, price * count - math.max(0, balance - used));
  }

  bool canAdd(int index, {int? roomLimit, num? balance, int count = 1}) {
    final room = detail.roomPlans[index];
    final left = additionalRooms(index, roomLimit: roomLimit);
    return !busy &&
        detail.isBookable &&
        (mode != HotelBookingMode.hostMiles || room.pointsRequired != null) &&
        (room.minimumStayNights == null ||
            criteria.nights >= room.minimumStayNights!) &&
        (left == null || count <= left) &&
        (milesShortfall(index, balance, count: count) ?? 0) == 0;
  }

  Future<void> change(
    int index,
    int quantity, {
    int? roomLimit,
    num? balance,
  }) async {
    if (busy || quantity < 0 || index < 0 || index >= detail.roomPlans.length) {
      return;
    }
    final delta = quantity - (quantities[index] ?? 0);
    if (delta > 0 &&
        !canAdd(index, roomLimit: roomLimit, balance: balance, count: delta)) {
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
    failedStage = null;
    error = null;
    stage = HotelQuoteStage.idle;
    final selected = selections;
    if (selected.isEmpty) {
      notifyListeners();
      return;
    }
    busy = true;
    stage = HotelQuoteStage.assigning;
    notifyListeners();
    try {
      final assigned = await assign(selected);
      if (_disposed || revision != _revision) return;
      HotelBookingQuote? quoted;
      if (mode == HotelBookingMode.hostMiles) {
        if (assigned.roomTypeCustNums.isEmpty) {
          throw HotelQuoteIssue.missingOccupancy;
        }
        assignment = assigned;
        stage = HotelQuoteStage.quoting;
        notifyListeners();
        quoted = await quote(
          HotelBookingQuoteRequest(
            stayBenefit: true,
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
      if (mode == HotelBookingMode.hostMiles &&
          quoted?.pointsRequired == null) {
        throw HotelQuoteIssue.missingPoints;
      }
      assignment = assigned;
      quotation = quoted;
    } catch (cause) {
      if (_disposed || revision != _revision) return;
      assignment = null;
      quotation = null;
      failed = true;
      failedStage = stage;
      error = cause;
    }
    stage = HotelQuoteStage.idle;
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
