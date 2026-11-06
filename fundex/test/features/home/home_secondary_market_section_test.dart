import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/home/presentation/widgets/home_secondary_market_section.dart';
import 'package:fundex/features/investment/presentation/controllers/secondary_market_controller.dart';
import 'package:fundex/features/investment/presentation/widgets/secondary_market_marketplace_card.dart';
import 'package:fundex/features/member_profile/domain/entities/mypage_models.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  testWidgets('home shows first four market cards in response order', (
    tester,
  ) async {
    final controller = SecondaryMarketController(
      purchases: false,
      fetchApplications: (_) async => [],
      fetchOrders: (_) async => List.generate(
        6,
        (i) => MyPageOrderInquiryRecord(
          id: '$i',
          projectName: 'Listing $i',
          projectId: 'same-fund',
          status: 'VALID',
          sellNum: 10,
          soldNum: 2,
          price: 10000,
        ),
      ),
    );
    await controller.refresh();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          secondaryMarketControllerProvider.overrideWith(
            (ref, kind) => controller,
          ),
        ],
        child: MaterialApp(
          locale: const Locale('ja'),
          theme: AppThemeFactory.light(locale: const Locale('ja')),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: SingleChildScrollView(child: HomeSecondaryMarketSection()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final cards = tester
        .widgetList<SecondaryMarketMarketplaceCard>(
          find.byType(SecondaryMarketMarketplaceCard),
        )
        .toList();
    expect(cards.map((card) => card.record.id), ['0', '1', '2', '3']);
    expect(find.byType(FundSecondaryMarketCard), findsNWidgets(4));
    expect(find.text('Listing 4'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
