import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_shortcuts.dart';
import 'package:fundex/l10n/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/features/host_miles/domain/entities/host_miles_models.dart';
import 'package:fundex/features/host_miles/domain/repositories/host_miles_repository.dart';
import 'package:fundex/features/host_miles/presentation/providers/host_miles_providers.dart';
import 'package:fundex/features/auth/domain/entities/auth_user.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:fundex/features/member_profile/presentation/pages/my_page_miles_management_page.dart';

import 'package:fundex/features/member_profile/domain/usecases/load_mypage_chart_usecase.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_chart_providers.dart';
import 'package:fundex/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:fundex/features/asset_statistics/domain/repositories/asset_statistics_repository.dart';

class _UnusedWallet implements WalletRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedAssets implements AssetStatisticsRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Miles implements HostMilesRepository {
  final months = <DateTime>[], ranges = <DateTime>[], daily = <DateTime>[];
  var forecasts = 0;
  @override
  Future<HostMilesTier> fetchTier() async => const HostMilesTier(
    currentTier: 'GOLD',
    pointRate: .006,
    pointsBalance: 2400,
    maxRooms: 4,
    currentBookingRooms: 1,
    nextTier: 'MASTER',
    nextTierGap: 250000,
  );
  @override
  Future<List<HostMilesExpiry>> fetchExpiryAlerts() async => [
    HostMilesExpiry(amount: 100, expireDate: DateTime(2027, 1)),
  ];
  @override
  Future<num> fetchEarnedMonth(DateTime month) async {
    months.add(month);
    return month.month == DateTime.now().month ? 302 : 101;
  }

  @override
  Future<num> fetchExpectedNextMonth() async =>
      ++forecasts == 1 ? throw StateError('offline') : 420;
  @override
  Future<List<HostMilesChartEntry>> fetchChart({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    daily.add(startDate);
    return [
      for (final (date, amount) in [
        ('2026-09-01', 1800),
        ('2026-10-01', 2150),
        ('2026-11-01', 2400),
      ])
        HostMilesChartEntry(date: date, points: amount),
    ];
  }

  @override
  Future<HostMilesCumulativeChart> fetchCumulativeChart({
    required DateTime startMonth,
  }) async {
    ranges.add(startMonth);
    return const HostMilesCumulativeChart(
      xaxis: ['2026-09', '2026-10', '2026-11'],
      yaxis: [2100, 2580, 3100],
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json')) as List;
    for (final entry in manifest) {
      final loader = FontLoader(entry['family'] as String);
      for (final font in entry['fonts']) {
        loader.addFont(rootBundle.load(font['asset'] as String));
      }
      await loader.load();
    }
  });
  testWidgets(
    'shortcut opens miles, retries forecast and switches chart ranges independently',
    (tester) async {
      final miles = _Miles(), capture = GlobalKey();
      const locale = Locale('ja');
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 1750);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, _) => Scaffold(
              body: MyPageShortcuts(
                onSummary: () {},
                onFunds: () {},
                onTrades: () {},
                onMiles: () => context.push('/profile/miles'),
                onMember: () {},
                onDocuments: () {},
              ),
            ),
          ),
          GoRoute(
            path: '/profile/miles',
            builder: (_, __) => const MyPageMilesManagementPage(),
          ),
          GoRoute(
            path: '/profile/miles-history',
            builder: (_, __) => const Scaffold(body: Text('History')),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            hostMilesRepositoryProvider.overrideWithValue(miles),
            loadMyPageChartProvider.overrideWithValue(
              LoadMyPageChartUseCase(_UnusedWallet(), _UnusedAssets(), miles),
            ),
            isAuthenticatedProvider.overrideWithValue(const AsyncData(true)),
            currentAuthUserProvider.overrideWith(
              (ref) async => const AuthUser(userId: 1, username: 'user'),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            locale: locale,
            theme: AppThemeFactory.light(locale: locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (_, child) => RepaintBoundary(key: capture, child: child!),
          ),
        ),
      );
      await tester.pumpAndSettle();
      Future<void> tap(Finder finder) async {
        await tester.ensureVisible(finder);
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }

      await tap(find.text('宿主マイル管理'));
      final now = DateTime.now();
      expect(
        miles.months,
        containsAll([
          DateTime(now.year, now.month - 1),
          DateTime(now.year, now.month),
        ]),
      );
      expect(miles.ranges.last, DateTime(now.year - 1, now.month));
      await tap(find.text('再試行'));
      expect(find.text('420 マイル'), findsOneWidget);
      expect(find.text('101 マイル'), findsOneWidget);
      final preview = Platform.environment['MILES_MANAGEMENT_PREVIEW'];
      if (preview != null) {
        await tester.runAsync(() async {
          final image =
              await (capture.currentContext!.findRenderObject()
                      as RenderRepaintBoundary)
                  .toImage();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await File(preview).writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
      final dailyRequests = miles.daily.length;
      await tap(find.text('直近1年間').last);
      await tap(find.text('直近3年間').last);
      expect(miles.ranges.last, DateTime(now.year - 3, now.month));
      expect(miles.daily.length, dailyRequests);
      await tap(find.text('直近1年間').first);
      await tap(find.text('直近5年間').last);
      expect(miles.daily.last.year, now.year - 5);
      expect(miles.ranges.last, DateTime(now.year - 3, now.month));
      await tap(find.text('マイル履歴'));
      expect(find.text('History'), findsOneWidget);
      router.pop();
      await tester.pumpAndSettle();
      tester.view.physicalSize = const Size(320, 700);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
