import '../../domain/entities/hotel_models.dart';

List<HotelRoomGuestFormTarget> buildHotelRoomGuestTargets(
  HotelBookingConfirmSeed seed,
) {
  if (!seed.usesRoomPlanSelection && !seed.hostMiles) {
    final room = seed.selectedRooms.isEmpty
        ? HotelRoomPlan(
            id: seed.detail.id,
            name: seed.detail.name,
            price: seed.detail.entirePrice ?? seed.detail.lowestRoomPrice,
            beforeDiscountPrice: null,
            discount: null,
            discountName: '',
            occupancy: seed.criteria.occupancy + seed.criteria.kids,
            baseOccupancy: seed.criteria.occupancy,
            roomSize: '',
            bedroomCount: null,
            bathroomCount: null,
            remainingRooms: 1,
            minimumStayNights: null,
            description: seed.detail.description,
            facilityCategories: const <HotelRoomFacilityCategory>[],
            images: seed.detail.images,
            beds: const <HotelRoomBed>[],
            adultCapacity: seed.criteria.occupancy,
            childCapacity: seed.criteria.kids,
          )
        : seed.selectedRooms.first.room;
    return <HotelRoomGuestFormTarget>[
      HotelRoomGuestFormTarget(
        room: room,
        instanceNumber: 1,
        initialAdults: seed.criteria.occupancy,
        initialKids: seed.criteria.kids,
        maxGuests: null,
        maxAdults: null,
        maxKids: null,
      ),
    ];
  }

  final maxAdultsByRoom = <int?>[
    for (final selection in seed.selectedRooms)
      for (var index = 0; index < selection.quantity; index += 1)
        selection.room.adultCapacity ?? selection.room.occupancy,
  ];
  final initialAdultsByRoom = _distributeInitialRoomAdults(
    totalAdults: seed.criteria.occupancy,
    maxAdultsByRoom: maxAdultsByRoom,
  );

  final targets = <HotelRoomGuestFormTarget>[];
  var targetIndex = 0;
  var remainingKids = seed.criteria.kids;
  final assignedAdults = <String, List<int>>{};
  for (final row in seed.roomTypeCustNums) {
    assignedAdults.putIfAbsent(row.roomTypeId, () => []).add(row.occupancy);
  }
  for (final selection in seed.selectedRooms) {
    for (var index = 0; index < selection.quantity; index += 1) {
      final maxGuests = selection.room.occupancy;
      final maxAdults = selection.room.adultCapacity ?? maxGuests;
      final maxKids = selection.room.childCapacity;
      final assignments = assignedAdults[selection.room.id];
      final initialAdults =
          seed.hostMiles && assignments != null && assignments.isNotEmpty
          ? assignments.removeAt(0)
          : targetIndex < initialAdultsByRoom.length
          ? initialAdultsByRoom[targetIndex]
          : 1;
      final initialKids = seed.hostMiles
          ? remainingKids.clamp(
              0,
              maxKids != null && maxKids > 0
                  ? maxKids
                  : maxAdults ?? remainingKids,
            )
          : 0;
      remainingKids -= initialKids;
      targetIndex += 1;
      targets.add(
        HotelRoomGuestFormTarget(
          room: selection.room,
          instanceNumber: index + 1,
          initialAdults: initialAdults,
          initialKids: initialKids,
          maxGuests: maxGuests,
          maxAdults: maxAdults,
          maxKids: maxKids,
        ),
      );
    }
  }
  return targets;
}

List<int> _distributeInitialRoomAdults({
  required int totalAdults,
  required List<int?> maxAdultsByRoom,
}) {
  if (maxAdultsByRoom.isEmpty) {
    return const <int>[];
  }

  final allocations = List<int>.filled(maxAdultsByRoom.length, 1);
  var remainingAdults = totalAdults - maxAdultsByRoom.length;
  if (remainingAdults <= 0) {
    return allocations;
  }

  var cursor = 0;
  var skippedInCycle = 0;
  while (remainingAdults > 0 && skippedInCycle < allocations.length) {
    final configuredMaxAdults = maxAdultsByRoom[cursor];
    final maxAdults = configuredMaxAdults != null && configuredMaxAdults > 0
        ? configuredMaxAdults
        : 99;
    if (allocations[cursor] < maxAdults) {
      allocations[cursor] += 1;
      remainingAdults -= 1;
      skippedInCycle = 0;
    } else {
      skippedInCycle += 1;
    }
    cursor = (cursor + 1) % allocations.length;
  }
  return allocations;
}

class HotelRoomGuestFormTarget {
  const HotelRoomGuestFormTarget({
    required this.room,
    required this.instanceNumber,
    required this.initialAdults,
    required this.initialKids,
    required this.maxGuests,
    required this.maxAdults,
    required this.maxKids,
  });

  final HotelRoomPlan room;
  final int instanceNumber;
  final int initialAdults;
  final int initialKids;
  final int? maxGuests;
  final int? maxAdults;
  final int? maxKids;
}
