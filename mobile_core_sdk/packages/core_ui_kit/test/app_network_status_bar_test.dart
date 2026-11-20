import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('inline network banner height follows content and text scale', (
    tester,
  ) async {
    Future<double> measure(EdgeInsets insets, double scale) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemeFactory.light(),
          home: MediaQuery(
            data: MediaQueryData(
              padding: insets,
              textScaler: TextScaler.linear(scale),
            ),
            child: const Material(
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 350,
                  child: SingleChildScrollView(
                    child: AppNetworkStatusBar(
                      title: 'ネットワークにアクセスできません',
                      message:
                          '接続状況を確認するか、iPhone の設定で StellaVia のネットワークアクセスを許可してください。',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      return tester.getSize(find.byType(AppNetworkStatusBar)).height;
    }

    const phoneInsets = EdgeInsets.only(top: 59, bottom: 34);
    final baseline = await measure(EdgeInsets.zero, 1);
    expect(await measure(phoneInsets, 1), baseline);
    expect(await measure(phoneInsets, 2), greaterThan(baseline));
  });
}
