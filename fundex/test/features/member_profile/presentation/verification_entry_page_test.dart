import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/domain/repositories/verification_entry_repository.dart';
import 'package:fundex/features/member_profile/presentation/pages/verification_entry_page.dart';
import 'package:fundex/features/member_profile/presentation/providers/verification_entry_provider.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:fundex/features/member_profile/domain/entities/corporate_form_draft.dart';
import 'package:fundex/features/member_profile/presentation/pages/corporate_progress_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  for (final progress in [false, true]) {
    testWidgets(
      'confirmed account sees completion and destinations from progress=$progress',
      (t) async {
        final router = GoRouter(
          initialLocation: '/profile/settings',
          routes: [
            GoRoute(
              path: '/profile/settings',
              builder: (_, _) => const Scaffold(body: Text('Settings')),
            ),
            GoRoute(
              path: '/member-profile/edit',
              builder: (_, _) => progress
                  ? const CorporateProgressPage()
                  : const VerificationEntryPage(),
            ),
            for (final path in ['/funds', '/profile'])
              GoRoute(
                path: path,
                builder: (_, _) => Scaffold(body: Text(path)),
              ),
          ],
        );
        addTearDown(router.dispose);
        final status = StateProvider<String>((_) => 'RECEIVED');
        final container = ProviderContainer(
          overrides: [
            verificationEntryProvider.overrideWith(
              (ref) async => VerificationEntry(
                VerificationEntryKind.corporate,
                status: ref.watch(status),
                companyName: '確認株式会社',
                submittedForm: CorporateFormDraft(companyName: '確認株式会社'),
              ),
            ),
          ],
        );
        addTearDown(container.dispose);
        await t.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(
              theme: AppThemeFactory.light(),
              routerConfig: router,
              locale: const Locale('ja'),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
            ),
          ),
        );
        await t.pumpAndSettle();
        router.push('/member-profile/edit');
        await t.pumpAndSettle();
        final l = AppLocalizations.of(t.element(find.byType(Scaffold).first));
        expect(find.byType(CorporateProgressPage), findsOneWidget);
        expect(find.text(l.corpVerifiedTitle), findsNothing);
        if (progress) {
          await t.tap(find.byTooltip(l.commonClose));
          await t.pumpAndSettle();
          expect(find.text('Settings'), findsOneWidget);
          expect(find.text(l.corpExitTitle), findsNothing);
          router.push('/member-profile/edit');
          await t.pumpAndSettle();
        }
        container.read(status.notifier).state = 'CONFIRMED';
        await t.pumpAndSettle();
        expect(find.text(l.corpVerifiedTitle), findsOneWidget);
        expect(find.text('確認株式会社'), findsOneWidget);
        Future<void> tap(String label) async {
          final item = find.widgetWithText(AppButton, label);
          await t.scrollUntilVisible(item, 200);
          await t.ensureVisible(item);
          await t.pumpAndSettle();
          await t.tap(item);
          await t.pumpAndSettle();
        }

        await tap(l.corpVerifiedView);
        expect(find.text(l.corpDetailTitle), findsOneWidget);
        await t.binding.handlePopRoute();
        await t.pumpAndSettle();
        await tap(progress ? l.commonClose : l.corpVerifiedFunds);
        expect(find.text(progress ? 'Settings' : '/funds'), findsOneWidget);
      },
    );
  }
  testWidgets('member choice opens corporate preparation and personal intake', (
    tester,
  ) async {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const VerificationEntryPage()),
        GoRoute(
          path: '/profile',
          builder: (_, __) => const Scaffold(body: Text('My Page')),
        ),
        GoRoute(
          path: '/member-profile/onboarding',
          builder: (_, __) => const Scaffold(body: Text('personal intake')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          verificationEntryProvider.overrideWith(
            (ref) async =>
                const VerificationEntry(VerificationEntryKind.choice),
          ),
        ],
        child: MaterialApp.router(
          theme: AppThemeFactory.light(locale: const Locale('ja')),
          routerConfig: router,
          locale: const Locale('ja'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(VerificationEntryPage));
    final l = AppLocalizations.of(context);
    await tester.tap(find.text(l.corporateInvestor));
    await tester.pump();
    await tester.tap(find.text(l.profileNextStep));
    await tester.pumpAndSettle();
    expect(find.text(l.corporatePrepareTitle), findsOneWidget);
    await tester.ensureVisible(find.text(l.corpFormStart));
    await tester.tap(find.text(l.corpFormStart));
    await tester.pumpAndSettle();
    expect(find.text(l.corpFormBusinessName), findsOneWidget);
    final rail = find.byType(AppStepProgressBar);
    final rect = tester.getRect(rail);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    expect(tester.getRect(rail), rect);
    await tester.tap(find.byTooltip(l.commonClose));
    await tester.pumpAndSettle();
    expect(find.text(l.corpExitDraft), findsOneWidget);
    await tester.tap(find.text(l.corpExitStay));
    await tester.pumpAndSettle();
    expect(tester.getRect(rail), rect);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l.commonClose));
    await tester.pumpAndSettle();
    expect(find.text(l.corpExitTitle), findsNothing);
    expect(find.byType(VerificationEntryPage), findsOneWidget);
    router.go('/');
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.personalInvestor));
    await tester.pump();
    await tester.tap(find.text(l.profileNextStep));
    await tester.pumpAndSettle();
    expect(find.text('personal intake'), findsOneWidget);
  });
}
