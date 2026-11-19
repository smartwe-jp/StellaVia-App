import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_room_detail_sheet.dart';
import 'hotel_detail_redesign_test.dart' as fixtures;

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
      description: '部屋の詳細と設備を確認できます。' * 20,
      facilityCategories: const [
        HotelRoomFacilityCategory(
          code: 'supplies',
          name: '客室設備',
          items: ['キッチン', '有線LAN', 'バスタオル、フェイスタオル、ハンドタオル'],
        ),
      ],
      images: [],
      beds: [],
    );

void main() {
  for (final locale in AppLocalizations.supportedLocales) {
    for (final scale in [1.0, 1.2]) {
      testWidgets('room details fit $locale at $scale', (tester) async {
        tester.view.physicalSize = const Size(320, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          MaterialApp(
            theme: AppThemeFactory.light(locale: locale),
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => showHotelRoomDetailSheet(
                    context: context,
                    detail: fixtures.detail(),
                    room: room(),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.byIcon(Icons.close_rounded));
        await tester.pumpAndSettle();
        expect(find.byType(CustomScrollView), findsNothing);
      });
    }
  }
}
