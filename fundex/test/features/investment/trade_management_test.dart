import 'package:fundex/features/investment/data/models/fund_project_dto.dart';
import 'package:fundex/features/investment/domain/entities/fund_project.dart';
import 'package:fundex/features/investment/domain/repositories/fund_project_repository.dart';
import 'package:fundex/features/investment/presentation/providers/fund_project_providers.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/features/investment/presentation/pages/secondary_market_activity_page.dart';
import 'package:fundex/features/member_profile/domain/entities/mypage_models.dart';
import 'package:fundex/features/member_profile/domain/repositories/mypage_repository.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_providers.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_membership_providers.dart';
import 'package:fundex/features/member_profile/presentation/support/mypage_secondary_market_models.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_shortcuts.dart';
import 'package:fundex/l10n/app_localizations.dart';

class _OfferingRepository implements FundProjectRepository {
  @override
  Future<List<FundProject>> fetchFundProjectList() async => [
    for (final (name, status, units) in [
      ('募集中', 1, 14),
      ('完売', 1, 0),
      ('募集終了', 7, 99),
    ])
      FundProjectDto.fromJson({
        'id': name,
        'projectName': name,
        'projectStatus': status,
        'currentOpenInvestor': {'avaliableApplyTotal': units},
      }).toEntity(),
  ];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Trades implements MyPageRepository {
  final calls = <(int, int?, String?)>[];
  final applications = <int>[];
  @override
  Future<({List<MyPageOrderInquiryRecord> rows, int total})>
  fetchTradeListings({required int page, int? userId, String? status}) async {
    calls.add((page, userId, status));
    return (
      total: 11,
      rows: [
        MyPageOrderInquiryRecord(
          id: 'listing',
          projectName: 'open $page',
          status: 'VALID',
          availableNum: 2,
          price: 10000,
        ),
        const MyPageOrderInquiryRecord(
          id: 'closed',
          projectName: 'sold out',
          availableNum: 0,
          sellNum: 20,
          soldNum: 10,
        ),
      ],
    );
  }

  @override
  Future<({List<MyPageApplyRecord> rows, int total})> fetchTradeApplications({
    required int page,
  }) async {
    applications.add(page);
    return (
      rows: [
        const MyPageApplyRecord(projectName: 'application', processId: 'ap'),
      ],
      total: 1,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'shortcut lazily loads sellable records, market listings and account history',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      tester.view.padding = const FakeViewPadding(bottom: 34);
      addTearDown(tester.view.resetPadding);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      final repo = _Trades();
      var holdingsCalls = 0;
      const locale = Locale('ja');
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, _) => Scaffold(
              body: MyPageShortcuts(
                onSummary: () {},
                onFunds: () {},
                onTrades: () => context.push('/profile/my/secondary-market'),
                onMiles: () {},
                onMember: () {},
                onDocuments: () {},
              ),
            ),
          ),
          GoRoute(
            path: '/profile/my/secondary-market',
            builder: (_, __) => const SecondaryMarketActivityPage(),
          ),
          GoRoute(
            path: '/my/secondary-market/sell',
            builder: (_, state) {
              final seed = state.extra as MyPageSecondaryMarketSellSeed;
              return Scaffold(
                body: Text('${seed.fromProcessId}/${seed.availableUnits}'),
              );
            },
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            myPageMembershipIdentityProvider.overrideWithValue((
              'a',
              42,
              'user',
            )),
            myPageRepositoryProvider.overrideWithValue(repo),
            fundProjectRepositoryProvider.overrideWithValue(
              _OfferingRepository(),
            ),
            secondaryMarketHoldingsProvider.overrideWith((_) async {
              holdingsCalls++;
              return [
                for (var i = 0; i <= 11; i++)
                  SecondaryMarketHolding(
                    projectId: 'p',
                    processId: 'order$i',
                    projectName: 'Fund $i',
                    availableNum: i,
                    investedAmount: 20000,
                    investmentUnit: 10000,
                  ),
              ];
            }),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppThemeFactory.light(locale: locale),
          ),
        ),
      );
      await tester.pumpAndSettle();
      Future<void> tap(String text) async {
        final finder = find.text(text).first;
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        if (text == '次へ' && finder.hitTestable().evaluate().isEmpty) {
          await tester.drag(find.byType(ListView).last, const Offset(0, -2400));
          await tester.pumpAndSettle();
        }
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }

      expect(holdingsCalls, 0);
      await tap('売買管理');
      final list = find.byType(ListView).last;
      expect(tester.getRect(list).bottom, tester.view.physicalSize.height);
      expect(
        tester.widget<ListView>(list).padding,
        const EdgeInsets.fromLTRB(16, 12, 16, 58),
      );
      expect(holdingsCalls, 1);
      expect(repo.calls, isEmpty);
      expect(find.text('Fund 0'), findsNothing);
      await tap('次へ');
      expect(find.text('Fund 11'), findsOneWidget);
      await tap('売却申込');
      expect(find.text('order11/11'), findsOneWidget);
      router.pop();
      await tester.pumpAndSettle();
      await tap('ファンドを買う');
      expect(find.text('新規募集'), findsOneWidget);
      expect(find.text('募集中'), findsOneWidget);
      expect(find.text('14 口'), findsOneWidget);
      expect(find.text('募集終了'), findsNothing);
      expect(find.text('完売'), findsNothing);
      expect(repo.calls, isEmpty);
      await tap('会員間譲渡');
      expect(repo.calls.last, (1, null, 'VALID'));
      expect(find.text('sold out'), findsNothing);
      await tap('次へ');
      expect(repo.calls.last, (2, null, 'VALID'));
      await tap('売買履歴');
      expect(repo.calls.last, (1, 42, null));
      expect(find.text('sold out'), findsOneWidget);
      await tap('応募');
      expect(repo.applications, [1]);
      expect(find.text('application'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
