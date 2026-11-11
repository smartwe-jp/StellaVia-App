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
import 'package:fundex/features/investment/presentation/pages/secondary_market_buy_order_page.dart';
import 'package:fundex/features/investment/presentation/pages/secondary_market_buy_confirm_page.dart';
import 'package:fundex/features/investment/presentation/support/secondary_market_trade_models.dart';
import 'package:fundex/features/member_profile/presentation/pages/my_page_secondary_market_sell_order_page.dart';
import 'package:fundex/features/member_profile/presentation/pages/my_page_secondary_market_sell_confirm_page.dart';
import 'package:fundex/features/member_profile/presentation/support/mypage_secondary_market_models.dart';
import 'package:fundex/features/investment/domain/entities/fund_project.dart';
import 'package:fundex/features/investment/presentation/providers/fund_project_providers.dart';
import 'package:fundex/features/member_profile/domain/usecases/submit_mypage_secondary_market_create_usecase.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_providers.dart';
import 'package:fundex/l10n/app_localizations.dart';

class _SaleSubmission implements SubmitMyPageSecondaryMarketCreateUseCase {
  final requests = <(String, int, int)>[];
  @override
  Future<void> call({
    required String fromProcessId,
    required int sellNum,
    required int price,
  }) async {
    requests.add((fromProcessId, sellNum, price));
  }
}

void main() {
  setUpAll(() async {
    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json')) as List;
    for (final family in manifest) {
      final loader = FontLoader(family['family'] as String);
      for (final font in family['fonts']) {
        loader.addFont(rootBundle.load(font['asset'] as String));
      }
      await loader.load();
    }
  });
  testWidgets(
    'sell entry without a holding price retries the same project price',
    (tester) async {
      int? unitPrice;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fundProjectDetailProvider('p').overrideWith(
              (ref) async => FundProject(
                id: 'p',
                projectName: '京都',
                investmentUnit: unitPrice,
              ),
            ),
          ],
          child: MaterialApp(
            locale: const Locale('ja'),
            theme: AppThemeFactory.light(locale: const Locale('ja')),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const MyPageSecondaryMarketSellOrderPage(
              seed: MyPageSecondaryMarketSellSeed(
                projectId: 'p',
                projectName: '京都',
                fromProcessId: 'original',
                availableUnits: 3,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l = AppLocalizations.of(
        tester.element(find.byType(MyPageSecondaryMarketSellOrderPage)),
      );
      expect(find.text(l.myPageResalePriceUnavailable), findsOneWidget);
      expect(
        tester.widget<AppButton>(find.byType(AppButton)).onPressed,
        isNull,
      );
      unitPrice = 12500;
      await tester.ensureVisible(find.text(l.commonRetry));
      await tester.tap(find.text(l.commonRetry));
      await tester.pumpAndSettle();
      expect(find.textContaining('12,500'), findsWidgets);
      expect(find.text(l.myPageResalePriceUnavailable), findsNothing);
    },
  );
  for (final sell in [true, false]) {
    final side = sell ? 'sell' : 'buy';
    testWidgets(
      '$side updates the estimate and requires consent before review',
      (tester) async {
        tester.view.devicePixelRatio = 2;
        tester.view.physicalSize = const Size(780, 1688);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final boundary = GlobalKey();
        final saleSubmission = _SaleSubmission();
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => sell
                  ? const MyPageSecondaryMarketSellOrderPage(
                      seed: MyPageSecondaryMarketSellSeed(
                        projectId: 'p',
                        projectName: '京都町家ファンド',
                        fromProcessId: 'holding',
                        availableUnits: 70,
                        initialUnitPrice: 10000,
                      ),
                    )
                  : const SecondaryMarketBuyOrderPage(
                      seed: SecondaryMarketBuySeed(
                        orderId: 'order',
                        projectId: 'p',
                        projectName: '京都町家ファンド',
                        availableUnits: 70,
                        unitPrice: 10000,
                      ),
                    ),
            ),
            GoRoute(
              path: '/profile/my/secondary-market',
              builder: (_, _) => const Scaffold(),
            ),
            GoRoute(
              path: sell
                  ? '/my/secondary-market/sell/confirm'
                  : '/free-market/order/buy/confirm',
              builder: (_, state) => sell
                  ? MyPageSecondaryMarketSellConfirmPage(
                      draft: state.extra! as MyPageSecondaryMarketSellDraft,
                    )
                  : SecondaryMarketBuyConfirmPage(
                      draft: state.extra! as SecondaryMarketBuyDraft,
                    ),
            ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              submitMyPageSecondaryMarketCreateUseCaseProvider
                  .overrideWithValue(saleSubmission),
            ],
            child: MaterialApp.router(
              locale: const Locale('ja'),
              theme: AppThemeFactory.light(locale: const Locale('ja')),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: router,
              builder: (_, child) =>
                  RepaintBoundary(key: boundary, child: child!),
            ),
          ),
        );
        await tester.pumpAndSettle();
        Future<void> capture(String step) async {
          final dir = Platform.environment['TRADE_PREVIEW_DIR'];
          if (dir == null) return;
          await tester.runAsync(() async {
            final image =
                await (boundary.currentContext!.findRenderObject()
                        as RenderRepaintBoundary)
                    .toImage(pixelRatio: 2);
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            await Directory(dir).create(recursive: true);
            await File(
              '$dir/$side-$step.png',
            ).writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
        }

        expect(find.byType(TextField), findsOneWidget);
        expect(find.textContaining('手数料'), findsNothing);
        await capture('order');
        expect(
          tester.widget<AppButton>(find.byType(AppButton)).onPressed,
          isNull,
        );
        await tester.tap(find.byIcon(Icons.add_rounded));
        await tester.pumpAndSettle();
        expect(find.textContaining('20,000'), findsWidgets);
        await tester.drag(find.byType(ListView), const Offset(0, -600));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(CheckboxListTile));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(AppButton));
        await tester.pumpAndSettle();
        expect(
          find.byType(
            sell
                ? MyPageSecondaryMarketSellConfirmPage
                : SecondaryMarketBuyConfirmPage,
          ),
          findsOneWidget,
        );
        expect(find.textContaining('20,000'), findsWidgets);
        expect(tester.takeException(), isNull);
        expect(find.textContaining('手数料'), findsNothing);
        await capture('confirm');
        if (sell) {
          final l = AppLocalizations.of(
            tester.element(find.byType(MyPageSecondaryMarketSellConfirmPage)),
          );
          await tester.tap(find.byType(AppButton));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 400));
          expect(saleSubmission.requests, isEmpty);
          await tester.tap(find.text(l.myPageResaleSubmitButton).last);
          await tester.pumpAndSettle();
          expect(saleSubmission.requests, [('holding', 2, 10000)]);
          expect(
            router.state.uri.toString(),
            '/profile/my/secondary-market?tab=sales',
          );
          await tester.pump(const Duration(seconds: 2));
        }
      },
    );
  }
}
