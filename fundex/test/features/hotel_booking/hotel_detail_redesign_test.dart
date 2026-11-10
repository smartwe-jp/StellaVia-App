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
HotelRoomPlan room({int stock = 2, int minStay = 1, num? points = 6000}) =>
    HotelRoomPlan(
      pointsRequired: points,
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
HotelDetail detail({int stock = 2, int minStay = 1, num? points = 6000}) =>
    HotelDetail(
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
      detailText: '<p>町家を一棟から予約できます。庭を望む和室があります。</p>',
      surroundingText: '',
      travelText: '',
      checkInGuide: '',
      ruleText: '',
      refundPolicyText: 'API cancellation policy',
      telNo: '',
      facilities: [],
      images: [],
      roomPlans: [room(stock: stock, minStay: minStay, points: points)],
      tags: ['京都'],
      priceCalendarByDate: {},
    );
const assigned = HotelAssignOccupancyResult(
  pointsRequired: 7200,
  price: 18000,
  message: '',
  roomTypeCustNums: [
    HotelRoomOccupancyAssignment(roomTypeId: '1', occupancy: 2),
  ],
  roomTypeExtraGuestPrices: [],
);
HotelBookingQuote quote([num? points = 8500]) => HotelBookingQuote(
  pointsRequired: points,
  pointTotal: 999999,
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
  for (final locale in [
    const Locale('zh'),
    const Locale('ja'),
    const Locale('en'),
    const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ]) {
    testWidgets('extra guest miles are reference only: $locale', (
      tester,
    ) async {
      final c = controller(
        mode: HotelBookingMode.hostMiles,
        assign: (_) async => const HotelAssignOccupancyResult(
          pointsRequired: 7200,
          price: 18000,
          message: '',
          roomTypeCustNums: [
            HotelRoomOccupancyAssignment(roomTypeId: '1', occupancy: 3),
          ],
          roomTypeExtraGuestPrices: [
            HotelRoomTypeExtraGuestPrice(
              roomTypeId: '1',
              roomTypeName: 'Room A',
              roomCount: 2,
              totalGuestCount: 6,
              extraGuestCount: 2,
              extraGuestPrice: 9999,
              extraGuestPoints: 1200,
            ),
            HotelRoomTypeExtraGuestPrice(
              roomTypeId: '2',
              roomTypeName: 'Room B',
              roomCount: 1,
              totalGuestCount: 3,
              extraGuestCount: 1,
              extraGuestPrice: 8888,
            ),
            HotelRoomTypeExtraGuestPrice(
              roomTypeId: '3',
              roomTypeName: 'Room C',
              roomCount: 1,
              totalGuestCount: 2,
              extraGuestCount: 0,
              extraGuestPrice: 0,
              extraGuestPoints: 0,
            ),
          ],
        ),
      );
      addTearDown(c.dispose);
      await c.change(0, 1);
      expect(c.amount, 8500);
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppThemeFactory.light(locale: locale),
          home: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: 320,
                child: HotelDetailSelectionSummary(selection: c),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l = AppLocalizations.of(
        tester.element(find.byType(HotelDetailSelectionSummary)),
      );
      expect(find.text('1,200 ${l.myPageChartMileUnit}'), findsOneWidget);
      expect(find.text('8,500 ${l.myPageChartMileUnit}'), findsOneWidget);
      expect(find.text('0 ${l.myPageChartMileUnit}'), findsOneWidget);
      expect(find.text('Room B'), findsOneWidget);
      expect(find.textContaining('9,999'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  test('missing reference points block miles only; zero is valid', () async {
    final miles = controller(
      mode: HotelBookingMode.hostMiles,
      hotel: detail(points: null),
    );
    final cash = controller(hotel: detail(points: null));
    final zero = controller(
      mode: HotelBookingMode.hostMiles,
      hotel: detail(points: 0),
    );
    addTearDown(miles.dispose);
    addTearDown(cash.dispose);
    addTearDown(zero.dispose);
    expect(miles.canAdd(0), false);
    await miles.change(0, 1);
    expect(miles.roomCount, 0);
    expect(cash.canAdd(0), true);
    expect(zero.canAdd(0), true);
  });
  test('detail cache separates cash and miles requests', () {
    final regular = HotelDetailQuery(hotelId: '1', criteria: criteria);
    final miles = HotelDetailQuery(
      hotelId: '1',
      criteria: criteria.copyWith(stayBenefit: true),
    );
    expect(regular, isNot(miles));
  });

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
      expect(request!.stayBenefit, true);
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
      expect(c.failed, isTrue);
      expect(c.error, HotelQuoteIssue.missingPoints);
      expect(c.failedStage, HotelQuoteStage.quoting);
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
  test(
    'actual quote stages, retry and removal never use reference totals',
    () async {
      final assignment = Completer<HotelAssignOccupancyResult>();
      final response = Completer<HotelBookingQuote>();
      var retries = 0;
      final c = controller(
        mode: HotelBookingMode.hostMiles,
        assign: (_) => assignment.future,
        getQuote: (_) =>
            retries++ == 0 ? response.future : Future.value(quote(9123)),
      );
      addTearDown(c.dispose);
      final task = c.change(0, 1);
      expect(c.stage, HotelQuoteStage.assigning);
      expect(c.amount, isNull);
      assignment.complete(assigned);
      await Future<void>.delayed(Duration.zero);
      expect(c.stage, HotelQuoteStage.quoting);
      expect(c.amount, 7200);
      response.completeError(StateError('quote error'));
      await task;
      expect(c.failedStage, HotelQuoteStage.quoting);
      expect(c.amount, isNull);
      await c.refreshQuote();
      expect(c.failed, false);
      expect(c.amount, 9123);
      await c.change(0, 0);
      expect(c.amount, isNull);
      expect(c.failed, false);
    },
  );
  testWidgets('detail navigation hides while reservation panel stays fixed', (
    tester,
  ) async {
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
    final panel = find.byType(HotelDetailReservationPanel);
    final panelRect = tester.getRect(panel);
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
    expect(
      tester
          .widget<AppScrollNavigationBar>(find.byType(AppScrollNavigationBar))
          .preferredSize
          .height,
      0,
    );
    expect(tester.getSize(navigation).height, originalHeight);
    expect(tester.getRect(panel), panelRect);
    await tester.drag(scrollable, const Offset(0, 200));
    await tester.pumpAndSettle();
    expect(chrome.value, 1);
    expect(tester.getRect(panel), panelRect);
    expect(tester.takeException(), isNull);
  });
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
      expect(find.text(l.hotelDetailAvailableRooms), findsOneWidget);
      expect(find.text(l.hotelDetailRoomsHeading), findsNothing);
      expect(find.text(l.hotelGuestFieldLabel), findsOneWidget);
      expect(
        find.text(l.hotelSearchGuestCounts(criteria.occupancy, criteria.kids)),
        findsOneWidget,
      );
      expect(
        tester.getTopLeft(find.text(l.hotelDetailStayDateLabel)).dy,
        greaterThan(tester.getBottomLeft(find.text(c.detail.name)).dy),
      );
      expect(
        tester.getBottomLeft(find.text(l.hotelDetailStayDateLabel)).dy,
        lessThan(tester.getTopLeft(find.text(l.hotelDetailAvailableRooms)).dy),
      );
      expect(
        find.textContaining('町家を一棟から予約できます。', findRichText: true),
        findsOneWidget,
      );
      expect(find.text(c.detail.description), findsNothing);
      expect(find.text('町家を一棟から予約できます。庭を望む和室があります。'), findsNothing);
      final detailsButton = find.text(l.hotelFeatureDetailsLink);
      await tester.ensureVisible(detailsButton);
      await tester.tap(detailsButton);
      await tester.pumpAndSettle();
      expect(find.text('町家を一棟から予約できます。庭を望む和室があります。'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.text(c.detail.name),
        ),
        findsOneWidget,
      );
      await tester.tap(find.byType(CloseButton));
      await tester.pumpAndSettle();
      expect(find.text('町家を一棟から予約できます。庭を望む和室があります。'), findsNothing);
      expect(find.text(l.hotelMilesBookingPending), findsNothing);
      final milesButton = find.widgetWithText(
        AppButton,
        l.hotelDetailMilesPending,
      );
      expect(tester.widget<AppButton>(milesButton).onPressed, isNull);
      expect(find.text(l.hotelDetailProceed), findsNothing);
      await tester.scrollUntilVisible(
        find.byType(HotelDetailRoomCard),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text(l.hotelMilesReferenceStay('6,000')), findsOneWidget);
      final card = find.byType(HotelDetailRoomCard).first;
      final stock = find.descendant(
        of: card,
        matching: find.text(l.hotelDetailRemainingRoomsShort(2)),
      );
      final plus = find.descendant(
        of: card,
        matching: find.byTooltip(l.hotelDetailIncreaseRoom),
      );
      expect(tester.getCenter(stock).dy, closeTo(tester.getCenter(plus).dy, 1));
      expect(
        tester.getTopRight(stock).dx,
        lessThan(tester.getTopLeft(plus).dx),
      );
      expect(
        tester
            .getSize(
              find
                  .descendant(of: card, matching: find.byType(AppRemoteImage))
                  .first,
            )
            .height,
        143,
      );

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
      expect(find.text('3,500 ${l.myPageChartMileUnit}'), findsOneWidget);
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
