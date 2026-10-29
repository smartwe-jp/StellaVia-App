import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:fundex/features/home/presentation/widgets/home_miles_card.dart';
import 'package:fundex/features/home/presentation/widgets/home_rank_teaser.dart';

void main() {
  testWidgets(
    'live amount, error retry and dynamic ranks fit narrow localized layouts',
    (tester) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var retries = 0;
      var bookings = 0;
      for (final locale in AppLocalizations.supportedLocales) {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            theme: AppThemeFactory.light(locale: locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: MediaQuery(
                data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    HomeMilesCard(
                      balance: '9,020,314',
                      hasBalance: true,
                      hasError: true,
                      onRetry: () => retries++,
                      onTap: () => bookings++,
                    ),
                    HomeRankTeaser(
                      names: const ['REGULAR', 'MASTER', 'NEW'],
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('9,020,314'), findsOneWidget);
        expect(find.text('NEW'), findsOneWidget);
        final l10n = AppLocalizations.of(
          tester.element(find.byType(HomeMilesCard)),
        );
        await tester.tap(find.text(l10n.commonRetry));
        expect(bookings, 0);
        expect(tester.takeException(), isNull);
      }
      expect(retries, AppLocalizations.supportedLocales.length);
    },
  );
}
