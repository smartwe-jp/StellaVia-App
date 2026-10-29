import 'package:fundex/features/auth/domain/entities/auth_user.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:fundex/features/host_miles/presentation/providers/host_miles_providers.dart';
import 'package:fundex/features/hotel_booking/presentation/providers/hotel_host_miles_provider.dart';
import 'package:fundex/features/hotel_booking/presentation/providers/hotel_booking_providers.dart';
import 'package:fundex/features/hotel_booking/domain/usecases/search_hotels_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';
import '../../hotel_host_miles_fakes.dart';

final loggedIn = StateProvider<bool>((ref) => false);
final identity = StateProvider<String>((ref) => 'A');
Future<void> flush() => Future<void>.delayed(Duration.zero);
void main() {
  test('provider clears membership when session changes', () async {
    final m = MilesFake();
    final container = ProviderContainer(
      overrides: [
        isAuthenticatedProvider.overrideWith(
          (ref) => AsyncData(ref.watch(loggedIn)),
        ),
        currentAuthUserProvider.overrideWith(
          (ref) async => AuthUser(username: ref.watch(identity)),
        ),
        hostMilesRepositoryProvider.overrideWithValue(m),
        searchHotelsUseCaseProvider.overrideWithValue(
          SearchHotelsUseCase(HotelsFake()),
        ),
        hotelLocaleLanguageCodeProvider.overrideWithValue('JP'),
      ],
    );
    addTearDown(container.dispose);
    container.listen(hotelHostMilesProvider, (_, __) {});
    await flush();
    await flush();
    expect(m.calls, 0);
    container.read(loggedIn.notifier).state = true;
    await flush();
    await flush();
    expect(
      container
          .read(hotelHostMilesProvider)
          .account
          .valueOrNull
          ?.availablePoints,
      23456,
    );
    final previous = container.read(hotelHostMilesProvider.notifier);
    container.read(identity.notifier).state = 'B';
    await flush();
    await flush();
    expect(
      identical(previous, container.read(hotelHostMilesProvider.notifier)),
      false,
    );
    expect(previous.mounted, false);
    container.read(loggedIn.notifier).state = false;
    await flush();
    expect(container.read(hotelHostMilesProvider).account.valueOrNull, isNull);
  });
  test(
    'real membership, multi-night search, pagination, refresh failure keeps data',
    () async {
      final h = HotelsFake();
      final m = MilesFake();
      final c = milesController(h, m);
      addTearDown(c.dispose);
      await c.refresh();
      expect(c.state.account.valueOrNull?.availablePoints, 23456);
      expect(c.state.tier.valueOrNull?.remainingBookingRooms, 3);
      expect(h.criteria.single.stayBenefit, true);
      await c.applyCriteria(
        c.state.hotels.criteria.copyWith(
          area: 'kyoto',
          checkOutDate: DateTime(2026, 11, 4),
          stayBenefit: false,
        ),
      );
      expect(h.criteria.last.nights, 3);
      expect(h.criteria.last.stayBenefit, true);
      await c.loadMore();
      expect(h.pages.last, 2);
      expect(c.state.hotels.hasMore, false);
      h.fail = true;
      m.fail = true;
      await c.refresh();
      expect(c.state.hotels.hotels.single.id, 'live-42');
      expect(c.state.hotels.error, isNotNull);
      expect(c.state.account.valueOrNull?.availablePoints, 23456);
      expect(c.state.account.hasError, true);
      expect(c.state.tier.hasError, false);
    },
  );
  test(
    'guest skips private endpoints; late queries and disposed results are ignored',
    () async {
      final h = HotelsFake()..deferred = true;
      final m = MilesFake();
      final c = milesController(h, m, member: false);
      final first = c.refresh();
      final second = c.applyCriteria(
        c.state.hotels.criteria.copyWith(area: 'kyoto'),
      );
      h.pending[1].complete(const HotelSearchResult(hotels: [], totalCount: 0));
      await second;
      h.pending[0].complete(
        const HotelSearchResult(hotels: [liveHotel], totalCount: 1),
      );
      await first;
      expect(c.state.hotels.hotels, isEmpty);
      expect(m.calls, 0);
      final late = c.refresh();
      c.dispose();
      h.pending[2].complete(
        const HotelSearchResult(hotels: [liveHotel], totalCount: 1),
      );
      await late;
    },
  );
}
