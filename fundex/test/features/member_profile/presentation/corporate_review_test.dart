import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:fundex/features/member_profile/domain/entities/corporate_form_draft.dart';
import 'package:fundex/features/member_profile/domain/repositories/verification_entry_repository.dart';
import 'package:fundex/features/member_profile/presentation/pages/corporate_review_page.dart';
import 'package:fundex/features/member_profile/presentation/pages/corporate_progress_page.dart';
import 'package:fundex/features/member_profile/presentation/widgets/corporate_progress_timeline.dart';
import 'package:fundex/features/member_profile/presentation/providers/verification_entry_provider.dart';
import 'package:fundex/l10n/app_localizations.dart';

class _Repository implements VerificationEntryRepository {
  int writes = 0, detailReads = 0;
  final response = Completer<void>();
  @override
  Future<void> review({
    required int id,
    required CorporateMailAction action,
    required String message,
  }) => throw UnimplementedError();
  @override
  Future<void> submit(
    CorporateFormDraft draft, {
    required bool antiSocial,
    required bool mail,
  }) {
    expect(antiSocial && mail, isTrue);
    writes++;
    return response.future;
  }

  @override
  Future<VerificationEntry> load({bool afterSubmission = false}) async {
    if (afterSubmission) detailReads++;
    return VerificationEntry(
      VerificationEntryKind.corporate,
      status: afterSubmission ? 'SUBMITTED' : 'DRAFT',
      userOps: afterSubmission ? {'CUSTOMER_MAILED'} : {},
    );
  }
}

void main() {
  testWidgets(
    'requires both declarations, submits once and returns to refreshed detail',
    (tester) async {
      final repo = _Repository();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verificationEntryRepositoryProvider.overrideWithValue(repo),
            corporateSubmittedProvider.overrideWith((ref) => false),
            verificationEntryProvider.overrideWith(
              (ref) => repo.load(
                afterSubmission: ref.watch(corporateSubmittedProvider),
              ),
            ),
          ],
          child: MaterialApp(
            theme: AppThemeFactory.light(),
            locale: const Locale('ja'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Consumer(
              builder: (context, ref, _) => Scaffold(
                body: Column(
                  children: [
                    Text(
                      ref
                              .watch(verificationEntryProvider)
                              .valueOrNull
                              ?.status ??
                          '',
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          settings: const RouteSettings(
                            name: 'corporate-verification/review',
                          ),
                          builder: (_) =>
                              CorporateReviewPage(draft: CorporateFormDraft()),
                        ),
                      ),
                      child: const Text('review'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('review'));
      await tester.pumpAndSettle();
      final l = AppLocalizations.of(
        tester.element(find.byType(CorporateReviewPage)),
      );
      await tester.scrollUntilVisible(
        find.text(l.corpReviewSubmit),
        400,
        scrollable: find.byType(Scrollable).first,
      );
      final button = find.widgetWithText(AppButton, l.corpReviewSubmit);
      expect(tester.widget<AppButton>(button).onPressed, isNull);
      for (final label in [l.corpReviewAnti, l.corpReviewMail]) {
        final target = find.text(label);
        await tester.ensureVisible(target);
        await tester.tap(target);
        await tester.pump();
      }
      final send = tester.widget<AppButton>(button).onPressed!;
      send();
      send();
      await tester.pump();
      expect(repo.writes, 1);
      repo.response.complete();
      await tester.pumpAndSettle();
      expect(find.byType(CorporateReviewPage), findsNothing);
      expect(find.text(l.corpProgressSuccess), findsOneWidget);
      expect(find.text(l.corpProgressMailHint), findsOneWidget);
      expect(repo.detailReads, 1);
      final open = find.text(l.corpProgressOpen);
      await tester.scrollUntilVisible(
        open,
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(open);
      await tester.pumpAndSettle();
      expect(find.byType(CorporateProgressPage), findsOneWidget);
      expect(
        tester
            .widget<CorporateProgressTimeline>(
              find.byType(CorporateProgressTimeline),
            )
            .progress
            .actionRequired,
        true,
      );
      expect(repo.detailReads, 2);
      await tester.tap(find.text(l.menuItemEditProfile));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.menuItemEditProfile));
      await tester.pumpAndSettle();
      expect(find.text('SUBMITTED'), findsOneWidget);
      expect(repo.writes, 1);
    },
  );
}
