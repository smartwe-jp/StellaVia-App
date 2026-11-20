import 'package:fundex/features/member_profile/presentation/pages/corporate_form_page.dart';
import 'package:fundex/features/member_profile/domain/entities/corporate_form_draft.dart';
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
import 'package:fundex/features/member_profile/presentation/providers/verification_entry_provider.dart';

import 'package:core_storage/core_storage.dart';
import 'package:fundex/app/storage/app_storage_providers.dart';
import 'package:fundex/features/member_profile/presentation/providers/corporate_draft_providers.dart';

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
    'confirmed',
    'directPersonal',
  ]) {
    testWidgets('home verification action $action', (t) async {
      var entry = (action == 'existing' || action == 'confirmed')
          ? VerificationEntry(
              VerificationEntryKind.corporate,
              applicationId: 123,
              submittedForm: CorporateFormDraft(
                companyName: '登録済み株式会社',
                sourceApplicationId: 123,
              ),
              status: action == 'confirmed' ? 'CONFIRMED' : 'REJECTED',
            )
          : action == 'directPersonal'
          ? const VerificationEntry(
              VerificationEntryKind.personal,
              personalStatus: 3,
            )
          : const VerificationEntry(VerificationEntryKind.choice);
      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, _) => const Scaffold(body: HomeVerificationReminder()),
          ),
          GoRoute(
            path: '/member-profile/onboarding',
            builder: (_, _) =>
                const Scaffold(body: Text('/member-profile/onboarding')),
          ),
        ],
      );
      addTearDown(router.dispose);
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            corporateDraftAccountProvider.overrideWith((_) async => 'account1'),
            secureKeyValueStorageProvider.overrideWithValue(
              InMemoryKeyValueStorage(),
            ),
            homeVerificationReminderProvider.overrideWith((_) async => entry),
            verificationEntryProvider.overrideWith((_) async => entry),
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
      if (action == 'confirmed') {
        expect(find.text(l.homeReminderProfileTitle), findsNothing);
        return;
      }
      await t.tap(find.text(l.homeReminderProfileTitle));
      await t.pumpAndSettle();
      Future<void> expectExitToHome() async {
        await t.tap(find.byTooltip(l.commonClose));
        await t.pumpAndSettle();
        await t.tap(find.text(l.commonClose));
        await t.pumpAndSettle();
        expect(find.byType(HomeVerificationReminder), findsOneWidget);
        expect(router.state.matchedLocation, '/home');
        expect(router.canPop(), isFalse);
      }

      if (action == 'existing') {
        expect(find.byType(CupertinoAlertDialog), findsNothing);
        expect(find.text(l.corporatePrepareTitle), findsOneWidget);
        await t.ensureVisible(find.text(l.corpFormStart));
        await t.tap(find.text(l.corpFormStart));
        await t.pumpAndSettle();
        expect(find.text('登録済み株式会社'), findsOneWidget);
        final draft = t
            .widget<CorporateFormPage>(find.byType(CorporateFormPage))
            .draft;
        expect(draft.isCorrection, isTrue);
        expect(draft.sourceApplicationId, 123);
        expect(draft.sections, isNot(contains(CorporateSection.bank)));
        await expectExitToHome();
        return;
      }
      if (action == 'directPersonal') {
        expect(find.byType(CupertinoAlertDialog), findsNothing);
        expect(
          router.state.uri.toString(),
          '/member-profile/onboarding?start=first',
        );
        router.pop();
        await t.pumpAndSettle();
        expect(router.state.matchedLocation, '/home');
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
          'changed' => l.corporatePrepareTitle,
          _ => '/member-profile/onboarding',
        }),
        findsOneWidget,
      );
      if (action == 'corporate') {
        final route =
            ModalRoute.of(t.element(find.text(l.corporatePrepareTitle)))
                as PageRoute;
        expect(route.fullscreenDialog, isTrue);
        await t.ensureVisible(find.text(l.corpFormStart));
        await t.tap(find.text(l.corpFormStart));
        await t.pumpAndSettle();
        final name = find
            .byKey(const ValueKey(CorporateField.businessName))
            .last;
        await t.ensureVisible(name);
        await t.enterText(name, '保存株式会社');
        await expectExitToHome();
        await t.tap(find.text(l.homeReminderProfileTitle));
        await t.pumpAndSettle();
        await t.tap(find.text(l.corporateInvestor));
        await t.pumpAndSettle();
        await t.ensureVisible(find.text(l.corpFormStart));
        await t.tap(find.text(l.corpFormStart));
        await t.pumpAndSettle();
        expect(find.text('保存株式会社'), findsOneWidget);
        await expectExitToHome();
      }
    });
  }
}
