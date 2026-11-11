import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';
import 'package:fundex/features/hotel_booking/domain/utils/hotel_miles_booking_window.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_search_condition_pickers.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  test('tier months preserve month-end and clamp stale dates', () {
    final today = DateTime(2027, 8, 31);
    final window = HotelMilesBookingWindow(today, 6);
    expect(window.lastNight, DateTime(2028, 2, 29));
    final stale = HotelSearchCriteria.initial(DateTime(2028, 3, 1));
    expect(window.constrain(stale).checkInDate, today);
    expect(window.constrain(stale).checkOutDate, DateTime(2027, 9, 1));
    final last = HotelSearchCriteria.initial(
      window.lastNight,
    ).copyWith(checkOutDate: DateTime(2028, 3, 3));
    expect(window.constrain(last).checkOutDate, DateTime(2028, 3, 1));
    expect(HotelMilesBookingWindow(today, 0).lastNight, today);
  });

  testWidgets(
    'final night is selectable and the following day is checkout only',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemeFactory.light(locale: const Locale('en')),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: HotelStayDateRangePicker(
              initialStartDate: DateTime(2027, 5, 10),
              initialEndDate: DateTime(2027, 5, 11),
              firstDate: DateTime(2027, 5, 1),
              lastCheckIn: DateTime(2027, 5, 11),
              lastDate: DateTime(2027, 5, 12),
              priceCalendarByDate: const {},
            ),
          ),
        ),
      );
      InkWell day(int n) => tester.widget<InkWell>(
        find
            .ancestor(of: find.text('$n'), matching: find.byType(InkWell))
            .first,
      );
      expect(day(12).onTap, isNull);
      await tester.tap(find.text('11'));
      await tester.pump();
      expect(day(12).onTap, isNotNull);
      expect(day(13).onTap, isNull);
      await tester.tap(find.text('12'));
      await tester.pump();
      expect(day(12).onTap, isNull);
    },
  );
}
