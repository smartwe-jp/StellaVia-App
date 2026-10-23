import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('bundled brand fonts render with both theme mappings', (
    tester,
  ) async {
    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json'))
            as List<dynamic>;
    for (final family in [
      'Jost',
      'Zen Kaku Gothic Antique',
      'Noto Sans SC',
      'Noto Sans TC',
    ]) {
      final entry = manifest.cast<Map<String, dynamic>>().singleWhere(
        (entry) => entry['family'] == family,
      );
      final loader = FontLoader(family);
      for (final font in entry['fonts'] as List<dynamic>) {
        final data = await rootBundle.load(font['asset'] as String);
        expect(data.lengthInBytes, greaterThan(1000));
        loader.addFont(Future.value(data));
      }
      await loader.load();
    }
    for (final license in ['Jost-OFL.txt', 'ZenKakuGothicAntique-OFL.txt']) {
      expect(
        await rootBundle.loadString('assets/fonts/$license'),
        contains('SIL OPEN FONT LICENSE'),
      );
    }
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final brightness in Brightness.values) {
      final theme = brightness == Brightness.light
          ? AppThemeFactory.light(locale: const Locale('ja'))
          : AppThemeFactory.dark(locale: const Locale('ja'));
      final colors = theme.extension<AppSemanticColorTheme>()!;
      final text = theme.extension<AppSemanticTextTheme>()!;
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: RepaintBoundary(
            key: key,
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Text('STELLAVIA', style: text.numericHeadline),
                    Text('未来の安心も、今の楽しみも。', style: text.pageTitle),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('運用残高 / BALANCE', style: text.bodyMuted),
                            Text('1,234,567 円', style: text.numericHeadline),
                            Text('想定利回り 6.0%', style: text.body),
                            const SizedBox(height: 12),
                            Text('詳しく見る →', style: text.link),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: colors.surfaceAlt,
                      child: Text('宿泊予約・お知らせ\n简体中文 / 繁體中文', style: text.helper),
                    ),
                    const SizedBox(height: 20),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'メールアドレス',
                        hintText: 'example@email.com',
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(onPressed: () {}, child: const Text('次へ')),
                    const SizedBox(height: 12),
                    OutlinedButton(onPressed: () {}, child: const Text('戻る')),
                    const SizedBox(height: 12),
                    const FilledButton(
                      onPressed: null,
                      child: Text('入力してください'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      // Optional local QA artifact; CI only checks assets and rendering.
      final output = Platform.environment['STELLAVIA_THEME_PREVIEW_DIR'];
      if (output != null) {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final image = await boundary.toImage();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await Directory(output).create(recursive: true);
          await File(
            '$output/${brightness.name}.png',
          ).writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
    }
  });
}
