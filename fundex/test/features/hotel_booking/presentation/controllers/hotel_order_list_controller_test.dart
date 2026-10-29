import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/auth/domain/entities/auth_user.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';
import 'package:fundex/features/hotel_booking/domain/repositories/hotel_booking_repository.dart';
import 'package:fundex/features/hotel_booking/domain/usecases/fetch_hotel_order_list_usecase.dart';
import 'package:fundex/features/hotel_booking/presentation/controllers/hotel_order_list_controller.dart';
import 'package:fundex/features/hotel_booking/presentation/providers/hotel_booking_providers.dart';

class OrdersFake implements HotelBookingRepository {
  final requests = <Completer<HotelOrderListResult>>[];
  @override
  Future<HotelOrderListResult> fetchOrderList({
    required String languageCode,
    required HotelOrderStatusFilter status,
    int page = 1,
    int limit = 5,
  }) {
    final p = Completer<HotelOrderListResult>();
    requests.add(p);
    return p.future;
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

HotelOrderListResult result(int count) => HotelOrderListResult(
  orders: const [],
  totalCount: count,
  page: 1,
  limit: 5,
);
final signedIn = StateProvider<bool>((ref) => false);
final identity = StateProvider<String>((ref) => 'A');
Future<void> flush() => Future<void>.delayed(Duration.zero);
void main() {
  test(
    'new refresh supersedes late result and disposal ignores outstanding orders',
    () async {
      final fake = OrdersFake();
      final c = HotelOrderListController(
        fetchOrderList: FetchHotelOrderListUseCase(fake),
        languageCode: 'JP',
      );
      final latest = c.refresh();
      fake.requests[1].complete(result(8));
      await latest;
      fake.requests[0].complete(result(99));
      await flush();
      expect(c.state.totalCount, 8);
      final late = c.refresh();
      c.dispose();
      fake.requests.last.complete(result(42));
      await late;
    },
  );
  test(
    'root-tab cache clears on account switch and does not request as guest',
    () async {
      final fake = OrdersFake();
      final c = ProviderContainer(
        overrides: [
          isAuthenticatedProvider.overrideWith(
            (ref) => AsyncData(ref.watch(signedIn)),
          ),
          currentAuthUserProvider.overrideWith(
            (ref) async => AuthUser(username: ref.watch(identity)),
          ),
          fetchHotelOrderListUseCaseProvider.overrideWithValue(
            FetchHotelOrderListUseCase(fake),
          ),
          hotelLocaleLanguageCodeProvider.overrideWithValue('JP'),
        ],
      );
      addTearDown(c.dispose);
      c.listen(hotelOrderListControllerProvider, (_, __) {});
      await flush();
      expect(fake.requests, isEmpty);
      c.read(signedIn.notifier).state = true;
      await flush();
      await flush();
      fake.requests.single.complete(result(5));
      await flush();
      expect(c.read(hotelOrderListControllerProvider).totalCount, 5);
      final old = c.read(hotelOrderListControllerProvider.notifier);
      c.read(identity.notifier).state = 'B';
      await flush();
      await flush();
      expect(old.mounted, false);
      expect(c.read(hotelOrderListControllerProvider).totalCount, 0);
      c.read(signedIn.notifier).state = false;
      await flush();
      fake.requests.last.complete(result(20));
      await flush();
      expect(c.read(hotelOrderListControllerProvider).totalCount, 0);
    },
  );
}
