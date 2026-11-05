// Opt-in replay of read-only SIT captures; no booking/payment requests.
// STELLAVIA_LIVE_CAPTURE_DIR points to a directory of stellavia-live-*.json.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundex/features/hotel_booking/presentation/pages/hotel_detail_page.dart';
import 'package:fundex/features/hotel_booking/presentation/providers/hotel_booking_providers.dart';
import 'package:fundex/features/hotel_booking/presentation/providers/hotel_management_providers.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_detail_redesign_content.dart';
import 'package:fundex/features/hotel_booking/presentation/controllers/hotel_detail_selection_controller.dart';
import 'dart:convert';
import 'dart:io';
import 'package:intl/date_symbol_data_local.dart';
import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:fundex/features/hotel_booking/data/repositories/hotel_booking_repository_impl.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';
import 'package:fundex/features/hotel_booking/presentation/support/hotel_booking_presenter.dart';
import 'package:fundex/features/hotel_booking/presentation/support/hotel_detail_route_args.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_home_card.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_detail_room_card.dart';
import 'hotel_reference_points_mapping_test.dart' as mapping;
import 'hotel_detail_redesign_test.dart' as fixtures;

final captureDir = Platform.environment['STELLAVIA_LIVE_CAPTURE_DIR'];
Map<String, dynamic> capture(String name) =>
    jsonDecode(File('$captureDir/stellavia-live-$name.json').readAsStringSync())
        as Map<String, dynamic>;

class CapturedRemote extends mapping.Remote {
  String snapshot = 'one';
  @override
  Future<HotelDetailDto> fetchHotelDetail(HotelDetailRequestDto request) async {
    final response = capture('$snapshot-detail');
    if (response['code'] != 200) throw StateError(response['msg'] as String);
    return HotelDetailDto.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<HotelSearchResultDto> searchHotels(
    HotelSearchRequestDto request,
  ) async => HotelSearchResultDto.fromJson(
    capture('$snapshot-search')['data'] as Map<String, dynamic>,
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
  });
  testWidgets(
    'real detail page replaces session on date changes and restores availability',
    (tester) async {
      final remote = CapturedRemote();
      final repo = HotelBookingRepositoryImpl(remote: remote);
      final container = ProviderContainer(
        overrides: [
          hotelDetailProvider.overrideWith(
            (ref, query) => repo.fetchHotelDetail(
              hotelId: query.hotelId,
              criteria: query.criteria,
              languageCode: 'JP',
            ),
          ),
          hotelManagementIdentityProvider.overrideWith((ref) => null),
          hotelLocaleLanguageCodeProvider.overrideWithValue('JP'),
        ],
      );
      addTearDown(container.dispose);
      HotelDetailSelectionController? previous;
      for (final snapshot in ['one', 'changed', 'one']) {
        remote.snapshot = snapshot;
        final changed = snapshot == 'changed';
        final criteria =
            HotelSearchCriteria.initial(
              DateTime(2026, 11, changed ? 14 : 10),
            ).copyWith(
              checkOutDate: DateTime(2026, 11, changed ? 17 : 11),
              stayBenefit: true,
            );
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              locale: const Locale('ja'),
              theme: AppThemeFactory.light(locale: const Locale('ja')),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: HotelDetailPage(
                hotelId: '1',
                initialCriteria: criteria,
                mode: HotelBookingMode.hostMiles,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final current = tester
            .widget<HotelDetailRedesignContent>(
              find.byType(HotelDetailRedesignContent),
            )
            .selection;
        expect(identical(current, previous), false);
        expect(current.roomCount, 0);
        expect(current.quotation, isNull);
        expect(
          current.detail.roomPlans.first.pointsRequired,
          changed ? 78195 : 25123,
        );
        expect(current.canAdd(0), !changed);
        // Seed a local selection only; do not issue assignment/quote/submission calls.
        if (!changed) current.quantities = {0: 1};
        previous = current;
        expect(tester.takeException(), isNull);
      }
    },
    skip: captureDir == null,
  );
  testWidgets(
    'SIT captured values render and date changes replace availability',
    (tester) async {
      final remote = CapturedRemote();
      final repo = HotelBookingRepositoryImpl(remote: remote);
      final cases = [
        (
          'one',
          '1',
          DateTime(2026, 11, 10),
          DateTime(2026, 11, 11),
          25123,
          true,
        ),
        (
          'changed',
          '1',
          DateTime(2026, 11, 14),
          DateTime(2026, 11, 17),
          78195,
          false,
        ),
        (
          'ineligible',
          '35',
          DateTime(2026, 11, 10),
          DateTime(2026, 11, 13),
          null,
          false,
        ),
        (
          'one',
          '1',
          DateTime(2026, 11, 10),
          DateTime(2026, 11, 11),
          25123,
          true,
        ),
      ];
      for (final c in cases) {
        remote.snapshot = c.$1;
        final criteria = HotelSearchCriteria.initial(
          c.$3,
        ).copyWith(checkOutDate: c.$4, stayBenefit: true);
        final hotels = await repo.searchHotels(
          criteria: criteria,
          languageCode: 'JP',
        );
        final hotel = hotels.hotels.firstWhere((h) => h.id == c.$2);
        final detail = await repo.fetchHotelDetail(
          hotelId: c.$2,
          criteria: criteria,
          languageCode: 'JP',
        );
        expect(hotel.startingPoints, c.$5);
        expect(detail.roomPlans.first.pointsRequired, c.$5);
        final selection = fixtures.controller(
          mode: HotelBookingMode.hostMiles,
          hotel: detail,
        );
        expect(selection.canAdd(0), c.$6);
        expect(selection.roomCount, 0);
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('ja'),
            theme: AppThemeFactory.light(locale: const Locale('ja')),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    HotelHomeCard(
                      hotel: hotel,
                      presenter: HotelBookingPresenter('ja'),
                      hostMilesMode: true,
                    ),
                    HotelDetailRoomCard(
                      room: detail.roomPlans.first,
                      quantity: 0,
                      nights: criteria.nights,
                      miles: true,
                      onDetails: () {},
                      onMinus: null,
                      onPlus: selection.canAdd(0) ? () {} : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final l = AppLocalizations.of(
          tester.element(find.byType(HotelHomeCard)),
        );
        if (c.$5 == null) {
          expect(
            find.text(l.hotelStayBenefitUnavailableForDate),
            findsNWidgets(2),
          );
        } else {
          final value = c.$5 == 25123 ? '25,123' : '78,195';
          expect(
            find.text(l.hotelMilesReferenceStayFrom(value)),
            findsOneWidget,
          );
          expect(find.text(l.hotelMilesReferenceStay(value)), findsOneWidget);
        }
        expect(
          tester
                  .widget<HotelDetailRoomCard>(find.byType(HotelDetailRoomCard))
                  .onPlus !=
              null,
          c.$6,
        );
        expect(tester.takeException(), isNull);
        selection.dispose();
      }
      remote.snapshot = 'outside';
      await expectLater(
        repo.fetchHotelDetail(
          hotelId: '1',
          criteria: HotelSearchCriteria.initial(DateTime(2027, 10, 1)),
          languageCode: 'JP',
        ),
        throwsStateError,
      );
    },
    skip: captureDir == null,
  );
}
