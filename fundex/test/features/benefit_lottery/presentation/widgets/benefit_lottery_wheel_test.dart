import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/benefit_lottery/presentation/controllers/benefit_lottery_draw_controller.dart';
import 'package:fundex/features/benefit_lottery/presentation/models/benefit_lottery_models.dart';
import 'package:fundex/features/benefit_lottery/presentation/widgets/benefit_lottery_wheel.dart';

void main() {
  test('prizes alternate brand accents and no-win uses cream', () {
    const palette = BenefitLotteryWheelPalette.stellaVia;
    expect(palette.colorForPrizeIndex(0), AppColorTokens.brandPurple);
    expect(palette.colorForPrizeIndex(1), AppColorTokens.brandViolet);
    expect(palette.colorForPrizeIndex(2), AppColorTokens.brandPurple);
    expect(palette.noWinColor, AppColorTokens.brandBaseCream);
  });

  testWidgets('renders the supported maximum of eight segments', (
    WidgetTester tester,
  ) async {
    final model = BenefitLotteryWheelModel(
      prizes: <BenefitLotteryPrize>[
        for (var index = 0; index < 7; index++)
          BenefitLotteryPrize(
            id: 'prize-$index',
            title: 'Prize $index',
            price: (index + 1) * 1000,
          ),
        const BenefitLotteryPrize(
          id: 'no-win',
          title: 'No prize',
          price: 0,
          isNoWin: true,
        ),
      ],
    );
    final controller = BenefitLotteryDrawController(model: model);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeFactory.light(locale: const Locale('ja')),
        home: Scaffold(
          body: Center(
            child: BenefitLotteryWheel(
              controller: controller,
              centerLabel: 'SPIN',
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      find.byKey(const Key('benefit_lottery_wheel_canvas')),
      findsOneWidget,
    );
  });

  testWidgets('animates to the prize returned by the draw request', (
    WidgetTester tester,
  ) async {
    final model = BenefitLotteryWheelModel(
      prizes: const <BenefitLotteryPrize>[
        BenefitLotteryPrize(id: 'a', title: 'A prize', price: 30000),
        BenefitLotteryPrize(id: 'b', title: 'B prize', price: 10000),
        BenefitLotteryPrize(
          id: 'no-win',
          title: 'No prize',
          price: 0,
          isNoWin: true,
        ),
      ],
    );
    final controller = BenefitLotteryDrawController(model: model);
    BenefitLotteryPrize? completedPrize;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeFactory.light(locale: const Locale('ja')),
        home: Scaffold(
          body: Center(
            child: BenefitLotteryWheel(
              controller: controller,
              centerLabel: 'SPIN',
              spinDuration: const Duration(milliseconds: 300),
              onSpinCompleted: (prize) => completedPrize = prize,
            ),
          ),
        ),
      ),
    );

    await controller.draw(
      () async => const BenefitLotteryDrawResult(prizeId: 'no-win'),
    );
    expect(controller.phase, BenefitLotteryDrawPhase.spinning);

    await tester.pump();
    await tester.pumpAndSettle();

    expect(controller.phase, BenefitLotteryDrawPhase.completed);
    expect(controller.selectedPrize?.isNoWin, isTrue);
    expect(completedPrize?.id, 'no-win');
    expect(
      find.byKey(const Key('benefit_lottery_no_win_toast')),
      findsOneWidget,
    );
    expect(find.text('No prize'), findsWidgets);
    expect(
      find.byKey(const Key('benefit_lottery_wheel_canvas')),
      findsOneWidget,
    );

    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('benefit_lottery_no_win_toast')), findsNothing);
  });
}
