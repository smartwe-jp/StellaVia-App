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
import 'package:fundex/features/asset_statistics/domain/entities/asset_statistics_models.dart';
import 'package:fundex/features/asset_statistics/domain/repositories/asset_statistics_repository.dart';
import 'package:fundex/features/asset_statistics/presentation/providers/asset_statistics_providers.dart';
import 'package:fundex/features/auth/domain/entities/auth_user.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:fundex/features/member_profile/domain/entities/mypage_models.dart';
import 'package:fundex/features/member_profile/domain/repositories/mypage_repository.dart';
import 'package:fundex/features/member_profile/presentation/pages/host_fund_management_page.dart';
import 'package:fundex/features/member_profile/presentation/support/mypage_section_support.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_active_fund_summary_card.dart';
import 'package:fundex/features/member_profile/presentation/providers/host_fund_management_providers.dart';
import 'package:fundex/features/member_profile/presentation/providers/member_profile_providers.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_membership_providers.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_providers.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_shortcuts.dart';
import 'package:fundex/features/member_profile/presentation/widgets/host_fund_return_chart.dart';
import 'package:fundex/features/wallet/domain/entities/wallet_bank_account_info.dart';
import 'package:fundex/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:fundex/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:fundex/features/investment/domain/entities/fund_project.dart';
import 'package:fundex/features/investment/domain/usecases/fetch_fund_project_detail_usecase.dart';
import 'package:fundex/features/investment/presentation/providers/fund_project_providers.dart';

class _Project implements FetchFundProjectDetailUseCase {
  final requests = <String>[];
  @override
  Future<FundProject> call({required String id}) async {
    requests.add(id);
    return FundProject(
      id: id,
      projectName: 'Fund',
      notLiveJapanBank: id == 'missing'
          ? null
          : const FundProjectLiveJapanBank(
              bankName: 'International bank',
              bankNumber: '98765',
              bankAccountSwiftCode: 'SWIFT',
              branchBankAddress: 'Tokyo',
              bankCountry: 'JP',
              bankAccountOwnerAddress: 'Osaka',
            ),
      liveJapanBank: const FundProjectLiveJapanBank(
        bankName: 'Project bank',
        bankNumber: '654321',
      ),
    );
  }
}

class _Wallet implements WalletRepository {
  WalletBankAccountInfo? account;
  @override
  Future<WalletBankAccountInfo?> fetchBankAccountInfo() async {
    requests++;
    if (fail) throw StateError('offline');
    return account;
  }

  int requests = 0;
  bool fail = false;
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _Applications implements MyPageRepository {
  final calls = <(int, int)>[];
  bool fail = false;
  final withdrawals = <String>[];
  @override
  Future<List<MyPageInvestmentRecord>> fetchInvestmentList({
    int? projectStatus,
    int startPage = 1,
    int limit = 20,
  }) async {
    expect(projectStatus, 4);
    return [
      for (final order in ['first', 'second'])
        MyPageInvestmentRecord(
          projectId: 'p',
          projectName: '運用投資 $order',
          projectStatus: 4,
          processId: order,
        ),
    ];
  }

  @override
  Future<void> submitUserWithdraw({
    required String processId,
    String? remark,
  }) async {
    withdrawals.add(processId);
  }

  @override
  Future<({List<MyPageApplyRecord> rows, int total})>
  fetchFundManagementApplications({
    required int page,
    required int status,
  }) async {
    calls.add((status, page));
    if (fail) throw StateError('offline');
    return (
      total: 12,
      rows: [
        MyPageApplyRecord(
          projectId: 'p',
          projectName: status == 2 ? '京都ファンド' : '軽井沢ファンド $page',
          processId: 'id',
          status: status,
          period: '8',
          expectedYield: .0625,
          applyNum: 40,
          applyMoney: 400000,
          paymentExpiryDate: '2026-11-20',
        ),
      ],
    );
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _Assets implements AssetStatisticsRepository {
  DateTime? endMonth, start;
  int? startYear;
  final statuses = <List<int>>[];
  @override
  Future<AssetInvestmentChart> fetchInvestments({
    required List<int> status,
  }) async {
    statuses.add(status);
    return const AssetInvestmentChart(
      investTotal: 120000,
      investList: [
        AssetInvestment(
          projectId: 'p',
          projectName: '神戸ファンド',
          investMoneyValid: 120000,
          investNumValid: 12,
          beginDate: '2026-03-01',
          endDate: '2027-03-01',
        ),
      ],
    );
  }

  @override
  Future<AssetBenefitForecast> fetchForecast({
    required DateTime endYearMonth,
  }) async {
    endMonth = endYearMonth;
    final month = DateTime.now().toIso8601String().substring(0, 7);
    return AssetBenefitForecast(
      expectBenefitList: [
        AssetExpectedBenefit(yearMonth: month, expectBenefit: 1000),
        AssetExpectedBenefit(yearMonth: month, expectBenefit: 2000),
        AssetExpectedBenefit(
          yearMonth: DateTime(
            DateTime.now().year,
            DateTime.now().month + 15,
          ).toIso8601String().substring(0, 7),
          expectBenefit: 1,
        ),
      ],
      expectPrincipalList: [
        AssetExpectedPrincipal(yearMonth: month, expectPrincipal: 100000),
      ],
    );
  }

  @override
  Future<List<AssetYearlyBenefit>> fetchYearlyBenefits({
    required int startYear,
  }) async {
    this.startYear = startYear;
    return const [
      AssetYearlyBenefit(year: 2025, totalBenefit: 7500, actualBenefit: 6500),
      AssetYearlyBenefit(year: 2026, totalBenefit: 8000, actualBenefit: 7000),
    ];
  }

  @override
  Future<AssetCumulativeBenefit> fetchCumulativeBenefit({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    start = startDate;
    return const AssetCumulativeBenefit(
      total: 15500,
      dates: ['2025-10', '2026-10'],
      values: [7500, 15500],
    );
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final entry
        in jsonDecode(await rootBundle.loadString('FontManifest.json'))
            as List) {
      final loader = FontLoader(entry['family'] as String);
      for (final font in entry['fonts']) {
        loader.addFont(rootBundle.load(font['asset'] as String));
      }
      await loader.load();
    }
  });
  test(
    'uses the dedicated bank first and falls back only when it is absent',
    () async {
      final wallet = _Wallet(), project = _Project();
      final container = ProviderContainer(
        overrides: [
          currentAuthUserProvider.overrideWith(
            (_) async => const AuthUser(username: 'test', liveJp: 1),
          ),
          myPageMembershipIdentityProvider.overrideWithValue(('1', 1, 'test')),
          walletRepositoryProvider.overrideWithValue(wallet),
          fetchFundProjectDetailUseCaseProvider.overrideWithValue(project),
        ],
      );
      addTearDown(container.dispose);
      wallet.account = const WalletBankAccountInfo(
        bankName: 'Dedicated',
        branchName: 'Branch',
        accountType: '普通',
        accountNumber: '111',
        accountHolder: 'Test',
      );
      final dedicated = await container.read(hostFundBankProvider('a').future);
      expect(dedicated.bank?.bankName, 'Dedicated');
      expect(dedicated.source, HostFundBankSource.pool);
      expect(project.requests, isEmpty);
      wallet.account = null;
      final fallback = await container.read(hostFundBankProvider('b').future);
      expect(fallback.bank?.accountNumber, '654321');
      expect(fallback.source, HostFundBankSource.domesticProject);
      wallet.account = const WalletBankAccountInfo(
        bankName: 'Partial',
        branchName: '--',
        accountNumber: '111',
        accountType: '',
        accountHolder: 'Test',
      );
      expect(
        (await container.read(hostFundBankProvider('c').future)).bank?.bankName,
        'Project bank',
      );
      wallet.fail = true;
      expect(
        (await container.read(hostFundBankProvider('d').future)).source,
        HostFundBankSource.domesticProject,
      );
      expect(project.requests, ['b', 'c', 'd']);
    },
  );
  for (final residency in [0, null]) {
    test(
      'residency $residency never requests the pool or falls back to a domestic account',
      () async {
        final wallet = _Wallet(), project = _Project();
        final container = ProviderContainer(
          overrides: [
            myPageMembershipIdentityProvider.overrideWithValue((
              '1',
              1,
              'test',
            )),
            currentAuthUserProvider.overrideWith(
              (_) async => AuthUser(username: 'test', liveJp: residency),
            ),
            walletRepositoryProvider.overrideWithValue(wallet),
            fetchFundProjectDetailUseCaseProvider.overrideWithValue(project),
          ],
        );
        addTearDown(container.dispose);
        final result = await container.read(hostFundBankProvider('a').future);
        expect(
          result.source,
          residency == 0
              ? HostFundBankSource.overseasProject
              : HostFundBankSource.unknownResidency,
        );
        expect(result.bank?.swiftCode, residency == 0 ? 'SWIFT' : null);
        expect(result.bank?.branchAddress, residency == 0 ? 'Tokyo' : null);
        expect(
          (await container.read(hostFundBankProvider('missing').future)).bank,
          isNull,
        );
        expect(project.requests, residency == 0 ? ['a', 'missing'] : isEmpty);
        expect(wallet.requests, 0);
      },
    );
  }
  testWidgets(
    'My Page shortcut opens all six fund sections with independent data and actions',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      final capture = GlobalKey();
      final applications = _Applications(), assets = _Assets();
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, _) => Scaffold(
              body: MyPageShortcuts(
                onSummary: () {},
                onFunds: () => context.push('/profile/host-funds'),
                onTrades: () {},
                onMiles: () {},
                onMember: () {},
                onDocuments: () {},
              ),
            ),
          ),
          GoRoute(
            path: '/profile/host-funds',
            builder: (_, __) => const HostFundManagementPage(),
          ),
          GoRoute(
            path: '/profile/my/active-funds/:id',
            builder: (_, state) => Scaffold(
              body: Text(
                'Detail ${state.pathParameters['id']} ${(state.extra as MyPageActiveFundDetailSeed).processId}',
              ),
            ),
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
            myPageRepositoryProvider.overrideWithValue(applications),
            fundProjectListProvider.overrideWith((_) async => []),
            assetStatisticsRepositoryProvider.overrideWithValue(assets),
            currentAuthUserProvider.overrideWith(
              (ref) async => const AuthUser(username: 'user', userId: 123),
            ),
            memberBasicProfileProvider.overrideWithValue(null),
            hostFundBankProvider('p').overrideWith(
              (ref) async => (
                source: HostFundBankSource.pool,
                bank: const WalletBankAccountInfo(
                  bankName: 'テスト銀行',
                  branchName: '京都',
                  accountType: '普通',
                  accountNumber: '12345',
                  accountHolder: 'テスト',
                ),
              ),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            locale: locale,
            theme: AppThemeFactory.light(locale: locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) =>
                RepaintBoundary(key: capture, child: child!),
          ),
        ),
      );
      await tester.pumpAndSettle();
      Future<void> tap(String label) async {
        final target = find.text(label).first;
        await tester.ensureVisible(target);
        await tester.tap(target);
        await tester.pumpAndSettle();
      }

      Future<void> preview(String name) async {
        final dir = Platform.environment['FUND_MANAGE_PREVIEW'];
        if (dir == null) return;
        await tester.runAsync(() async {
          await Directory(dir).create(recursive: true);
          final image =
              await (capture.currentContext!.findRenderObject()
                      as RenderRepaintBoundary)
                  .toImage();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await File(
            '$dir/$name.png',
          ).writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }

      await tap('宿主ファンド管理');
      expect(applications.calls, [(0, 1)]);
      expect(find.byType(FundMyPageProjectCard), findsOneWidget);
      expect(find.text('6.25%'), findsOneWidget);
      await preview('applying');
      await tap('キャンセル');
      expect(find.text('この申込を撤回します。よろしいですか？'), findsOneWidget);
      expect(applications.withdrawals, isEmpty);
      await tap('撤回する');
      expect(applications.withdrawals, ['id']);
      await tap('次へ');
      expect(applications.calls.last, (0, 2));
      await tap('入金前');
      expect(applications.calls.last, (2, 1));
      expect(find.text('2026/11/20'), findsOneWidget);
      await preview('pending');
      await tap('振込先口座を確認');
      expect(find.text('テスト銀行'), findsOneWidget);
      await preview('bank');
      await tester.tap(find.byType(CloseButton));
      await tester.pumpAndSettle();
      await tap('運用前');
      expect(assets.statuses.last, [1, 7, 3]);
      expect(find.text('神戸ファンド'), findsOneWidget);
      await tap('運用中');
      expect(assets.statuses.last, [4]);
      expect(find.byType(MyPageActiveFundSummaryCard), findsWidgets);
      await preview('running');
      await tester.scrollUntilVisible(
        find.text('運用投資 second'),
        180,
        scrollable: find.byType(Scrollable).last,
      );
      await tap('運用投資 second');
      expect(find.text('Detail p second'), findsOneWidget);
      router.pop();
      await tester.pumpAndSettle();
      await tap('償還・配当予定');
      expect(find.text('103,000 円'), findsOneWidget);
      expect(find.byType(HostFundReturnChart), findsNWidgets(2));
      expect(
        tester
            .widget<HostFundReturnChart>(find.byType(HostFundReturnChart).first)
            .unitScale,
        1000,
      );
      await preview('forecast');
      await tap('未来1年間');
      await tap('未来3年間');
      expect(find.text('(単位: 円)'), findsOneWidget);
      expect(
        tester
            .widget<HostFundReturnChart>(find.byType(HostFundReturnChart).first)
            .unitScale,
        1,
      );
      final now = DateTime.now();
      expect(assets.endMonth, DateTime(now.year, now.month + 37));
      await tap('配当実績');
      expect(assets.startYear, now.year - 1);
      expect(assets.start, DateTime(now.year - 1, now.month, now.day));
      expect(find.text('6,500 円'), findsOneWidget);
      await preview('dividends');
      await tap('償還・配当予定');
      expect(find.text('未来3年間'), findsOneWidget);
      applications.fail = true;
      await tap('応募中');
      expect(find.text('再試行'), findsOneWidget);
      applications.fail = false;
      await tap('再試行');
      expect(find.text('軽井沢ファンド 1'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
