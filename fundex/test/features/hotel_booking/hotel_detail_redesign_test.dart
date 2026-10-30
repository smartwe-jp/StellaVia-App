import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundex/features/hotel_booking/presentation/pages/hotel_detail_page.dart';
import 'package:fundex/features/hotel_booking/presentation/providers/hotel_booking_providers.dart';
import 'package:fundex/features/hotel_booking/presentation/providers/hotel_management_providers.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';
import 'package:fundex/features/hotel_booking/presentation/controllers/hotel_detail_selection_controller.dart';
import 'package:fundex/features/hotel_booking/presentation/support/hotel_detail_route_args.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_detail_redesign_content.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_detail_room_card.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_detail_selection_summary.dart';
import 'package:fundex/features/host_miles/domain/entities/host_miles_models.dart';
import 'package:intl/date_symbol_data_local.dart';

final criteria = HotelSearchCriteria.initial(
  DateTime(2026, 10, 30),
).copyWith(checkOutDate: DateTime(2026, 11, 2));
HotelRoomPlan room({int stock = 2, int minStay = 1}) => HotelRoomPlan(
  id: '1',
  name: '庭を望む和室（竹）',
  price: 18000,
  beforeDiscountPrice: null,
  discount: null,
  discountName: '',
  occupancy: 2,
  adultCapacity: 2,
  childCapacity: 1,
  baseOccupancy: 2,
  roomSize: '28',
  bedroomCount: 1,
  bathroomCount: 1,
  remainingRooms: stock,
  minimumStayNights: minStay,
  description: '',
  facilityCategories: [],
  images: [],
  beds: [],
);
HotelDetail detail({int stock = 2, int minStay = 1}) => HotelDetail(
  id: '1',
  name: '嵐山旅館',
  address: '',
  description: '京都・嵐山の自然に包まれた、心ほどける滞在。',
  latitude: null,
  longitude: null,
  bookingType: 0,
  buildingTypeStr: '',
  isBookable: true,
  entirePrice: null,
  checkInMessage: '',
  checkInTime: '15:00',
  checkOutTime: '11:00',
  detailText: '',
  surroundingText: '',
  travelText: '',
  checkInGuide: '',
  ruleText: '',
  refundPolicyText: 'API cancellation policy',
  telNo: '',
  facilities: [],
  images: [],
  roomPlans: [room(stock: stock, minStay: minStay)],
  tags: ['京都'],
  priceCalendarByDate: {},
);
const assigned = HotelAssignOccupancyResult(
  price: 18000,
  message: '',
  roomTypeCustNums: [
    HotelRoomOccupancyAssignment(roomTypeId: '1', occupancy: 2),
  ],
  roomTypeExtraGuestPrices: [],
);
HotelBookingQuote quote([num? points = 8500]) => HotelBookingQuote(
  pointTotal: points,
  quotedPrice: 18000,
  originalPrice: 18000,
  roomPriceElements: [],
);
HotelDetailSelectionController controller({
  HotelBookingMode mode = HotelBookingMode.regular,
  HotelDetail? hotel,
  Future<HotelAssignOccupancyResult> Function(List<HotelSelectedRoom>)? assign,
  Future<HotelBookingQuote> Function(HotelBookingQuoteRequest)? getQuote,
}) => HotelDetailSelectionController(
  detail: hotel ?? detail(),
  criteria: criteria,
  mode: mode,
  languageCode: 'JP',
  assign: assign ?? (_) async => assigned,
  quote: getQuote ?? (_) async => quote(),
);

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting();
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
  test('regular quotes money and does not request host miles', () async {
    final c = controller(
      getQuote: (_) => throw StateError('should not quote miles'),
    );
    addTearDown(c.dispose);
    await c.change(0, 1);
    expect(c.amount, 18000);
    expect(c.quotation, isNull);
    await c.change(0, 0);
    expect(c.amount, isNull);
    expect(c.roomCount, 0);
  });
  test(
    'host miles quote uses assigned occupancy, dates and no legacy coupons',
    () async {
      HotelBookingQuoteRequest? request;
      final c = controller(
        mode: HotelBookingMode.hostMiles,
        getQuote: (r) async {
          request = r;
          return quote();
        },
      );
      addTearDown(c.dispose);
      await c.change(0, 1);
      expect(c.amount, 8500);
      expect(request!.rooms.single.occupancy, 2);
      expect(request!.coupons, isEmpty);
      expect(request!.checkOut, criteria.checkOutDate);
      expect(request!.selectedRooms.single.quantity, 1);
    },
  );
  test(
    'null points remains unknown and failed refresh cannot retain old quote',
    () async {
      var fail = false;
      final c = controller(
        mode: HotelBookingMode.hostMiles,
        getQuote: (_) async {
          if (fail) throw StateError('offline');
          return quote(null);
        },
      );
      addTearDown(c.dispose);
      await c.change(0, 1);
      expect(c.amount, isNull);
      expect(c.failed, isFalse);
      fail = true;
      await c.refreshQuote();
      expect(c.failed, isTrue);
      expect(c.amount, isNull);
      expect(c.assignment, isNull);
    },
  );
  test(
    'inventory, minimum nights and room allowance gate increments but not removal',
    () async {
      final sold = controller(hotel: detail(stock: 0));
      addTearDown(sold.dispose);
      await sold.change(0, 1);
      expect(sold.roomCount, 0);
      final min = controller(hotel: detail(minStay: 9));
      addTearDown(min.dispose);
      expect(min.canAdd(0), isFalse);
      final c = controller(mode: HotelBookingMode.hostMiles);
      addTearDown(c.dispose);
      await c.change(0, 1, roomLimit: 1);
      expect(c.canAdd(0, roomLimit: 1), isFalse);
      await c.change(0, 2, roomLimit: 1);
      expect(c.roomCount, 1);
      await c.change(0, 0, roomLimit: 0);
      expect(c.roomCount, 0);
    },
  );
  test(
    'discard in-flight assignment when date/account session is disposed',
    () async {
      final pending = Completer<HotelAssignOccupancyResult>();
      var quoted = false;
      final c = controller(
        mode: HotelBookingMode.hostMiles,
        assign: (_) => pending.future,
        getQuote: (_) async {
          quoted = true;
          return quote();
        },
      );
      final operation = c.change(0, 1);
      c.dispose();
      pending.complete(assigned);
      await operation;
      expect(quoted, isFalse);
    },
  );
  testWidgets(
    'detail navigation and reservation bars hide and reveal together',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
      addTearDown(tester.view.resetPadding);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            hotelDetailProvider.overrideWith((ref, query) async => detail()),
            hotelManagementIdentityProvider.overrideWith((ref) => null),
            hotelLocaleLanguageCodeProvider.overrideWithValue('JP'),
          ],
          child: MaterialApp(
            locale: const Locale('ja'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppThemeFactory.light(locale: const Locale('ja')),
            home: HotelDetailPage(
              hotelId: '1',
              initialCriteria: criteria,
              mode: HotelBookingMode.hostMiles,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final chrome = tester
          .widget<AppScrollChromeScope>(find.byType(AppScrollChromeScope))
          .notifier!;
      expect(chrome.value, 1);
      expect(find.byType(AppNavigationBar), findsOneWidget);
      final scrollable = find.byType(ListView).first;
      final navigation = find.byType(AppNavigationBar);
      final originalHeight = tester.getSize(navigation).height;
      final originalY = tester.getTopLeft(navigation).dy;
      expect(originalHeight, 65);
      expect(originalY, 47);
      final gesture = await tester.startGesture(const Offset(195, 420));
      // Inspect live intermediate frames, not just the settled endpoints.
      for (var i = 0; i < 3; i++) {
        await gesture.moveBy(const Offset(0, -20));
        await tester.pump(const Duration(milliseconds: 16));
        expect(tester.getSize(navigation).height, originalHeight);
        expect(tester.takeException(), isNull);
      }
      expect(chrome.value, greaterThan(0));
      expect(chrome.value, lessThan(1));
      expect(tester.getTopLeft(navigation).dy, lessThan(originalY));
      expect(
        tester.getTopLeft(navigation).dy,
        closeTo(originalY - originalHeight * (1 - chrome.value), .01),
      );
      await gesture.up();
      await tester.pumpAndSettle();
      await tester.drag(scrollable, const Offset(0, -350));
      await tester.pumpAndSettle();
      expect(chrome.value, 0);
      final bars = find.byType(AppScrollChromeVisibility);
      expect(
        bars,
        findsOneWidget,
      ); // Bottom panel's implementation is unchanged.
      expect(
        tester
            .widget<AppScrollNavigationBar>(find.byType(AppScrollNavigationBar))
            .preferredSize
            .height,
        0,
      );
      expect(tester.getSize(navigation).height, originalHeight);
      for (final element in bars.evaluate()) {
        expect(tester.getSize(find.byWidget(element.widget)).height, 0);
      }
      await tester.drag(scrollable, const Offset(0, 200));
      await tester.pumpAndSettle();
      expect(chrome.value, 1);
      for (final element in bars.evaluate()) {
        expect(
          tester.getSize(find.byWidget(element.widget)).height,
          greaterThan(0),
        );
      }
      expect(tester.takeException(), isNull);
    },
  );
  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('detail room cards and miles boundary fit mobile $locale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = controller(mode: HotelBookingMode.hostMiles);
      addTearDown(c.dispose);
      await c.change(0, 1);
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppThemeFactory.light(locale: locale),
          home: Scaffold(
            body: RepaintBoundary(
              key: key,
              child: HotelDetailRedesignContent(
                detail: c.detail,
                criteria: criteria,
                selection: c,
                tier: const HostMilesTier(maxRooms: 3, currentBookingRooms: 1),
                account: const HostMilesAccount(availablePoints: 12000),
                onDates: () {},
                onGuests: () {},
                onBook: () => fail('Miles must not enter regular booking'),
                openingConfirmation: false,
                membershipFailed: false,
                onMembershipRetry: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final l = AppLocalizations.of(
        tester.element(find.byType(HotelDetailRedesignContent)),
      );
      expect(
        tester
            .widget<AppButton>(
              find.widgetWithText(AppButton, l.hotelDetailMilesPending),
            )
            .onPressed,
        isNull,
      );
      await tester.scrollUntilVisible(
        find.byType(HotelDetailRoomCard),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      if (locale.languageCode == 'ja' &&
          Platform.environment['DETAIL_CAPTURE'] == '1') {
        await tester.runAsync(() async {
          final img =
              await (key.currentContext!.findRenderObject()
                      as RenderRepaintBoundary)
                  .toImage(pixelRatio: 2);
          final data = await img.toByteData(format: ui.ImageByteFormat.png);
          await File(
            '/tmp/hotel-detail-rooms.png',
          ).writeAsBytes(data!.buffer.asUint8List());
          img.dispose();
        });
      }
      await tester.scrollUntilVisible(
        find.byType(HotelDetailSelectionSummary),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('3,500 mile'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(
        find.text('API cancellation policy'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('API cancellation policy'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
