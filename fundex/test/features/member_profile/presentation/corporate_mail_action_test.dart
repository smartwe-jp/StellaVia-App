import 'dart:async';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/domain/entities/corporate_form_draft.dart';
import 'package:fundex/features/member_profile/domain/repositories/verification_entry_repository.dart';
import 'package:fundex/features/member_profile/presentation/pages/corporate_progress_page.dart';
import 'package:fundex/features/member_profile/presentation/pages/corporate_mail_action_page.dart';
import 'package:fundex/features/member_profile/presentation/providers/verification_entry_provider.dart';
import 'package:fundex/l10n/app_localizations.dart';

class _MailRepo implements VerificationEntryRepository {
  _MailRepo(this.op);
  final CorporateMailAction op;
  final result = Completer<void>();
  int writes = 0, reads = 0;
  @override
  Future<VerificationEntry> load({bool afterSubmission = false}) async {
    reads++;
    final sent = op == CorporateMailAction.sent;
    return VerificationEntry(
      VerificationEntryKind.corporate,
      applicationId: 37,
      status: result.isCompleted
          ? (sent ? 'CUSTOMER_MAILED' : 'RECEIVED')
          : (sent ? 'SUBMITTED' : 'MAILED'),
      userOps: result.isCompleted ? {} : {op.code},
    );
  }

  @override
  Future<void> review({
    required int id,
    required CorporateMailAction action,
    required String message,
  }) {
    expect(id, 37);
    expect(action, op);
    expect(message, op == CorporateMailAction.sent ? '本日発送' : '');
    writes++;
    return result.future;
  }

  @override
  Future<void> submit(
    CorporateFormDraft draft, {
    required bool antiSocial,
    required bool mail,
  }) => throw UnimplementedError();
}

void main() {
  testWidgets(
    'confirmation is disabled if refreshed detail revokes the operation',
    (t) async {
      final repo = _MailRepo(CorporateMailAction.received);
      final granted = StateProvider<bool>((ref) => true);
      final container = ProviderContainer(
        overrides: [
          verificationEntryRepositoryProvider.overrideWithValue(repo),
          verificationEntryProvider.overrideWith(
            (ref) async => VerificationEntry(
              VerificationEntryKind.corporate,
              applicationId: 37,
              status: 'MAILED',
              userOps: ref.watch(granted) ? {'RECEIVED'} : {},
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      await t.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppThemeFactory.light(),
            locale: const Locale('ja'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const CorporateMailActionPage(
              id: 37,
              action: CorporateMailAction.received,
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      final l = AppLocalizations.of(
        t.element(find.byType(CorporateMailActionPage)),
      );
      final button = find.widgetWithText(AppButton, l.corpMailConfirm);
      final oldCallback = t.widget<AppButton>(button).onPressed!;
      container.read(granted.notifier).state = false;
      await t.pumpAndSettle();
      expect(t.widget<AppButton>(button).onPressed, isNull);
      oldCallback();
      await t.pump();
      expect(repo.writes, 0);
    },
  );
  for (final op in CorporateMailAction.values) {
    testWidgets(
      'mail action ${op.code} checks input and refreshes detail once',
      (t) async {
        final repo = _MailRepo(op);
        await t.pumpWidget(
          ProviderScope(
            overrides: [
              verificationEntryRepositoryProvider.overrideWithValue(repo),
              verificationEntryProvider.overrideWith((_) => repo.load()),
            ],
            child: MaterialApp(
              theme: AppThemeFactory.light(),
              locale: const Locale('ja'),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: const CorporateProgressPage(),
            ),
          ),
        );
        await t.pumpAndSettle();
        final l = AppLocalizations.of(
          t.element(find.byType(CorporateProgressPage)),
        );
        final sent = op == CorporateMailAction.sent;
        final action = sent ? l.corpMailSent : l.corpMailReceived;
        Future<void> tap(String label) async {
          final target = find.text(label);
          if (target.evaluate().isEmpty) {
            await t.scrollUntilVisible(
              target,
              280,
              scrollable: find.byType(Scrollable).first,
            );
          }
          await t.ensureVisible(target);
          await t.pumpAndSettle();
          if (target.hitTestable().evaluate().isEmpty) {
            await t.drag(find.byType(Scrollable).first, const Offset(0, -240));
            await t.pumpAndSettle();
          }
          await t.tap(target.hitTestable());
          await t.pumpAndSettle();
        }

        await tap(action);
        expect(repo.writes, 0);
        await tap(sent ? l.commonCancel : l.corpMailNotYet);
        expect(find.byType(CorporateProgressPage), findsOneWidget);
        expect(repo.writes, 0);
        expect(
          find.text(sent ? l.corpMailReceived : l.corpMailSent),
          findsNothing,
        );
        await tap(action);
        final submit = find.widgetWithText(
          AppButton,
          sent ? l.corpMailSubmit : l.corpMailConfirm,
        );
        if (sent) {
          await t.enterText(find.byType(TextField), '    ');
          await t.pump();
          expect(t.widget<AppButton>(submit).onPressed, isNull);
          await t.enterText(find.byType(TextField), '  本日発送  ');
          await t.pump();
        }
        final confirm = t.widget<AppButton>(submit).onPressed!;
        confirm();
        confirm();
        await t.pump();
        expect(repo.writes, 1);
        repo.result.complete();
        await t.pumpAndSettle();
        expect(repo.reads, 2);
        expect(find.text(action), findsNothing);
        expect(find.byType(CorporateProgressPage), findsOneWidget);
        expect(
          find.text(l.corporateStatus(sent ? 'CUSTOMER_MAILED' : 'RECEIVED')),
          findsWidgets,
        );
      },
    );
  }
}
