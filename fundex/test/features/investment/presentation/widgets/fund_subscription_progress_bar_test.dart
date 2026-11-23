import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/investment/presentation/widgets/fund_subscription_progress_bar.dart';

void main() {
  testWidgets('fill follows the subscription ratio and caps at the target', (
    tester,
  ) async {
    final output = Platform.environment['FUND_PROGRESS_PREVIEW'];
    if (output != null) {
      final manifest =
          jsonDecode(await rootBundle.loadString('FontManifest.json')) as List;
      for (final entry in manifest) {
        final loader = FontLoader(entry['family'] as String);
        for (final font in entry['fonts']) {
          loader.addFont(rootBundle.load(font['asset'] as String));
        }
        await loader.load();
      }
    }
    final capture = GlobalKey();
    const examples = [
      (0.0, '応募金額 ¥0（0.00%）'),
      (0.385, '応募金額 ¥38,500,000（38.50%）'),
      (0.85, '応募金額 ¥85,000,000（85.00%）'),
      (1.0, '応募金額 ¥100,000,000（100.00%）'),
      (1.1265, '応募金額 ¥112,650,000（112.65%）'),
    ];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeFactory.light(locale: const Locale('ja')),
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: capture,
              child: Builder(
                builder: (context) => Container(
                  width: 370,
                  color: context.appColors.surface,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12,
                    children: [
                      for (final example in examples)
                        FundSubscriptionProgressBar(
                          ratio: example.$1,
                          label: example.$2,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    Color? previousFill;
    for (final example in examples) {
      final bar = find.bySemanticsLabel(example.$2);
      expect(bar, findsOneWidget);
      final fill = find.descendant(
        of: bar,
        matching: find.byType(FractionallySizedBox),
      );
      final paint = find.descendant(
        of: fill,
        matching: find.byType(DecoratedBox),
      );
      final decoration =
          tester.widget<DecoratedBox>(paint).decoration as BoxDecoration;
      expect(decoration.gradient, isNull);
      final color = decoration.color!;
      if (example.$1 >= 1) {
        expect(color, AppColorTokens.brandPurple);
      }
      if (previousFill != null && example.$1 <= 1) {
        expect(
          color.computeLuminance(),
          lessThan(previousFill.computeLuminance()),
        );
      }
      previousFill = color;
      expect(
        tester.getSize(paint).width,
        closeTo(tester.getSize(fill).width * example.$1.clamp(0, 1), 0.01),
      );
    }
    if (output != null) {
      final boundary =
          capture.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 3);
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        await File(output).writeAsBytes(data!.buffer.asUint8List());
        image.dispose();
      });
    }
  });
}
