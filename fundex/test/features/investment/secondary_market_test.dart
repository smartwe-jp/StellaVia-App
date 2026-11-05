import 'dart:async';
import 'package:fundex/features/member_profile/presentation/support/mypage_section_support.dart';
import 'package:fundex/features/member_profile/presentation/support/mypage_secondary_market_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:fundex/features/member_profile/data/models/mypage_dtos.dart';
import 'package:fundex/features/member_profile/domain/entities/mypage_models.dart';
import 'package:fundex/features/investment/presentation/controllers/secondary_market_controller.dart';
import 'package:fundex/features/investment/presentation/support/secondary_market_status.dart';
import 'package:fundex/features/investment/presentation/support/secondary_market_trade_support.dart';
import 'package:fundex/features/investment/presentation/widgets/secondary_market_activity_cards.dart';
import 'package:fundex/features/investment/presentation/widgets/secondary_market_contract_actions.dart';
import 'package:fundex/l10n/app_localizations.dart';

MyPageOrderInquiryRecord order(
  String id, {
  String status = 'VALID',
  num price = 100,
  int sold = 0,
}) => MyPageOrderInquiryRecord(
  id: id,
  projectId: 'same-fund',
  projectName: 'Fund',
  fromProcessId: 'holding',
  memberId: 1,
  sellNum: 4,
  soldNum: sold,
  price: price,
  status: status,
);
void main() {
  test('sale keeps the clicked purchase identity and remaining units', () {
    final first = MyPageActiveFundDetailSeed.fromRecord(
      const MyPageInvestmentRecord(
        projectId: 'fund',
        projectName: 'Fund',
        processId: 'order-a',
        investNumRemaining: 2,
      ),
    );
    final second = MyPageActiveFundDetailSeed.fromRecord(
      const MyPageInvestmentRecord(
        projectId: 'fund',
        projectName: 'Fund',
        processId: 'order-b',
        investNumRemaining: 5,
      ),
    );
    expect(buildDisplayedRecordSellSeed(first)!.fromProcessId, 'order-a');
    expect(buildDisplayedRecordSellSeed(first)!.availableUnits, 2);
    expect(buildDisplayedRecordSellSeed(second)!.fromProcessId, 'order-b');
    expect(buildDisplayedRecordSellSeed(second)!.availableUnits, 5);
    expect(buildDisplayedRecordSellSeed(null), isNull);
  });
  test(
    'DTO mapper carries contract metadata for purchases and seller child applications',
    () {
      final dto = UserInvestmentOrderInquiryRecordDto.fromJson({
        'id': 1,
        'projectName': 'Fund',
        'applyList': [
          {
            'processId': 'a',
            'contractId': 987,
            'ecStatus': 2,
            'ecUserTodo': true,
            'status': 2,
          },
          {'processId': 'b', 'status': 3},
        ],
      });
      final entities = dto.toEntity().applyList;
      expect(entities.first.contractId, '987');
      expect(entities.first.ecStatus, 2);
      expect(entities.first.ecUserTodo, true);
      expect(entities.last.ecUserTodo, isNull);
    },
  );
  test('listing eligibility excludes invalid, zero price and sold out', () {
    expect(canBuySecondaryMarketRecord(order('a')), true);
    expect(canBuySecondaryMarketRecord(order('a', status: 'INVALID')), false);
    expect(canBuySecondaryMarketRecord(order('a', price: 0)), false);
    expect(canBuySecondaryMarketRecord(order('a', sold: 4)), false);
    expect(canCancelSecondaryListing(order('a', status: 'INVALID')), false);
    expect(canCancelSecondaryListing(order('a', sold: 4)), false);
    expect(canCancelSecondaryListing(order('a')), true);
  });
  test(
    'pagination keeps multiple listings of the same fund and refresh failure preserves content',
    () async {
      bool fail = false;
      final controller = SecondaryMarketController(
        purchases: false,
        fetchApplications: (_) async => [],
        fetchOrders: (page) async {
          if (fail) throw StateError('offline');
          return page == 1
              ? List.generate(20, (i) => order('$i'))
              : [order('20')];
        },
      );
      addTearDown(controller.dispose);
      await controller.refresh();
      await controller.loadMore();
      expect(controller.state.orders.length, 21);
      expect(controller.state.hasMore, false);
      fail = true;
      await controller.refresh();
      expect(controller.state.orders.length, 21);
      expect(controller.state.error, isNotNull);
    },
  );
  test('old in-flight refresh cannot overwrite newer result', () async {
    final old = Completer<List<MyPageOrderInquiryRecord>>();
    var calls = 0;
    final controller = SecondaryMarketController(
      purchases: false,
      fetchApplications: (_) async => [],
      fetchOrders: (_) =>
          ++calls == 1 ? old.future : Future.value([order('new')]),
    );
    addTearDown(controller.dispose);
    final first = controller.refresh();
    await controller.refresh();
    old.complete([order('old')]);
    await first;
    expect(controller.state.orders.single.id, 'new');
  });
  test(
    'purchase pagination uses process identity, never project identity',
    () async {
      final controller = SecondaryMarketController(
        purchases: true,
        fetchOrders: (_) async => [],
        fetchApplications: (_) async => [
          const MyPageApplyRecord(
            projectName: 'Fund',
            projectId: 'same',
            processId: 'a',
            status: 0,
          ),
          const MyPageApplyRecord(
            projectName: 'Fund',
            projectId: 'same',
            processId: 'b',
            status: 2,
          ),
        ],
      );
      addTearDown(controller.dispose);
      await controller.refresh();
      expect(controller.state.applications.map((r) => r.processId), ['a', 'b']);
    },
  );
  test(
    'withdrawal applies only to pending applications with their own process ID',
    () {
      for (var status = 0; status <= 5; status++) {
        final record = MyPageApplyRecord(
          projectName: 'Fund',
          processId: 'purchase',
          fromProcessId: 'seller',
          status: status,
        );
        expect(
          canWithdrawSecondaryApplication(record),
          status == 0 || status == 2,
        );
      }
      expect(
        canWithdrawSecondaryApplication(
          const MyPageApplyRecord(
            projectName: 'Fund',
            fromProcessId: 'seller',
            status: 2,
          ),
        ),
        false,
      );
    },
  );
  for (final locale in [
    const Locale('ja'),
    const Locale('zh'),
    const Locale('en'),
    const Locale('zh', 'Hant'),
  ]) {
    testWidgets(
      'separate application and contract status, no deferred actions: $locale',
      (tester) async {
        const record = MyPageApplyRecord(
          projectName: 'Fund',
          processId: 'a',
          contractId: '123',
          status: 2,
          ecStatus: 0,
          ecUserTodo: true,
        );
        final l = await AppLocalizations.delegate.load(locale);
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            theme: AppThemeFactory.light(locale: locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SecondaryMarketApplicationCard(record: record),
                    SecondaryMarketContractActions(
                      record: record,
                      seller: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(l.secondaryMarketStatePayment), findsOneWidget);
        expect(find.text(l.secondaryMarketContractTodo), findsOneWidget);
        expect(find.text(l.secondaryMarketPaymentPending), findsOneWidget);
        expect(find.byType(AppButton), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
