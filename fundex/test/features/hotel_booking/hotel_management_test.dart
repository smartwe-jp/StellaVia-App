import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:fundex/features/host_miles/domain/entities/host_miles_models.dart';
import 'package:fundex/features/host_miles/domain/repositories/host_miles_repository.dart';
import 'package:fundex/features/host_miles/presentation/providers/host_miles_providers.dart';
import 'package:fundex/features/hotel_booking/presentation/providers/hotel_management_providers.dart';
import 'package:fundex/features/hotel_booking/presentation/pages/hotel_management_page.dart';

class FakeMiles extends HostMilesRepository {
  var calls = 0;
  var fail = false;
  @override
  Future<HostMilesTier> fetchTier() async {
    calls++;
    if (fail) throw StateError('offline');
    return HostMilesTier(currentBookingRooms: calls, maxRooms: 3);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final account = StateProvider<(String?, int?, String)?>((ref) => null);
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json')) as List;
    for (final e in manifest) {
      final loader = FontLoader(e['family'] as String);
      for (final f in e['fonts']) {
        loader.addFont(rootBundle.load(f['asset'] as String));
      }
      await loader.load();
    }
  });
  test(
    'private tier data stays isolated and cached after transient failure',
    () async {
      final fake = FakeMiles();
      final c = ProviderContainer(
        overrides: [
          hotelManagementIdentityProvider.overrideWith(
            (ref) => ref.watch(account),
          ),
          hostMilesRepositoryProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(c.dispose);
      c.listen(hotelManagementTierProvider, (_, __) {});
      await Future<void>.delayed(Duration.zero);
      expect(fake.calls, 0);
      c.read(account.notifier).state = ('A', 1, 'A');
      c.read(hotelManagementTierProvider);
      await c.read(hotelManagementTierResourceProvider(('A', 1, 'A')).future);
      expect(
        c.read(hotelManagementTierProvider).valueOrNull?.currentBookingRooms,
        1,
      );
      fake.fail = true;
      c.invalidate(hotelManagementTierResourceProvider(('A', 1, 'A')));
      await expectLater(
        c.read(hotelManagementTierResourceProvider(('A', 1, 'A')).future),
        throwsStateError,
      );
      expect(
        c.read(hotelManagementTierProvider).valueOrNull?.currentBookingRooms,
        1,
      );
      c.read(account.notifier).state = ('B', 2, 'B');
      expect(c.read(hotelManagementTierProvider).valueOrNull, isNull);
      c.read(account.notifier).state = null;
      expect(c.read(hotelManagementTierProvider).valueOrNull, isNull);
    },
  );
  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('management layout and all entries $locale', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final key = GlobalKey();
      final destinations = [
        '/bookings/history',
        '/hotel-booking/check-in',
        '/hotel-booking/coupons',
        '/hotel-booking/contacts',
        '/hotel-booking/host-miles',
      ];
      final router = GoRouter(
        initialLocation: '/bookings',
        routes: [
          GoRoute(
            path: '/bookings',
            builder: (_, __) => const HotelManagementPage(),
          ),
          for (final path in destinations)
            GoRoute(
              path: path,
              builder: (_, __) => Scaffold(body: Text(path)),
            ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            hotelManagementIdentityProvider.overrideWith((ref) => null),
            hotelManagementTierProvider.overrideWith(
              (ref) => const AsyncData(
                HostMilesTier(currentBookingRooms: 1, maxRooms: 3),
              ),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            locale: locale,
            theme: AppThemeFactory.light(locale: locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) =>
                RepaintBoundary(key: key, child: child!),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final l = AppLocalizations.of(
        tester.element(find.byType(HotelManagementPage)),
      );
      final labels = [
        l.hotelQuickActionOrders,
        l.hotelQuickActionCheckIn,
        l.hotelQuickActionCoupons,
        l.hotelQuickActionContacts,
        l.hotelManagementNextTrip,
      ];
      if (locale.languageCode == 'ja') {
        await tester.runAsync(() async {
          final img =
              await (key.currentContext!.findRenderObject()!
                      as RenderRepaintBoundary)
                  .toImage();
          final data = await img.toByteData(format: ui.ImageByteFormat.png);
          await File(
            '/tmp/hotel-management.png',
          ).writeAsBytes(data!.buffer.asUint8List());
          img.dispose();
        });
      }
      for (var i = 0; i < labels.length; i++) {
        await tester.tap(find.text(labels[i]));
        await tester.pumpAndSettle();
        expect(router.routerDelegate.state.uri.path, destinations[i]);
        router.pop();
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
    });
  }
}
