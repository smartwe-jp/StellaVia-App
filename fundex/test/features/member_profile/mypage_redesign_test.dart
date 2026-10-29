import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_asset_summary.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_holding_card.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_active_fund_summary_card.dart';

void main() {
  setUpAll(() async {
    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json')) as List;
    for (final e in manifest) {
      final loader = FontLoader(e['family'] as String);
      for (final f in e['fonts'] as List) {
        loader.addFont(rootBundle.load(f['asset'] as String));
      }
      await loader.load();
    }
  });
  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('overview privacy and actions, holding layout $locale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(393, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var deposits = 0;
      var withdrawals = 0;
      var details = 0;
      final boundary = GlobalKey();
      late AppLocalizations l10n;
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          theme: AppThemeFactory.light(locale: locale),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              final colors = context.appColors;
              return Scaffold(
                body: RepaintBoundary(
                  key: boundary,
                  child: ColoredBox(
                    color: colors.surface,
                    child: ListView(
                      children: [
                        MyPageAssetSummary(
                          displayName: '田中',
                          totalAssetsValue: '¥1,234,567',
                          verificationBadge: FundMyPageVerificationBadgeData(
                            label: l10n.memberProfileOverviewStatusPending,
                            backgroundColor: colors.warningSoft,
                            foregroundColor: colors.warningForeground,
                          ),
                          metrics: [
                            FundMyPageMetricData(
                              label: l10n.myPageMetricOperating,
                              value: '¥900,000',
                            ),
                            FundMyPageMetricData(
                              label: l10n.myPageMetricStandby,
                              value: '¥300,000',
                            ),
                            FundMyPageMetricData(
                              label: l10n.myPageMetricAccumulatedDistribution,
                              value: '¥34,567',
                            ),
                          ],
                          onDeposit: () => deposits++,
                          onWithdraw: () => withdrawals++,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: MyPageHoldingCard(
                            data: MyPageActiveFundSummaryCardData(
                              title: 'Amber Echoland Stella Asset Fund',
                              investorCode: '',
                              investorType: '',
                              returnText: '',
                              investmentAmountLabel:
                                  l10n.myPageInvestmentAmountLabel,
                              investmentAmountValue: '¥20,000',
                              investmentUnitsLabel: '口数',
                              investmentUnitsValue: '2口',
                              accumulatedEarningsLabel:
                                  l10n.myPageAccumulatedDistributionLabel,
                              accumulatedEarningsValue: '¥0',
                              periodText: '2026.07.01 – 2027.06.30',
                              statusLabel: '運用中',
                              statusBackgroundColor: colors.textPrimary,
                              statusForegroundColor: colors.surface,
                              onTap: () => details++,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        find.text(l10n.memberProfileOverviewStatusPending),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip(l10n.myPageHideAmounts));
      await tester.pump();
      expect(find.text('¥1,234,567'), findsNothing);
      expect(find.text('¥900,000'), findsNothing);
      await tester.tap(find.byTooltip(l10n.myPageShowAmounts));
      await tester.pump();
      expect(find.text('¥1,234,567'), findsOneWidget);
      await tester.tap(find.text(l10n.myPageDepositAction));
      await tester.tap(find.text(l10n.myPageWithdrawAction));
      await tester.tap(find.text('Amber Echoland Stella Asset Fund'));
      expect([deposits, withdrawals, details], [1, 1, 1]);
      if (locale.languageCode == 'ja') {
        await tester.pumpAndSettle();
        await tester.runAsync(() async {
          final image =
              await (boundary.currentContext!.findRenderObject()!
                      as RenderRepaintBoundary)
                  .toImage();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await File(
            '/tmp/mypage-redesign.png',
          ).writeAsBytes(bytes!.buffer.asUint8List());
        });
      }
    });
  }
}
