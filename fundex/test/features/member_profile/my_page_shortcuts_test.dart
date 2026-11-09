import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_shortcuts.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json')) as List;
    for (final entry in manifest) {
      final loader = FontLoader(entry['family'] as String);
      for (final font in entry['fonts']) {
        loader.addFont(rootBundle.load(font['asset'] as String));
      }
      await loader.load();
    }
  });
  testWidgets(
    'six shortcuts keep two rows and only existing destinations are actionable',
    (tester) async {
      final key = GlobalKey();
      final taps = <int>[];
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final locale in AppLocalizations.supportedLocales) {
        final japanese = locale.languageCode == 'ja';
        tester.view.physicalSize = Size(japanese ? 390 : 320, 650);
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppThemeFactory.light(locale: locale),
            home: Scaffold(
              body: Align(
                alignment: Alignment.topCenter,
                child: MediaQuery(
                  data: MediaQueryData(
                    textScaler: TextScaler.linear(japanese ? 1 : 1.3),
                  ),
                  child: RepaintBoundary(
                    key: key,
                    child: MyPageShortcuts(
                      onSummary: () => taps.add(0),
                      onFunds: () => taps.add(1),
                      onTrades: () => taps.add(2),
                      onMiles: () => taps.add(3),
                      onMember: () => taps.add(4),
                      onDocuments: () => taps.add(5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final buttons = find.descendant(
          of: find.byType(MyPageShortcuts),
          matching: find.byType(InkWell),
        );
        expect(buttons, findsNWidgets(6));
        final first = tester.getRect(buttons.at(0));
        final second = tester.getRect(buttons.at(3));
        for (var i = 0; i < 6; i++) {
          expect(
            tester.getRect(buttons.at(i)).top,
            i < 3 ? first.top : second.top,
          );
          await tester.tap(buttons.at(i));
        }
        expect(second.top, greaterThan(first.bottom));
        expect(taps, [0, 1, 2, 3, 4, 5]);
        expect(tester.takeException(), isNull);
        taps.clear();
        final preview = Platform.environment['MYPAGE_SHORTCUT_PREVIEW'];
        if (japanese && preview != null) {
          await tester.pumpAndSettle();
          await tester.runAsync(() async {
            final boundary =
                key.currentContext!.findRenderObject()!
                    as RenderRepaintBoundary;
            final image = await boundary.toImage();
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            await File(preview).writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
        }
      }
    },
  );
}
