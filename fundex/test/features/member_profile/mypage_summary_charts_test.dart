import 'package:fundex/features/auth/domain/entities/auth_user.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
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
import 'package:fundex/l10n/app_localizations.dart';
import 'package:fundex/features/member_profile/domain/entities/mypage_chart.dart';
import 'package:fundex/features/member_profile/domain/entities/mypage_models.dart';
import 'package:fundex/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:fundex/features/wallet/domain/entities/wallet_account_history.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_providers.dart';
import 'package:fundex/features/member_profile/domain/usecases/load_mypage_chart_usecase.dart';
import 'package:fundex/features/member_profile/presentation/controllers/mypage_chart_controller.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_chart_providers.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_balance_ring.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_summary_charts.dart';
import 'package:fundex/features/member_profile/presentation/pages/my_page_summary_page.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_membership_providers.dart';
import 'package:fundex/features/member_profile/presentation/controllers/mypage_membership_controller.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_membership_card.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_summary_rank_card.dart';
import 'package:fundex/features/asset_statistics/domain/entities/asset_statistics_models.dart';
import 'package:fundex/features/asset_statistics/domain/repositories/asset_statistics_repository.dart';
import 'package:fundex/features/host_miles/domain/entities/host_miles_models.dart';
import 'package:fundex/features/host_miles/domain/repositories/host_miles_repository.dart';

class WalletFake implements WalletRepository {
  @override
  Future<List<WalletAccountHistory>> fetchAccountHistory({
    int? accountType = 0,
  }) async {
    expect(accountType, isNull);
    return const [
      WalletAccountHistory(tradeTime: '2026-10-29 19:58:00', balance: 200),
      WalletAccountHistory(tradeTime: '2025-10-29', balance: 50),
      WalletAccountHistory(tradeTime: '2025-10-28', balance: 10),
      WalletAccountHistory(tradeTime: 'invalid', balance: 300),
      WalletAccountHistory(createTime: '2026-10-30', balance: 400),
    ];
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class AssetsFake implements AssetStatisticsRepository {
  @override
  Future<AssetInvestmentChart> fetchInvestments() async =>
      const AssetInvestmentChart(
        investTotal: 210,
        investList: [
          AssetInvestment(projectName: 'A', investMoneyValid: 150),
          AssetInvestment(projectName: 'B', investMoneyValid: 50),
        ],
      );

  @override
  Future<AssetCumulativeBenefit> fetchCumulativeBenefit({
    required DateTime startDate,
    required DateTime endDate,
  }) async => const AssetCumulativeBenefit(
    total: 1200,
    dates: ['2025-01-01', '2025-10-01', '2026-01-01'],
    values: [100, 600, 1200],
  );
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class MilesFake implements HostMilesRepository {
  bool empty = false;
  @override
  Future<List<HostMilesChartEntry>> fetchChart({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    expect(startDate, DateTime(endDate.year - 5, endDate.month, endDate.day));
    return empty
        ? []
        : const [
            HostMilesChartEntry(date: '2025-01', points: 400),
            HostMilesChartEntry(date: '2026-02', points: 500),
          ];
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

MyPageChartData chart(int years) => MyPageChartData(
  start: years == 1 ? DateTime(2025, 11) : DateTime(2027 - years),
  end: DateTime(2026, 10, 29),
  total: 9020314,
  holdings: const [
    AssetInvestment(
      projectName: 'Fund A',
      investMoneyValid: 5412188,
      beginDate: '2025-01-01',
      endDate: '2027-12-31',
    ),
    AssetInvestment(projectName: 'Fund B', investMoneyValid: 3608126),
  ],
  points: [
    for (var i = 0; i <= 12; i++)
      MyPageChartPoint(
        DateTime(2026, 10 - 12 * years + i * years, 29),
        3000 + i * 800,
      ),
  ],
);

class LoaderFake implements LoadMyPageChartUseCase {
  int calls = 0;
  @override
  Future<MyPageChartData> call(
    MyPageChartKind kind,
    int years,
    DateTime now,
  ) async {
    calls++;
    return chart(years);
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

final signedIn = StateProvider<bool>((ref) => false);
final identity = StateProvider<String>((ref) => 'A');
Future<void> flush() => Future<void>.delayed(Duration.zero);
void main() {
  test(
    'provider skips private endpoints for guests and clears old account charts',
    () async {
      final loader = LoaderFake();
      final container = ProviderContainer(
        overrides: [
          isAuthenticatedProvider.overrideWith(
            (ref) => AsyncData(ref.watch(signedIn)),
          ),
          currentAuthUserProvider.overrideWith(
            (ref) async => AuthUser(username: ref.watch(identity)),
          ),
          loadMyPageChartProvider.overrideWithValue(loader),
        ],
      );
      addTearDown(container.dispose);
      final provider = myPageChartProvider(MyPageChartKind.miles);
      container.listen(provider, (_, __) {});
      await flush();
      await container.read(provider.notifier).refresh();
      expect(loader.calls, 0);
      container.read(signedIn.notifier).state = true;
      await flush();
      await flush();
      expect(container.read(provider).data.valueOrNull?.total, 9020314);
      final old = container.read(provider.notifier);
      expect(old.state.years, 1);
      await old.selectYears(3);
      container.invalidate(currentAuthUserProvider);
      await flush();
      await flush();
      expect(identical(old, container.read(provider.notifier)), true);
      expect(container.read(provider).years, 3);
      container.read(identity.notifier).state = 'B';
      await flush();
      await flush();
      expect(old.mounted, false);
      container.read(signedIn.notifier).state = false;
      await flush();
      expect(container.read(provider).data.valueOrNull, isNull);
    },
  );

  test(
    'loads real fund positions, cumulative dividend rows and the last daily miles balance',
    () async {
      final wallet = WalletFake();
      final miles = MilesFake();
      final usecase = LoadMyPageChartUseCase(wallet, AssetsFake(), miles);
      final balance = await usecase(
        MyPageChartKind.operating,
        5,
        DateTime(2026, 10, 29),
      );
      expect(balance.total, 210);
      expect(balance.holdings.map((h) => h.investMoneyValid), [150, 50]);
      final dividends = await usecase(
        MyPageChartKind.dividends,
        5,
        DateTime(2026, 10, 29),
      );
      expect(dividends.total, 1200);
      expect(dividends.points.map((p) => p.value), [100, 600, 1200]);
      expect(
        (await usecase(MyPageChartKind.miles, 5, DateTime(2026, 10, 29))).total,
        500,
      );
      miles.empty = true;
      expect(
        (await usecase(MyPageChartKind.miles, 5, DateTime(2026, 10, 29))).total,
        0,
      );
    },
  );
  test(
    'wallet window uses inclusive calendar dates and the Web leap-year rule',
    () async {
      final now = DateTime(2026, 10, 29);
      final data = await LoadMyPageChartUseCase(
        WalletFake(),
        AssetsFake(),
        MilesFake(),
      )(MyPageChartKind.available, 1, now);
      expect(data.historyWindow(1, now).points.map((p) => p.value), [50, 200]);
      expect(data.historyWindow(3, now).points.map((p) => p.value), [
        10,
        50,
        200,
      ]);
      expect(
        MyPageChartData.rangeStart(DateTime(2024, 2, 29), 1),
        DateTime(2023, 3, 1),
      );
    },
  );
  test(
    'available balance switches ranges locally even while its history is loading',
    () async {
      final pending = Completer<MyPageChartData>();
      var calls = 0;
      final controller = MyPageChartController((years) {
        calls++;
        return pending.future;
      }, localHistory: true);
      addTearDown(controller.dispose);
      final now = DateTime.now();
      final oldPoint = MyPageChartPoint(
        DateTime(now.year - 2, now.month, now.day),
        19,
      );
      final recentPoint = MyPageChartPoint(now, 25);
      final first = controller.refresh();
      await controller.selectYears(5);
      pending.complete(
        MyPageChartData(start: now, end: now, points: [oldPoint, recentPoint]),
      );
      await first;
      expect(controller.state.data.valueOrNull!.points, [
        oldPoint,
        recentPoint,
      ]);
      await controller.selectYears(1);
      expect(controller.state.data.valueOrNull!.points, [recentPoint]);
      expect(calls, 1);
    },
  );
  test(
    'range changes reject late results and refresh failure preserves useful data',
    () async {
      final pending = <Completer<MyPageChartData>>[];
      final c = MyPageChartController((years) {
        final p = Completer<MyPageChartData>();
        pending.add(p);
        return p.future;
      });
      final first = c.refresh();
      final second = c.selectYears(3);
      pending[1].complete(chart(3));
      await second;
      pending[0].complete(chart(5));
      await first;
      expect(c.state.years, 3);
      expect(c.state.data.valueOrNull?.start, DateTime(2024));
      final refresh = c.refresh();
      pending.last.completeError(StateError('offline'));
      await refresh;
      expect(c.state.data.hasError, true);
      expect(c.state.data.valueOrNull?.total, 9020314);
      final late = c.refresh();
      c.dispose();
      pending.last.complete(chart(1));
      await late;
    },
  );
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
  Widget app(
    Locale locale, {
    double scale = 1,
    GlobalKey? capture,
    bool dark = false,
    bool summary = false,
  }) => ProviderScope(
    overrides: [
      myPageAccountStatisticProvider.overrideWith(
        (ref) async =>
            const MyPageAccountStatistic(firstLevelAccountTotal: 14500),
      ),
      ...[
        myPageMilesExpiryProvider.overrideWith((ref) async => []),
        myPageTierProvider.overrideWith((ref) {
          final c = MyPageMembershipController(
            () async => const HostMilesTier(
              pointsBalance: 30000,
              currentTier: 'BRONZE',
              pointRate: .00525,
              maxRooms: 3,
              currentBookingRooms: 1,
              currentAum: 600000,
              nextTierGap: 900000,
            ),
          );
          Future.microtask(c.refresh);
          return c;
        }),
        myPageMilesAccountProvider.overrideWith((ref) {
          final c = MyPageMembershipController(
            () async => const HostMilesAccount(
              availablePoints: 30000,
              expiringSoonPoints: 1200,
            ),
          );
          Future.microtask(c.refresh);
          return c;
        }),
      ],
      for (final kind in MyPageChartKind.values)
        myPageChartProvider(kind).overrideWith((ref) {
          final c = MyPageChartController((years) async => chart(years));
          Future.microtask(c.refresh);
          return c;
        }),
    ],
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: dark
          ? AppThemeFactory.dark(locale: locale)
          : AppThemeFactory.light(locale: locale),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: RepaintBoundary(key: capture, child: child!),
      ),
      home: summary
          ? const MyPageSummaryPage()
          : const Scaffold(
              body: SingleChildScrollView(child: MyPageSummaryCharts()),
            ),
    ),
  );
  testWidgets(
    'four locales, narrow layout, independent range selectors and dark theme',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 1000);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final locale in AppLocalizations.supportedLocales) {
        await tester.pumpWidget(
          app(locale, scale: 1.3, dark: locale.languageCode == 'en'),
        );
        await tester.pumpAndSettle();
        expect(
          find.textContaining('9,020,314', findRichText: true),
          findsNWidgets(3),
        );
        expect(
          tester
              .widgetList<AppDropdownSelector<int>>(
                find.byType(AppDropdownSelector<int>),
              )
              .map((w) => w.value),
          [1, 1, 1],
        );
        await tester.tap(find.byType(PopupMenuButton<int>).first);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(PopupMenuItem<int>).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      }
    },
  );
  testWidgets('summary shows a combined rank card above the four charts', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 1830);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey();
    await tester.pumpWidget(
      app(const Locale('ja'), capture: key, summary: true),
    );
    await tester.pumpAndSettle();
    expect(find.byType(MyPageMembershipCard), findsNothing);
    final card = find.byType(MyPageSummaryRankCard);
    expect(card, findsOneWidget);
    for (final value in [
      'BRONZE',
      '0.525 %',
      '3 室',
      '1 室',
      '1,200 マイル',
      '900,000 円',
    ]) {
      expect(
        find.descendant(
          of: card,
          matching: find.text(value, findRichText: true),
        ),
        findsOneWidget,
      );
    }
    expect(
      tester
          .widgetList<MyPageSummaryChartCard>(
            find.byType(MyPageSummaryChartCard),
          )
          .map((w) => w.kind),
      [
        MyPageChartKind.miles,
        MyPageChartKind.operating,
        MyPageChartKind.dividends,
        MyPageChartKind.available,
      ],
    );
    expect(tester.takeException(), isNull);
    expect(find.textContaining('30,000', findRichText: true), findsOneWidget);
    expect(find.textContaining('14,500', findRichText: true), findsOneWidget);
    final ring = find.byType(MyPageBalanceRing);
    await tester.ensureVisible(ring);
    await tester.tapAt(tester.getCenter(ring) + const Offset(86, 0));
    await tester.pump();
    expect(find.textContaining('Fund A'), findsOneWidget);
    await tester.tapAt(tester.getCenter(ring));
    await tester.pump();
    await tester.ensureVisible(card);
    final arrow = find.descendant(
      of: card,
      matching: find.byIcon(Icons.chevron_right_rounded),
    );
    final expiryRow = find
        .ancestor(of: arrow, matching: find.byType(AppCard))
        .first;
    expect(tester.getSize(expiryRow).height, 45);
    await tester.tap(arrow);
    await tester.pumpAndSettle();
    expect(find.text('失効予定の宿主マイル'), findsOneWidget);
    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle();
    if (Platform.environment['CHART_CAPTURE'] != '1') return;
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final img = await boundary.toImage();
      final data = await img.toByteData(format: ui.ImageByteFormat.png);
      await File(
        '/tmp/mypage-summary-charts.png',
      ).writeAsBytes(data!.buffer.asUint8List());
      img.dispose();
    });
  });
}
