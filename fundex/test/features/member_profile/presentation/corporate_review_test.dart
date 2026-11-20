import 'dart:async';
import 'package:core_storage/core_storage.dart';
import 'package:fundex/features/member_profile/data/datasources/corporate_draft_store.dart';
import 'package:fundex/features/member_profile/presentation/providers/corporate_draft_providers.dart';
import 'package:fundex/features/member_profile/presentation/pages/verification_entry_page.dart';
import 'package:fundex/features/member_profile/presentation/support/corporate_flow_navigation.dart';
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
  _Repository({this.userOps = const {'CUSTOMER_MAILED'}});
  final Set<String> userOps;
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
      userOps: afterSubmission ? userOps : {},
    );
  }
}

Future<void> submitReview(WidgetTester tester, AppLocalizations l) async {
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
}

void main() {
  testWidgets(
    'requires both declarations, submits once and returns to refreshed detail',
    (tester) async {
      final repo = _Repository();
      final store = CorporateDraftStore(InMemoryKeyValueStorage());
      final draft = CorporateFormDraft(localAccountKey: 'member1')
        ..handler = CorporateHandler.delegate;
      await store.save(draft);
      await store.save(
        CorporateFormDraft(localAccountKey: 'member2', companyName: '別法人'),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            corporateDraftStoreProvider.overrideWithValue(store),
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
                          builder: (_) => CorporateReviewPage(draft: draft),
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
      await submitReview(tester, l);
      expect(repo.writes, 1);
      expect(await store.read("member1"), isNotNull);
      repo.response.complete();
      await tester.pumpAndSettle();
      expect(await store.read("member1"), isNull);
      expect(
        (await store.read(
          "member2",
        ))?.value(CorporateSection.company, CorporateField.businessName),
        "別法人",
      );
      expect(find.byType(CorporateReviewPage), findsNothing);
      expect(find.text(l.corpProgressSuccess), findsOneWidget);
      expect(find.text(l.corpMailDelegateOriginals), findsOneWidget);
      expect(find.text(l.corpMailDestination), findsOneWidget);
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
      expect(find.text(l.corpMailDestination), findsOneWidget);
      expect(find.text(l.corpProgressMailHint), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byType(CorporateProgressTimeline),
        250,
        scrollable: find.byType(Scrollable).first,
      );
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
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('SUBMITTED'), findsOneWidget);
      expect(repo.writes, 1);
    },
  );
  for (final (standalone, timeout) in [
    (false, false),
    (true, false),
    (false, true),
  ]) {
    testWidgets(
      'correction returns to refreshed member information (standalone: $standalone, timeout: $timeout)',
      (tester) async {
        final repo = _Repository(
          userOps: standalone ? {} : {'CUSTOMER_MAILED'},
        );
        Widget launch(BuildContext context) => TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              settings: const RouteSettings(
                name: 'corporate-verification/review',
              ),
              builder: (_) => CorporateReviewPage(
                draft: CorporateFormDraft(isCorrection: true),
              ),
            ),
          ),
          child: const Text('edit'),
        );
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
              home: Builder(
                builder: (context) => Scaffold(
                  body: standalone
                      ? TextButton(
                          child: const Text('home'),
                          onPressed: () => Navigator.of(context).push(
                            corporateVerificationModalRoute(
                              (context) => Scaffold(body: launch(context)),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            const Expanded(child: VerificationEntryPage()),
                            launch(context),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        if (standalone) {
          await tester.tap(find.text('home'));
          await tester.pumpAndSettle();
        }
        await tester.tap(find.text('edit'));
        await tester.pumpAndSettle();
        final l = AppLocalizations.of(
          tester.element(find.byType(CorporateReviewPage)),
        );
        await submitReview(tester, l);
        if (timeout) {
          repo.response.completeError(TimeoutException('timeout'));
          await tester.pumpAndSettle();
          for (var attempt = 0; attempt < 2; attempt++) {
            final check = find.widgetWithText(AppButton, l.corpReviewCheck);
            await tester.ensureVisible(check);
            await tester.tap(check);
            await tester.pumpAndSettle();
            expect(find.text(l.corpCorrectionPending), findsOneWidget);
            expect(find.byType(CorporateReviewPage), findsOneWidget);
            expect(find.text(l.corpReviewSubmit), findsNothing);
          }
          expect(repo.writes, 1);
          expect(repo.detailReads, 2);
          return;
        }
        repo.response.complete();
        await tester.pumpAndSettle();
        expect(repo.writes, 1);
        expect(repo.detailReads, 1);
        expect(find.byType(VerificationEntryPage), findsOneWidget);
        expect(find.byType(CorporateProgressPage), findsOneWidget);
        expect(find.text(l.corpProgressSuccess), findsNothing);
        expect(
          find.text(l.corpMailDestination),
          standalone ? findsNothing : findsOneWidget,
        );
        if (standalone) {
          await tester.binding.handlePopRoute();
          await tester.pumpAndSettle();
          expect(find.text('home'), findsOneWidget);
        }
      },
    );
  }
}
