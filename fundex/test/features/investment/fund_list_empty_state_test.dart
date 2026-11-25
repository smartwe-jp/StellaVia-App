import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/network/app_network_connectivity_providers.dart';
import 'package:fundex/features/investment/data/datasources/fund_project_favorites_local_data_source.dart';
import 'package:fundex/features/investment/domain/entities/fund_project.dart';
import 'package:fundex/features/investment/presentation/controllers/fund_project_favorites_controller.dart';
import 'package:fundex/features/investment/presentation/pages/investment_tab_page.dart';
import 'package:fundex/features/investment/presentation/providers/fund_project_favorite_providers.dart';
import 'package:fundex/features/investment/presentation/providers/fund_project_providers.dart';
import 'package:fundex/features/investment/presentation/widgets/fund_list_empty_state.dart';
import 'package:fundex/l10n/app_localizations.dart';

class _Favorites implements FundProjectFavoritesLocalDataSource {
  @override
  Future<Set<String>> readFavoriteProjectIds() async => {};
  @override
  Future<void> saveFavoriteProjectIds(Set<String> ids) async {}
}

Future<void> pumpList(
  WidgetTester tester,
  Future<List<FundProject>> Function() load,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        fundProjectListProvider.overrideWith((_) => load()),
        fundProjectFavoritesControllerProvider.overrideWith(
          (_) => FundProjectFavoritesController(_Favorites()),
        ),
        appNetworkAvailabilityProvider.overrideWith(
          (_) => Stream.value(AppNetworkAvailability.online),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('ja'),
        theme: AppThemeFactory.light(locale: const Locale('ja')),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: InvestmentTabPage()),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  setUpAll(() async {
    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json')) as List;
    for (final entry in manifest) {
      final loader = FontLoader(entry['family'] as String);
      for (final font in entry['fonts'] as List) {
        loader.addFont(rootBundle.load(font['asset'] as String));
      }
      await loader.load();
    }
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  testWidgets(
    'fund card displays senior funding target, applications and progress',
    (tester) async {
      await pumpList(
        tester,
        () async => const [
          FundProject(
            id: '1',
            projectName: 'Test fund',
            seniorRate: 1,
            seniorInvestorTotal: 1000000,
            seniorInvestorApplication: 900000,
            currentlySubscribed: 700000,
            achievementRate: 0.7,
          ),
        ],
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('募集金額 ¥1,000,000'), findsOneWidget);
      expect(find.textContaining('応募金額 ¥900,000（100.00%）'), findsWidgets);
    },
  );

  testWidgets('empty all, filtered no-match and pull-to-refresh recovery', (
    tester,
  ) async {
    var requests = 0;
    await pumpList(tester, () async {
      requests++;
      return requests == 1
          ? []
          : [
              const FundProject(
                id: 'new',
                projectName: 'New fund',
                projectStatus: 0,
              ),
            ];
    });
    await tester.pumpAndSettle();
    expect(find.text('COMING SOON'), findsOneWidget);
    await tester.tap(find.text('募集前'));
    await tester.pumpAndSettle();
    expect(find.text('NO MATCH'), findsOneWidget);
    await tester.tap(find.text('すべて'));
    await tester.pumpAndSettle();
    expect(find.text('COMING SOON'), findsOneWidget);
    await tester.drag(find.byType(ListView).last, const Offset(0, 350));
    await tester.pumpAndSettle();
    expect(requests, 2);
    expect(find.byType(FundListEmptyState), findsNothing);
    expect(find.textContaining('New fund'), findsWidgets);
    await tester.tap(find.text('募集中'));
    await tester.pumpAndSettle();
    expect(find.text('NO MATCH'), findsOneWidget);
    expect(find.text('COMING SOON'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('loading and request failure are not empty success', (
    tester,
  ) async {
    final request = Completer<List<FundProject>>();
    await pumpList(tester, () => request.future);
    expect(find.byType(FundListEmptyState), findsNothing);
    request.completeError(StateError('unavailable'));
    await tester.pumpAndSettle();
    final l = AppLocalizations.of(
      tester.element(find.byType(InvestmentTabPage)),
    );
    expect(find.text(l.fundListLoadError), findsOneWidget);
    expect(find.text(l.fundListRetry), findsOneWidget);
    expect(find.byType(FundListEmptyState), findsNothing);
  });

  for (final locale in AppLocalizations.supportedLocales) {
    for (final dark in [false, true]) {
      testWidgets(
        'empty messages fit narrow scaled layout $locale dark=$dark',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(320, 640));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          for (final preparing in [true, false]) {
            final boundary = GlobalKey();
            await tester.pumpWidget(
              MaterialApp(
                locale: locale,
                theme: dark
                    ? AppThemeFactory.dark(locale: locale)
                    : AppThemeFactory.light(locale: locale),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: MediaQuery(
                  data: const MediaQueryData(
                    textScaler: TextScaler.linear(1.3),
                  ),
                  child: RepaintBoundary(
                    key: boundary,
                    child: Scaffold(
                      body: SingleChildScrollView(
                        child: FundListEmptyState(isPreparing: preparing),
                      ),
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            if (locale.languageCode == 'ja' && !dark) {
              await tester.runAsync(() async {
                final image =
                    await (boundary.currentContext!.findRenderObject()!
                            as RenderRepaintBoundary)
                        .toImage();
                final bytes = await image.toByteData(
                  format: ui.ImageByteFormat.png,
                );
                await File(
                  '/tmp/fund-empty-${preparing ? 'preparing' : 'no-match'}.png',
                ).writeAsBytes(bytes!.buffer.asUint8List());
                image.dispose();
              });
            }
          }
        },
      );
    }
  }
}
