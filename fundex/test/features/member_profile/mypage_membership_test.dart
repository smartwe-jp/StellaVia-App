import 'dart:async';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:fundex/features/auth/domain/entities/auth_user.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:fundex/features/host_miles/domain/entities/host_miles_models.dart';
import 'package:fundex/features/host_miles/domain/repositories/host_miles_repository.dart';
import 'package:fundex/features/host_miles/presentation/providers/host_miles_providers.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_membership_providers.dart';
import 'package:fundex/features/member_profile/presentation/controllers/mypage_membership_controller.dart';
import 'package:fundex/features/member_profile/presentation/support/mypage_rank_display.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_membership_section.dart';

class MembershipFake implements HostMilesRepository {
  int calls = 0;
  bool fail = false;
  @override
  Future<HostMilesTier> fetchTier() async {
    calls++;
    return const HostMilesTier(
      currentTier: 'BRONZE',
      pointRate: .005,
      maxRooms: 3,
      currentBookingRooms: 1,
      currentAum: 1200000,
      nextTier: 'SILVER',
      nextTierGap: 800000,
    );
  }

  @override
  Future<HostMilesAccount> fetchAccount() async {
    calls++;
    if (fail) throw StateError('offline');
    return const HostMilesAccount(
      availablePoints: 3240,
      expiringSoonPoints: 120,
    );
  }

  @override
  Future<List<HostMilesExpiry>> fetchExpiryAlerts() async => [
    HostMilesExpiry(amount: 120, expireDate: DateTime.utc(2026, 11, 30)),
  ];
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

final signedIn = StateProvider<bool>((ref) => false);
final identity = StateProvider<String>((ref) => 'A');
Future<void> flush() => Future<void>.delayed(Duration.zero);
void main() {
  test('rank rate, server gap, MAX and unknown fields', () {
    expect(MyPageRankDisplay.rate(.005, 'ja'), '0.5');
    expect(
      MyPageRankDisplay.progress(
        const HostMilesTier(currentAum: 1200000, nextTierGap: 800000),
      ),
      .6,
    );
    expect(MyPageRankDisplay.progress(const HostMilesTier()), isNull);
    expect(MyPageRankDisplay.isMax(const HostMilesTier()), false);
    expect(MyPageRankDisplay.progress(const HostMilesTier(nextTier: 'MAX')), 1);
    expect(MyPageRankDisplay.number(null, 'ja'), '—');
    expect(
      MyPageRankDisplay.expiryDate(DateTime.utc(2026, 10, 29, 16), 'ja'),
      '2026/10/30',
    );
  });
  test(
    'session isolation, same-user cache, partial failure and guest endpoint guard',
    () async {
      final fake = MembershipFake();
      final c = ProviderContainer(
        overrides: [
          isAuthenticatedProvider.overrideWith(
            (ref) => AsyncData(ref.watch(signedIn)),
          ),
          currentAuthUserProvider.overrideWith(
            (ref) async => AuthUser(username: ref.watch(identity)),
          ),
          hostMilesRepositoryProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(c.dispose);
      c.listen(myPageTierProvider, (_, __) {});
      c.listen(myPageMilesAccountProvider, (_, __) {});
      await flush();
      expect(fake.calls, 0);
      c.read(signedIn.notifier).state = true;
      await flush();
      await flush();
      expect(c.read(myPageTierProvider).valueOrNull?.currentTier, 'BRONZE');
      final old = c.read(myPageMilesAccountProvider.notifier);
      c.invalidate(currentAuthUserProvider);
      await flush();
      await flush();
      expect(identical(old, c.read(myPageMilesAccountProvider.notifier)), true);
      fake.fail = true;
      await c.read(myPageMilesAccountProvider.notifier).refresh();
      expect(c.read(myPageMilesAccountProvider).hasError, true);
      expect(
        c.read(myPageMilesAccountProvider).valueOrNull?.availablePoints,
        3240,
      );
      expect(c.read(myPageTierProvider).hasError, false);
      c.read(identity.notifier).state = 'B';
      await flush();
      await flush();
      expect(old.mounted, false);
      expect(c.read(myPageMilesAccountProvider).valueOrNull, isNull);
      c.read(signedIn.notifier).state = false;
      await flush();
      expect(c.read(myPageTierProvider).valueOrNull, isNull);
    },
  );
  test('dispose ignores delayed account result', () async {
    final p = Completer<int>();
    final c = MyPageMembershipController(() => p.future);
    final task = c.refresh();
    c.dispose();
    p.complete(42);
    await task;
  });
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting();
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
    GoRouter? router,
  }) {
    final overrides = [
      isAuthenticatedProvider.overrideWithValue(const AsyncData(true)),
      currentAuthUserProvider.overrideWith(
        (ref) async => const AuthUser(username: 'A'),
      ),
      hostMilesRepositoryProvider.overrideWithValue(MembershipFake()),
    ];
    Widget builder(BuildContext c, Widget? child) => MediaQuery(
      data: MediaQuery.of(c).copyWith(textScaler: TextScaler.linear(scale)),
      child: RepaintBoundary(key: capture, child: child!),
    );
    return ProviderScope(
      overrides: overrides,
      child: router == null
          ? MaterialApp(
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: AppThemeFactory.light(locale: locale),
              builder: builder,
              home: const Scaffold(
                body: SingleChildScrollView(child: MyPageMembershipSection()),
              ),
            )
          : MaterialApp.router(
              routerConfig: router,
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: AppThemeFactory.light(locale: locale),
              builder: builder,
            ),
    );
  }

  testWidgets('four language narrow layout and expiry details', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final locale in AppLocalizations.supportedLocales) {
      await tester.pumpWidget(app(locale, scale: 1.3));
      await tester.pumpAndSettle();
      expect(find.text('BRONZE'), findsOneWidget);
      expect(find.text('3,240'), findsOneWidget);
      expect(find.text('0.5'), findsOneWidget);
      await tester.tap(find.text('120'));
      await tester.pumpAndSettle();
      expect(find.text('120 mile'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    }
  });
  testWidgets('rank link opens existing route', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: MyPageMembershipSection()),
        ),
        GoRoute(
          path: '/home/ranks',
          builder: (_, __) => const Scaffold(body: Text('rank destination')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(app(const Locale('ja'), router: router));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ランクについて'));
    await tester.pumpAndSettle();
    expect(find.text('rank destination'), findsOneWidget);
  });
  testWidgets('capture rank', (tester) async {
    if (Platform.environment['RANK_CAPTURE'] != '1') return;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 500);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey();
    await tester.pumpWidget(app(const Locale('ja'), capture: key));
    await tester.pumpAndSettle();
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final img = await boundary.toImage();
      final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
      await File(
        '/tmp/mypage-rank.png',
      ).writeAsBytes(bytes!.buffer.asUint8List());
      img.dispose();
    });
  });
}
