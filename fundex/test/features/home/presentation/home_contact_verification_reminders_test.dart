import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/features/home/presentation/widgets/home_contact_verification_reminders.dart';
import 'package:fundex/features/settings/presentation/providers/settings_two_factor_providers.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  testWidgets(
    'contact reminders update independently and open their settings routes',
    (t) async {
      final email = StateProvider<bool>((_) => false);
      final phone = StateProvider<String?>((_) => '');
      final container = ProviderContainer(
        overrides: [
          settingsEmailVerifiedProvider.overrideWith(
            (ref) async => ref.watch(email),
          ),
          settingsRemoteVerificationStatusProvider.overrideWith((ref) async {
            final number = ref.watch(phone);
            return number == null
                ? null
                : AuthMemberLoginIndexDto.fromJson({
                    'phone': number,
                    'mobileAuth': 1,
                  });
          }),
        ],
      );
      addTearDown(container.dispose);
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) =>
                const Scaffold(body: HomeContactVerificationReminders()),
          ),
          for (final kind in ['email', 'phone'])
            GoRoute(
              path: '/profile/settings/two-factor/$kind',
              builder: (_, _) => Scaffold(body: Text(kind)),
            ),
        ],
      );
      addTearDown(router.dispose);
      await t.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            theme: AppThemeFactory.light(),
            locale: const Locale('ja'),
            routerConfig: router,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
          ),
        ),
      );
      await t.pumpAndSettle();
      final l = AppLocalizations.of(
        t.element(find.byType(HomeContactVerificationReminders)),
      );
      expect(find.byType(FundReminderCard), findsNWidgets(2));
      for (final (title, kind) in [
        (l.homeReminderEmailVerificationTitle, 'email'),
        (l.homeReminderPhoneVerificationTitle, 'phone'),
      ]) {
        await t.tap(find.text(title));
        await t.pumpAndSettle();
        expect(find.text(kind), findsOneWidget);
        router.pop();
        await t.pumpAndSettle();
      }
      container.read(phone.notifier).state = null;
      await t.pumpAndSettle();
      expect(find.text(l.homeReminderEmailVerificationTitle), findsOneWidget);
      expect(find.text(l.homeReminderPhoneVerificationTitle), findsNothing);
      container.read(email.notifier).state = true;
      container.read(phone.notifier).state = '';
      await t.pumpAndSettle();
      expect(find.text(l.homeReminderEmailVerificationTitle), findsNothing);
      expect(find.text(l.homeReminderPhoneVerificationTitle), findsOneWidget);
      container.read(phone.notifier).state = '09000000000';
      await t.pumpAndSettle();
      expect(find.byType(FundReminderCard), findsNothing);
    },
  );
}
