import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/features/home/presentation/support/home_member_profile_reminder_support.dart';
import 'package:fundex/features/home/presentation/widgets/home_verification_reminder.dart';
import 'package:fundex/features/member_profile/domain/repositories/verification_entry_repository.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  test('reminder only appears for actionable verification states', () {
    for (final status in [null, 0, 2, 3, 4, 5]) {
      expect(
        shouldShowHomeMemberProfileReminder(
          VerificationEntry(
            VerificationEntryKind.personal,
            personalStatus: status,
          ),
        ),
        [0, 3].contains(status),
      );
    }
    for (final status in [
      null,
      '',
      'DRAFT',
      'EXPIRED',
      'REJECTED',
      'SUBMITTED',
      'APPROVED',
      'CUSTOMER_MAILED',
      'MAILED',
      'RECEIVED',
      'CONFIRMED',
      'unknown',
    ]) {
      expect(
        shouldShowHomeMemberProfileReminder(
          VerificationEntry(VerificationEntryKind.corporate, status: status),
        ),
        [null, '', 'DRAFT', 'EXPIRED', 'REJECTED'].contains(status),
      );
    }
  });
  for (final action in [
    'cancel',
    'personal',
    'corporate',
    'changed',
    'existing',
  ]) {
    testWidgets('home verification action $action', (t) async {
      var entry = action == 'existing'
          ? const VerificationEntry(
              VerificationEntryKind.corporate,
              status: 'REJECTED',
            )
          : const VerificationEntry(VerificationEntryKind.choice);
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(body: HomeVerificationReminder()),
          ),
          for (final path in [
            '/member-profile/onboarding',
            '/member-profile/edit',
          ])
            GoRoute(
              path: path,
              builder: (_, _) => Scaffold(body: Text(path)),
            ),
        ],
      );
      addTearDown(router.dispose);
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            homeVerificationReminderProvider.overrideWith((_) async => entry),
          ],
          child: MaterialApp.router(
            theme: AppThemeFactory.light().copyWith(
              platform: TargetPlatform.iOS,
            ),
            locale: const Locale('ja'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: router,
          ),
        ),
      );
      await t.pumpAndSettle();
      final l = AppLocalizations.of(
        t.element(find.byType(HomeVerificationReminder)),
      );
      await t.tap(find.text(l.homeReminderProfileTitle));
      await t.pumpAndSettle();
      if (action == 'existing') {
        expect(find.byType(CupertinoAlertDialog), findsNothing);
        expect(find.text('/member-profile/edit'), findsOneWidget);
        return;
      }
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.text(l.personalInvestor), findsOneWidget);
      expect(find.text(l.corporateInvestor), findsOneWidget);
      if (action == 'changed') {
        entry = const VerificationEntry(
          VerificationEntryKind.corporate,
          status: 'SUBMITTED',
        );
      }
      await t.tap(
        find.text(switch (action) {
          'cancel' => l.commonCancel,
          'corporate' => l.corporateInvestor,
          _ => l.personalInvestor,
        }),
      );
      await t.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsNothing);
      expect(
        find.text(switch (action) {
          'cancel' => l.homeReminderProfileTitle,
          'corporate' => l.corporatePrepareTitle,
          'changed' => '/member-profile/edit',
          _ => '/member-profile/onboarding',
        }),
        findsOneWidget,
      );
    });
  }
}
