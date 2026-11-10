import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../hotel_booking/domain/entities/hotel_models.dart';
import '../../../hotel_booking/presentation/providers/hotel_booking_providers.dart';

class HomeFeaturedHotels {
  const HomeFeaturedHotels({required this.criteria, required this.hotels});

  final HotelSearchCriteria criteria;
  final List<HotelSummary> hotels;
}

final homeFeaturedHotelsProvider =
    FutureProvider.autoDispose<HomeFeaturedHotels>((ref) async {
      final languageCode = ref.watch(hotelLocaleLanguageCodeProvider);
      final criteria = HotelSearchCriteria.initial(
        DateTime.now(),
      ).copyWith(stayBenefit: true);
      final search = ref.watch(searchHotelsUseCaseProvider);
      final hotels = <String, HotelSummary>{};
      const limit = 20;
      var disposed = false;
      ref.onDispose(() => disposed = true);
      for (var page = 1; !disposed; page++) {
        final result = await search(
          criteria: criteria,
          languageCode: languageCode,
          page: page,
          limit: limit,
        );
        for (final hotel in result.hotels) {
          if (hotel.id.isNotEmpty &&
              hotel.stayBenefitParticipate &&
              hotel.isBookable &&
              (hotel.remainingRooms ?? 1) > 0 &&
              hotel.startingPoints != null) {
            hotels.putIfAbsent(hotel.id, () => hotel);
            if (hotels.length == 4) break;
          }
        }
        if (hotels.length == 4 ||
            result.hotels.isEmpty ||
            page * limit >= result.totalCount) {
          break;
        }
      }
      return HomeFeaturedHotels(
        criteria: criteria,
        hotels: hotels.values.toList(growable: false),
      );
    });
