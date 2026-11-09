import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/home/presentation/support/home_featured_fund_card_mapper.dart';
import 'package:fundex/features/investment/domain/entities/fund_project.dart';
import 'package:fundex/features/investment/presentation/support/fund_project_detail_view_data.dart';
import 'package:fundex/features/member_profile/presentation/support/mypage_section_support.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets('fund status colors match across surfaces (dark: $dark)', (
      tester,
    ) async {
      const locale = Locale('ja');
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: dark
              ? AppThemeFactory.dark(locale: locale)
              : AppThemeFactory.light(locale: locale),
          home: const Scaffold(),
        ),
      );
      final context = tester.element(find.byType(Scaffold));
      final l10n = AppLocalizations.of(context);
      final colors = context.appColors;
      final cases = [
        (
          0,
          l10n.fundListStatusUpcoming,
          const Color(0xFFEEE9E1),
          const Color(0xFF4C0679),
        ),
        (1, l10n.fundListStatusOpen, const Color(0xFF4C0679), Colors.white),
        (3, l10n.fundListStatusClosed, const Color(0xFF979797), Colors.white),
        (
          4,
          l10n.fundListStatusOperating,
          const Color(0xFF070E2B),
          Colors.white,
        ),
        (
          5,
          l10n.fundListStatusOperatingEnded,
          const Color(0xFF979797),
          Colors.white,
        ),
        (
          7,
          l10n.fundListStatusCompleted,
          const Color(0xFF979797),
          Colors.white,
        ),
        (
          2,
          l10n.fundListStatusFailed,
          colors.dangerSubtle,
          colors.dangerForeground,
        ),
        (
          null,
          l10n.fundListStatusUnknown,
          colors.surfaceAlt,
          colors.textSecondary,
        ),
        (
          99,
          l10n.fundListStatusUnknown,
          colors.surfaceAlt,
          colors.textSecondary,
        ),
      ];
      for (final (code, label, background, foreground) in cases) {
        final project = FundProject(
          id: 'test',
          projectName: 'Fund',
          projectStatus: code,
        );
        final home = buildHomeFeaturedFundCardData(context, project).tags.first;
        final detail = FundProjectDetailViewDataBuilder.build(
          context: context,
          project: project,
        ).heroBadges.first;
        final expected = (label, background, foreground);
        expect((
          home.label,
          home.backgroundColor,
          home.foregroundColor,
        ), expected);
        expect((
          detail.label,
          detail.backgroundColor,
          detail.foregroundColor,
        ), expected);
        expect((
          resolveMyPageActiveFundStatusLabel(l10n, code),
          resolveMyPageActiveFundStatusBackgroundColor(context, code),
          resolveMyPageActiveFundStatusForegroundColor(context, code),
        ), expected);
      }
      expect(
        resolveMyPageActiveFundStatusLabel(l10n, 4, investNumValid: 0),
        l10n.myPageActiveFundRedeemedStatus,
      );
      expect(
        resolveMyPageActiveFundStatusBackgroundColor(
          context,
          4,
          investNumValid: 0,
        ),
        colors.surfaceAlt,
      );
      expect(
        resolveMyPageActiveFundStatusForegroundColor(
          context,
          4,
          investNumValid: 0,
        ),
        colors.textSecondary,
      );
    });
  }
}
