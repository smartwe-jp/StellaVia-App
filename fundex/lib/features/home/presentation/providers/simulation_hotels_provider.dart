import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../hotel_booking/domain/entities/hotel_models.dart';
import '../../../hotel_booking/domain/usecases/search_points_hotels_usecase.dart';
import '../../../hotel_booking/presentation/providers/hotel_booking_providers.dart';

final simulationHotelsProvider = FutureProvider.autoDispose
    .family<List<PointsHotel>, int>((ref, points) async {
      final search = SearchPointsHotelsUseCase(
        ref.watch(hotelBookingRepositoryProvider),
      );
      var active = true;
      ref.onDispose(() => active = false);
      await Future<void>.delayed(const Duration(milliseconds: 280));
      if (!active) return [];
      return search(points);
    });
