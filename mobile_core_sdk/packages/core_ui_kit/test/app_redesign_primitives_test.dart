import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('card keeps legacy defaults and nested actions independent', (
    tester,
  ) async {
    var outer = 0;
    var inner = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeFactory.light(),
        home: Scaffold(
          body: AppCard(
            onTap: () => outer++,
            child: Column(
              children: [
                const Text('outer'),
                TextButton(
                  onPressed: () => inner++,
                  child: const Text('inner'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    final material = tester.widget<Material>(
      find
          .descendant(of: find.byType(AppCard), matching: find.byType(Material))
          .first,
    );
    final shape = material.shape! as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(16));
    expect(shape.side.style, BorderStyle.solid);
    await tester.tap(find.text('inner'));
    expect(inner, 1);
    expect(outer, 0);
    await tester.tap(find.text('outer'));
    expect(outer, 1);
  });

  testWidgets('filled card respects themed customization in both modes', (
    tester,
  ) async {
    for (final theme in [AppThemeFactory.light(), AppThemeFactory.dark()]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Builder(
              builder: (context) => AppCard(
                variant: AppCardVariant.filled,
                backgroundColor: context.appColors.surfaceAlt,
                borderRadius: BorderRadius.circular(20),
                child: const Text('content'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(AppCard),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(material.color, theme.appColors.surfaceAlt);
      final shape = material.shape! as RoundedRectangleBorder;
      expect(shape.side, BorderSide.none);
      expect(shape.borderRadius, BorderRadius.circular(20));
    }
  });

  testWidgets('slider and captioned segments update and honor disabled state', (
    tester,
  ) async {
    var value = .25;
    var selected = 0;
    var enabled = true;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeFactory.light(),
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return Column(
                children: [
                  AppSlider(
                    value: value,
                    min: 0,
                    max: 1,
                    divisions: 4,
                    onChanged: enabled
                        ? (next) => setState(() => value = next)
                        : null,
                  ),
                  AppTwoLineSegmentedControl<int>(
                    value: selected,
                    first: const AppTwoLineSegmentItem(
                      value: 0,
                      label: 'First',
                      caption: 'First caption',
                    ),
                    second: const AppTwoLineSegmentItem(
                      value: 1,
                      label: 'Second',
                      caption: 'Second caption',
                    ),
                    onChanged: enabled
                        ? (next) => setState(() => selected = next)
                        : null,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
    await tester.drag(find.byType(Slider), const Offset(160, 0));
    await tester.pumpAndSettle();
    expect(value, greaterThan(.25));
    await tester.tap(find.text('Second caption'));
    await tester.pump();
    expect(selected, 1);
    final lastValue = value;
    update(() => enabled = false);
    await tester.pump();
    await tester.tap(find.text('First'));
    await tester.drag(find.byType(Slider), const Offset(-160, 0));
    await tester.pumpAndSettle();
    expect(selected, 1);
    expect(value, lastValue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selection pill travels through intermediate positions', (
    tester,
  ) async {
    var selected = 0;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeFactory.light(),
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return SizedBox(
                width: 320,
                child: AppDualSegmentedControl<int>(
                  first: const AppDualSegmentItem(value: 0, label: "First"),
                  second: const AppDualSegmentItem(value: 1, label: "Second"),
                  value: selected,
                  onChanged: (v) => setState(() => selected = v),
                ),
              );
            },
          ),
        ),
      ),
    );
    final pill = find.byType(FractionallySizedBox);
    final left = tester.getTopLeft(pill).dx;
    update(() => selected = 1);
    await tester.pump();
    expect(tester.getTopLeft(pill).dx, left);
    await tester.pump(const Duration(milliseconds: 80));
    final middle = tester.getTopLeft(pill).dx;
    await tester.pumpAndSettle();
    final right = tester.getTopLeft(pill).dx;
    expect(middle, greaterThan(left));
    expect(middle, lessThan(right));
    update(() => selected = 0);
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(pill).dx, left);
  });
}
