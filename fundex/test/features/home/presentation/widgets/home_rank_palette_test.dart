import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/home/presentation/widgets/home_rank_teaser.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      'rank previews follow API codes in a partial catalog (dark: $dark)',
      (tester) async {
        const locale = Locale('ja');
        await tester.pumpWidget(
          MaterialApp(
            theme: dark
                ? AppThemeFactory.dark(locale: locale)
                : AppThemeFactory.light(locale: locale),
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: HomeRankTeaser(
                names: const ['MASTER', ' gold ', 'NEW', 'REGULAR'],
                onTap: () {},
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.text('RANK 05'), findsOneWidget);
        expect(find.text('RANK 04'), findsOneWidget);
        expect(find.text('RANK 01'), findsOneWidget);
        expect(find.text('RANK 03'), findsNothing);
        expect(find.text('NEW'), findsOneWidget);
        final decorations = tester
            .widgetList<Container>(find.byType(Container))
            .map((w) => w.decoration)
            .whereType<BoxDecoration>();
        final master = decorations.singleWhere((d) => d.gradient != null);
        expect((master.gradient as LinearGradient).colors, const [
          Color(0xFF1E0533),
          Color(0xFF3A0A5C),
        ]);
        expect(
          (master.border as Border).bottom,
          const BorderSide(color: Color(0xFF9652C2), width: 2),
        );
        expect(
          decorations.map((d) => d.color),
          contains(const Color(0xFF9C6A10)),
        );
        expect(
          decorations.map((d) => d.color),
          contains(const Color(0xFFF4EDE1)),
        );
      },
    );
  }
}
