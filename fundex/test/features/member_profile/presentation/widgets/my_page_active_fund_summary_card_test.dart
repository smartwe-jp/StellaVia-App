import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_active_fund_summary_card.dart';

void main() {
  for (final scale in [1.0, 1.2]) {
    testWidgets(
      'card at scale $scale hides period and renders detail affordance',
      (tester) async {
        tester.view.physicalSize = const Size(320, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            theme: AppThemeFactory.light(locale: const Locale('ja')),
            home: Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: MyPageActiveFundSummaryCard(
                  data: MyPageActiveFundSummaryCardData(
                    title: '白馬ホテルファンド',
                    investorCode: '優先出資',
                    investorType: '投資',
                    returnText: '想定利回り 6.0%',
                    investmentAmountLabel: '投資額',
                    investmentAmountValue: '¥100,000,000',
                    investmentUnitsLabel: '投資口数',
                    investmentUnitsValue: '2口',
                    accumulatedEarningsLabel: '累計分配金',
                    accumulatedEarningsValue: '¥28,500',
                    statusLabel: '運用中',
                    statusBackgroundColor: Colors.blue.shade50,
                    statusForegroundColor: Colors.blue.shade700,
                    detailLabel: '詳細を見る',
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.textContaining('運用期間'), findsNothing);
        expect(find.text('詳細を見る'), findsOneWidget);
        expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
        expect(find.text('収益基準日'), findsNothing);
      },
    );
  }
}
