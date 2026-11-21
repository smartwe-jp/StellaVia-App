import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:fundex/features/member_profile/domain/entities/member_profile_details.dart';
import 'package:fundex/features/member_profile/domain/repositories/member_profile_repository.dart';
import 'package:fundex/features/member_profile/presentation/pages/edit_flow_steps/member_profile_bank_account_step_page.dart';
import 'package:fundex/features/member_profile/presentation/pages/edit_flow_steps/member_profile_consent_step_page.dart';
import 'package:fundex/features/member_profile/presentation/pages/member_profile_edit_flow_page.dart';
import 'package:fundex/features/member_profile/presentation/providers/member_profile_providers.dart';
import 'package:fundex/features/member_profile/presentation/support/member_profile_edit_step.dart';
import 'package:fundex/features/member_profile/presentation/widgets/member_document_examples.dart';
import 'package:fundex/l10n/app_localizations.dart';

class _Profiles implements MemberProfileRepository {
  MemberProfileDetails? draft;
  @override
  Future<MemberProfileDetails?> readLocalProfile() async =>
      const MemberProfileDetails(
        ekycDocumentType: 'my_number',
        idDocumentPhotoPath: 'https://example.com/front.jpg',
        idDocumentObliquePhotoPath: 'https://example.com/tilt.jpg',
      );
  @override
  Future<MemberProfileDetails?> readOnboardingDraft() async => draft;
  @override
  Future<void> saveOnboardingDraft(MemberProfileDetails value) async =>
      draft = value;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'face cancellation stays on step and successful check leads to optional bank',
    (tester) async {
      final repo = _Profiles();
      var verified = false;
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const MemberProfileEditFlowPage(
              initialStep: MemberProfileEditStep.realPersonAuth,
            ),
          ),
          GoRoute(
            path: '/auth/real-person',
            builder: (context, _) => Scaffold(
              body: TextButton(
                onPressed: () => context.pop(verified),
                child: const Text('result'),
              ),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            memberProfileRepositoryProvider.overrideWithValue(repo),
            currentAuthUserProvider.overrideWith((_) async => null),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            locale: const Locale('ja'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: AppThemeFactory.light(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l = AppLocalizations.of(
        tester.element(find.byType(MemberProfileEditFlowPage)),
      );
      Future<void> tap(String label) async {
        final target = find.text(label);
        await tester.ensureVisible(target);
        await tester.pumpAndSettle();
        await tester.tap(target);
        await tester.pumpAndSettle();
      }

      await tap(l.identityAuthStartAction);
      await tap('result');
      expect(find.text(l.identityAuthStartAction), findsOneWidget);
      verified = true;
      await tap(l.identityAuthStartAction);
      await tap('result');
      expect(find.byType(MemberProfileBankAccountStepPage), findsOneWidget);
      await tap(l.commonSkipChevron);
      expect(find.byType(MemberProfileConsentStepPage), findsOneWidget);
      expect(repo.draft?.skipBankAccount, isTrue);
    },
  );

  testWidgets('examples are bundled and correspond to each document type', (
    tester,
  ) async {
    for (final (type, prefix, sides) in [
      ('drivers_license', 'license', ['front', 'tilt', 'back']),
      ('my_number', 'mynumber', ['front', 'tilt']),
      ('residence_card', 'residence', ['front', 'tilt', 'back']),
      ('passport', 'passport', ['front', 'tilt']),
      ('other', 'other', ['front', 'tilt', 'back']),
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ja'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: AppThemeFactory.light(),
          home: Scaffold(body: MemberDocumentExamples(documentType: type)),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<Image>(find.byType(Image))
            .map((image) => (image.image as AssetImage).assetName),
        [
          for (final side in sides)
            'assets/images/id-examples/$prefix-$side.jpg',
        ],
      );
      expect(tester.takeException(), isNull);
    }
  });
}
