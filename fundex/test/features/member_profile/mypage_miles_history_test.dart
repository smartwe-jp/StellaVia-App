import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/features/host_miles/domain/entities/host_miles_models.dart';
import 'package:fundex/features/host_miles/domain/repositories/host_miles_repository.dart';
import 'package:fundex/features/host_miles/presentation/providers/host_miles_providers.dart';
import 'package:fundex/features/member_profile/domain/entities/mypage_chart.dart';
import 'package:fundex/features/member_profile/presentation/controllers/mypage_chart_controller.dart';
import 'package:fundex/features/member_profile/presentation/controllers/mypage_membership_controller.dart';
import 'package:fundex/features/member_profile/presentation/pages/my_page_miles_history_page.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_chart_providers.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_membership_providers.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_summary_charts.dart';
import 'package:fundex/l10n/app_localizations.dart';

class _Miles implements HostMilesRepository {
  final requests = <(int, int)>[];
  bool fail = false;
  @override
  Future<HostMilesTransactionPage> fetchTransactions({
    String? bizType,
    int startPage = 1,
    int limit = 20,
  }) async {
    requests.add((startPage, limit));
    if (fail) throw StateError('offline');
    return HostMilesTransactionPage(
      total: 15,
      rows: startPage == 1
          ? [
              HostMilesTransaction(
                amount: -8,
                bizType: 'SPEND',
                createTime: DateTime(2026, 10, 20),
              ),
              HostMilesTransaction(
                amount: 200,
                typeDescription: 'earn',
                createTime: DateTime(2026, 11, 5),
                expireTime: DateTime(2027, 11, 5),
              ),
              const HostMilesTransaction(amount: 1111),
              HostMilesTransaction(
                amount: 30,
                typeDescription: 'expire_soon',
                createTime: DateTime(2026, 11, 2),
              ),
            ]
          : [
              HostMilesTransaction(
                amount: 5,
                bizType: 'EXPIRED',
                createTime: DateTime(2026, 9, 1),
              ),
            ],
    );
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
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
    'summary opens monthly mile history; supports pagination, retry and page size',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final capture = GlobalKey();
      final repo = _Miles();
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const Scaffold(
              body: MyPageSummaryChartCard(kind: MyPageChartKind.miles),
            ),
          ),
          GoRoute(
            path: '/profile/miles-history',
            builder: (_, __) => const MyPageMilesHistoryPage(),
          ),
        ],
      );
      addTearDown(router.dispose);
      const locale = Locale('ja');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            myPageMembershipIdentityProvider.overrideWithValue((
              '1',
              1,
              'user',
            )),
            hostMilesRepositoryProvider.overrideWithValue(repo),
            myPageTierProvider.overrideWith((ref) {
              final c = MyPageMembershipController(
                () async => const HostMilesTier(pointsBalance: 100),
              );
              Future.microtask(c.refresh);
              return c;
            }),
            myPageChartProvider(MyPageChartKind.miles).overrideWith((ref) {
              final c = MyPageChartController(
                (_) async =>
                    MyPageChartData(start: DateTime(2025), end: DateTime(2026)),
              );
              Future.microtask(c.refresh);
              return c;
            }),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            builder: (context, child) =>
                RepaintBoundary(key: capture, child: child!),
            locale: locale,
            theme: AppThemeFactory.light(locale: locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(repo.requests, isEmpty);
      await tester.tap(find.text('マイル履歴'));
      await tester.pumpAndSettle();
      expect(repo.requests, [(1, 10)]);
      expect(
        tester.getTopLeft(find.text('2026.11')).dy,
        lessThan(tester.getTopLeft(find.text('2026.10')).dy),
      );
      for (final label in [
        '+200mile',
        '-8mile',
        '30mile',
        '有効期限：2027.11.05',
        '1 / 2',
      ]) {
        expect(find.text(label), findsOneWidget);
      }
      final preview = Platform.environment['MILES_HISTORY_PREVIEW'];
      if (preview != null) {
        await tester.runAsync(() async {
          final boundary =
              capture.currentContext!.findRenderObject()
                  as RenderRepaintBoundary;
          final image = await boundary.toImage();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await File(preview).writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
      repo.fail = true;
      await tester.tap(find.text('次へ'));
      await tester.pumpAndSettle();
      expect(find.text('マイル履歴の取得に失敗しました'), findsOneWidget);
      repo.fail = false;
      final l = AppLocalizations.of(
        tester.element(find.byType(MyPageMilesHistoryPage)),
      );
      await tester.tap(find.text(l.commonRetry));
      await tester.pumpAndSettle();
      expect(repo.requests.last, (2, 10));
      expect(find.text('-5mile'), findsOneWidget);
      await tester.tap(find.text('最新の10件'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('最新の50件'));
      await tester.pumpAndSettle();
      expect(repo.requests.last, (1, 50));
      expect(find.text('1 / 1'), findsOneWidget);
      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('マイル履歴'), findsOneWidget);
    },
  );
}
