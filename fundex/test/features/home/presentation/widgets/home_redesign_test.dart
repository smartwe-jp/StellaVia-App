import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:fundex/features/home/presentation/support/home_design_theme.dart';
import 'package:fundex/features/home/presentation/widgets/home_brand_intro.dart';
import 'package:fundex/features/home/presentation/widgets/home_redesign_header.dart';
import 'package:fundex/features/home/presentation/widgets/home_quick_actions.dart';
import 'package:fundex/features/home/presentation/widgets/home_miles_card.dart';
import 'package:fundex/features/home/presentation/widgets/home_simulation_card.dart';

void main() {
  testWidgets(
    'home sections fit small screens and localized text; actions remain usable',
    (tester) async {
      final manifest =
          jsonDecode(await rootBundle.loadString('FontManifest.json'))
              as List<dynamic>;
      for (final entry in manifest.cast<Map<String, dynamic>>()) {
        final loader = FontLoader(entry['family'] as String);
        for (final font in entry['fonts'] as List<dynamic>) {
          loader.addFont(rootBundle.load(font['asset'] as String));
        }
        await loader.load();
      }
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var taps = 0;
      var settingsTaps = 0;
      for (final locale in AppLocalizations.supportedLocales) {
        for (final member in [true, false]) {
          for (final width in [390.0, 320.0]) {
            final key = GlobalKey();
            tester.view.physicalSize = Size(width, 1100);
            await tester.pumpWidget(
              MaterialApp(
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: AppThemeFactory.light(locale: locale),
                home: Builder(
                  builder: (context) => RepaintBoundary(
                    key: key,
                    child: Scaffold(
                      backgroundColor: HomeDesignTheme.background(context),
                      body: MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaler: TextScaler.linear(width == 320 ? 1.3 : 1),
                        ),
                        child: Column(
                          children: [
                            HomeRedesignHeader(
                              isAuthenticated: member,
                              unreadCount: 2,
                              onLogin: () => taps++,
                              onSettings: () => settingsTaps++,
                              onNotifications: () => taps++,
                            ),
                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.all(16),
                                children: [
                                  HomeBrandIntro(
                                    ranks: const [
                                      'REGULAR',
                                      'BRONZE',
                                      'SILVER',
                                      'GOLD',
                                      'MASTER',
                                    ],
                                    onServiceTap: () => taps++,
                                  ),
                                  const SizedBox(height: 20),
                                  if (member)
                                    HomeQuickActions(
                                      onFunds: () => taps++,
                                      onHotels: () => taps++,
                                    ),
                                  const SizedBox(height: 20),
                                  if (member)
                                    HomeMilesCard(onTap: () => taps++)
                                  else
                                    HomeSimulationCard(onTap: () => taps++),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            expect(
              tester.takeException(),
              isNull,
              reason: '$locale member=$member width=$width',
            );
            final context = tester.element(find.byType(HomeBrandIntro));
            final l10n = AppLocalizations.of(context);
            final settings = find.byTooltip(l10n.mainTabSettings);
            if (member) {
              expect(settings, findsNothing);
            } else {
              expect(
                tester.getTopLeft(settings).dx,
                greaterThanOrEqualTo(
                  tester.getTopRight(find.text(l10n.loginSubmit)).dx,
                ),
              );
              final before = settingsTaps;
              await tester.tap(settings);
              expect(settingsTaps, before + 1);
            }
            final label = AppLocalizations.of(context).homeLearnService;
            expect(
              find.text(AppLocalizations.of(context).homeRankDetails),
              findsNothing,
            );
            final names = ['REGULAR', 'BRONZE', 'SILVER', 'GOLD', 'MASTER'];
            for (var i = 0; i < names.length - 1; i++) {
              final right = tester.getTopRight(find.text(names[i])).dx;
              final nextCard = find
                  .ancestor(
                    of: find.text(names[i + 1]),
                    matching: find.byType(Positioned),
                  )
                  .first;
              expect(right, lessThanOrEqualTo(tester.getTopLeft(nextCard).dx));
            }
            expect(
              tester.getBottomLeft(find.text('MASTER')).dy,
              lessThan(tester.getTopLeft(find.text(label)).dy),
            );
            await tester.ensureVisible(find.text(label));
            await tester.tap(find.text(label));
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            final output = Platform.environment['HOME_PREVIEW_DIR'];
            if (output != null && locale.languageCode == 'ja' && width == 390) {
              final boundary =
                  key.currentContext!.findRenderObject()!
                      as RenderRepaintBoundary;
              await tester.runAsync(() async {
                final image = await boundary.toImage();
                final bytes = await image.toByteData(
                  format: ui.ImageByteFormat.png,
                );
                await Directory(output).create(recursive: true);
                await File(
                  '$output/${member ? 'member' : 'guest'}.png',
                ).writeAsBytes(bytes!.buffer.asUint8List());
                image.dispose();
              });
            }
          }
        }
      }
      expect(taps, AppLocalizations.supportedLocales.length * 4);
    },
  );
}
