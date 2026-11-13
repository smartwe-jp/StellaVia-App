import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:fundex/features/investment/presentation/widgets/secondary_contract_signature_pad.dart';
import 'package:fundex/features/investment/presentation/pages/secondary_signature_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_membership_providers.dart';
import 'package:hand_signature/signature.dart';
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
  test('contract presence and the current signer gate are independent', () {
    for (final id in [null, '', '  ', '123']) {
      for (final status in [null, 0, 1, 2, 3]) {
        for (final todo in [null, false, true]) {
          final record = MyPageApplyRecord(
            projectName: 'Fund',
            contractId: id,
            ecStatus: status,
            ecUserTodo: todo,
          );
          expect(hasSecondaryContract(record), id == '123');
          expect(
            isSecondaryContractUnderReview(record),
            id == '123' && status == 1,
          );
          expect(
            canSignSecondaryContract(record),
            id == '123' && (status == 0 || status == 1) && todo == true,
          );
        }
      }
    }
  });
  testWidgets(
    'signature field accepts strokes and clearing disables confirmation',
    (tester) async {
      const locale = Locale('ja');
      final l = await AppLocalizations.delegate.load(locale);
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const identity = ('a', 42, 'user');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            myPageMembershipIdentityProvider.overrideWithValue(identity),
          ],
          child: MaterialApp(
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: AppThemeFactory.light(locale: locale),
            home: const SecondarySignaturePage(
              id: 'contract',
              identity: identity,
            ),
          ),
        ),
      );
      final pad = find.byType(HandSignature);
      expect(tester.getSize(pad).height, greaterThan(80));
      expect(
        tester.getSize(pad).width,
        greaterThan(tester.getSize(pad).height),
      );
      final start = tester.getCenter(pad);
      await tester.dragFrom(start, const Offset(80, 35));
      await tester.pump();
      expect(
        tester.widget<AppButton>(find.byType(AppButton)).onPressed,
        isNotNull,
      );
      await tester.tap(find.text(l.secondaryMarketClearSignature));
      await tester.pump();
      expect(
        tester.widget<AppButton>(find.byType(AppButton)).onPressed,
        isNull,
      );
    },
  );
  testWidgets('signature upload rotates a rightward stroke clockwise', (
    tester,
  ) async {
    late final Completer<Uint8List> captured;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeFactory.light(locale: const Locale('ja')),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SecondaryContractSignaturePad(
            onConfirm: (png) async => captured.complete(png),
          ),
        ),
      ),
    );
    final start =
        tester.getCenter(find.byType(HandSignature)) - const Offset(100, 0);
    final stroke = await tester.startGesture(start);
    for (var x = 0; x <= 160; x += 8) {
      await stroke.moveTo(start + Offset(x.toDouble(), 0));
    }
    for (var y = 0; y <= 60; y += 6) {
      await stroke.moveTo(start + Offset(160, y.toDouble()));
    }
    await stroke.up();
    await tester.pump();
    await tester.runAsync(() async {
      captured = Completer<Uint8List>();
      tester.widget<AppButton>(find.byType(AppButton)).onPressed!();
      final codec = await ui.instantiateImageCodec(await captured.future);
      final image = (await codec.getNextFrame()).image;
      expect((image.width, image.height), (256, 512));
      final pixels = (await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      ))!;
      // The downward hook at the right end now extends left at the bottom.
      var upperLeft = 0, lowerLeft = 0;
      for (var y = 0; y < image.height; y++) {
        for (var x = 0; x < image.width ~/ 2; x++) {
          if (pixels.getUint8((y * image.width + x) * 4 + 3) > 128) {
            if (y < image.height ~/ 2) {
              upperLeft++;
            } else {
              lowerLeft++;
            }
          }
        }
      }
      expect(lowerLeft, greaterThan(upperLeft + 20));
      image.dispose();
      codec.dispose();
    });
    await tester.pumpAndSettle();
  });
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
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SecondaryMarketApplicationCard(record: record),
                    SecondaryMarketContractActions(
                      record: record,
                      seller: false,
                      onOpen: (_) {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(l.secondaryMarketStatePayment), findsOneWidget);
        expect(find.text(l.secondaryMarketViewContract), findsNothing);
        expect(find.text(l.secondaryMarketSign), findsOneWidget);
        expect(find.text(l.secondaryMarketPaymentPending), findsOneWidget);
        expect(find.byType(AppButton), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
