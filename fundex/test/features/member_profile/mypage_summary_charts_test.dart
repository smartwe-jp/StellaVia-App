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
import 'package:fundex/features/member_profile/domain/repositories/mypage_repository.dart';
import 'package:fundex/features/member_profile/domain/usecases/load_mypage_chart_usecase.dart';
import 'package:fundex/features/member_profile/presentation/controllers/mypage_chart_controller.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_chart_providers.dart';
import 'package:fundex/features/member_profile/presentation/support/mypage_chart_display.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_summary_charts.dart';
import 'package:fundex/features/asset_statistics/domain/entities/asset_statistics_models.dart';
import 'package:fundex/features/asset_statistics/domain/repositories/asset_statistics_repository.dart';
import 'package:fundex/features/host_miles/domain/entities/host_miles_models.dart';
import 'package:fundex/features/host_miles/domain/repositories/host_miles_repository.dart';

class ProfileFake implements MyPageRepository {
  DateTime? start;
  @override
  Future<List<MyPageAssetTrend>> fetchAssetTrend({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    start = startDate;
    return const [
      MyPageAssetTrend(
        recordDate: '2026-10-01',
        totalAccount: 999,
        totalFundAccount: 200,
      ),
      MyPageAssetTrend(recordDate: '2022-01-01', totalFundAccount: 0),
      MyPageAssetTrend(recordDate: 'invalid', totalFundAccount: 400),
      MyPageAssetTrend(recordDate: '2026-10-02', totalAccount: 888),
    ];
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class AssetsFake implements AssetStatisticsRepository {
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
  Future<HostMilesCumulativeChart> fetchCumulativeChart({
    required DateTime startMonth,
  }) async => empty
      ? const HostMilesCumulativeChart()
      : const HostMilesCumulativeChart(
          xaxis: ['2026-01', '2026-02'],
          yaxis: [400, 500],
        );
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

MyPageChartData chart(int years) => MyPageChartData(
  start: DateTime(2027 - years),
  end: DateTime(2026, 10, 29),
  total: 9020314,
  points: [
    for (var y = 2027 - years; y <= 2026; y++)
      MyPageChartPoint(DateTime(y, 1, 1), (y - 2020) * 10000),
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
      await old.selectYears(1);
      container.invalidate(currentAuthUserProvider);
      await flush();
      await flush();
      expect(identical(old, container.read(provider.notifier)), true);
      expect(container.read(provider).years, 1);
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
    'maps fund balance, cumulative dividends and last earned miles without summing',
    () async {
      final profile = ProfileFake();
      final miles = MilesFake();
      final usecase = LoadMyPageChartUseCase(profile, AssetsFake(), miles);
      final balance = await usecase(
        MyPageChartKind.operating,
        5,
        DateTime(2026, 10, 29),
      );
      expect(profile.start, DateTime(2022));
      expect(balance.total, 200);
      expect(balance.points.map((p) => p.value), [0, 200]);
      final dividends = await usecase(
        MyPageChartKind.dividends,
        5,
        DateTime(2026, 10, 29),
      );
      expect(dividends.total, 1200);
      expect(MyPageChartDisplay.bars(dividends, 5).map((p) => p.value), [
        600,
        1200,
      ]);
      expect(
        (await usecase(MyPageChartKind.miles, 5, DateTime(2026, 10, 29))).total,
        500,
      );
      miles.empty = true;
      expect(
        (await usecase(MyPageChartKind.miles, 5, DateTime(2026, 10, 29))).total,
        isNull,
      );
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
      final second = c.selectYears(1);
      pending[1].complete(chart(1));
      await second;
      pending[0].complete(chart(5));
      await first;
      expect(c.state.years, 1);
      expect(c.state.data.valueOrNull?.start, DateTime(2026));
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
  }) => ProviderScope(
    overrides: [
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
      home: const Scaffold(
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
        expect(find.text('9,020,314'), findsNWidgets(3));
        await tester.tap(find.byType(PopupMenuButton<int>).first);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(PopupMenuItem<int>).first);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      }
    },
  );
  testWidgets('capture charts', (tester) async {
    if (Platform.environment['CHART_CAPTURE'] != '1') return;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 760);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey();
    await tester.pumpWidget(app(const Locale('ja'), capture: key));
    await tester.pumpAndSettle();
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
