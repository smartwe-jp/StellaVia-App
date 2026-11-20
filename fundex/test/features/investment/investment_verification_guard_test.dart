import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/features/investment/presentation/support/investment_verification_guard.dart';
import 'package:fundex/features/member_profile/domain/repositories/verification_entry_repository.dart';
import 'package:fundex/features/member_profile/presentation/providers/verification_entry_provider.dart';
import 'package:fundex/l10n/app_localizations.dart';

class _Verification extends Fake implements VerificationEntryRepository {
  String? status = 'CONFIRMED';
  var calls = 0;
  @override
  Future<VerificationEntry> load({bool afterSubmission = false}) async {
    calls++;
    return VerificationEntry(
      VerificationEntryKind.corporate,
      status: status,
      personalStatus: 4,
    );
  }
}

void main() {
  for (final action in InvestmentAction.values) {
    test('only CONFIRMED permits a corporate ${action.name}', () {
      for (final status in [
        null,
        '',
        'DRAFT',
        'SUBMITTED',
        'APPROVED',
        'CUSTOMER_MAILED',
        'ADMIN_MAILED',
        'MAILED',
        'RECEIVED',
        'REJECTED',
        'EXPIRED',
        'unknown',
        'CONFIRMED',
      ]) {
        expect(
          canProceedWithInvestment(
            VerificationEntry(
              VerificationEntryKind.corporate,
              status: status,
              personalStatus: status == 'CONFIRMED' ? 1 : 4,
            ),
            action,
          ),
          status == 'CONFIRMED',
          reason: status,
        );
      }
    });
    test('personal ${action.name} retains its existing eligibility', () {
      for (final status in [null, 0, 1, 2, 3, 4, 5]) {
        final entry = VerificationEntry(
          status == 1
              ? VerificationEntryKind.choice
              : VerificationEntryKind.personal,
          personalStatus: status,
        );
        expect(
          canProceedWithInvestment(entry, action),
          action == InvestmentAction.secondaryPurchase ||
              status == 4 ||
              status == 5,
        );
      }
    });
    testWidgets('${action.name} rechecks and offers application progress', (
      t,
    ) async {
      final repository = _Verification();
      var allowed = 0;
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, state) => Consumer(
              builder: (context, ref, _) => Scaffold(
                body: TextButton(
                  child: const Text('invest'),
                  onPressed: () async {
                    if (await checkInvestmentAccess(context, ref, action) !=
                        null) {
                      allowed++;
                    }
                  },
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/member-profile/edit',
            builder: (_, state) => const Scaffold(body: Text('profile')),
          ),
        ],
      );
      addTearDown(router.dispose);
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            verificationEntryRepositoryProvider.overrideWithValue(repository),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            locale: const Locale('ja'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
          ),
        ),
      );
      await t.pumpAndSettle();
      final l = AppLocalizations.of(t.element(find.text('invest')));
      await t.tap(find.text('invest'));
      await t.pumpAndSettle();
      expect(allowed, 1);
      repository.status = 'RECEIVED';
      await t.tap(find.text('invest'));
      await t.pumpAndSettle();
      expect(
        find.text(l.corporateInvestmentVerificationRequired),
        findsOneWidget,
      );
      await t.tap(find.text(l.menuItemEditProfile));
      await t.pumpAndSettle();
      expect(find.text('profile'), findsOneWidget);
      router.pop();
      await t.pumpAndSettle();
      expect(allowed, 1);
      expect(repository.calls, 2);
    });
  }
}
