import 'dart:async';

import 'package:core_identity_auth/core_identity_auth.dart';
import 'package:fundex/features/auth/presentation/providers/identity_auth_sdk_providers.dart';
import 'package:fundex/features/settings/presentation/pages/settings_face_verification_page.dart';
import 'package:fundex/features/settings/presentation/providers/settings_two_factor_providers.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/app/config/app_environment.dart';
import 'package:fundex/app/config/app_flavor.dart';
import 'package:fundex/app/config/environment_provider.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:fundex/features/member_profile/domain/entities/member_profile_details.dart';
import 'package:fundex/features/member_profile/domain/constants/member_profile_upload_markers.dart';
import 'package:fundex/features/member_profile/presentation/support/profile_document_image_picker.dart';
import 'package:fundex/features/member_profile/domain/entities/member_profile_region.dart';
import 'package:fundex/features/member_profile/domain/repositories/member_profile_repository.dart';
import 'package:fundex/features/member_profile/presentation/pages/edit_flow_steps/member_profile_basic_info_step_page.dart';
import 'package:fundex/features/member_profile/presentation/pages/edit_flow_steps/member_profile_bank_account_step_page.dart';
import 'package:fundex/features/member_profile/presentation/pages/edit_flow_steps/member_profile_consent_step_page.dart';
import 'package:fundex/features/member_profile/presentation/pages/member_profile_edit_flow_page.dart';
import 'package:fundex/features/member_profile/presentation/providers/member_profile_providers.dart';
import 'package:fundex/features/member_profile/presentation/support/member_profile_edit_step.dart';
import 'package:fundex/features/member_profile/presentation/widgets/member_document_examples.dart';
import 'package:fundex/l10n/app_localizations.dart';

class _Collector implements LivenessCollector {
  int calls = 0;
  @override
  Future<LivenessCollectResult> collect() async {
    calls++;
    return const LivenessCollectResult(photoBase64: '');
  }
}

class _Coordinator implements IdentityAuthCoordinator {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SelfiePicker implements ProfileDocumentImagePicker {
  final sources = <ProfileDocumentImageSource>[];
  @override
  Future<ProfileDocumentImagePickResult> pick(
    ProfileDocumentImageSource source, {
    bool frontCamera = false,
  }) async {
    sources.add(source);
    expect(frontCamera, isTrue);
    return source == ProfileDocumentImageSource.camera
        ? const ProfileDocumentImagePickResult.canceled()
        : const ProfileDocumentImagePickResult.success('/test/selfie.jpg');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Profiles implements MemberProfileRepository {
  _Profiles({
    this.nationality = '',
    this.taxcountry = '',
    this.failUpload = false,
  });
  final bool failUpload;
  final String nationality, taxcountry;
  MemberProfileDetails? draft;
  @override
  Future<String> uploadProfilePhoto({
    required String filePath,
    required bool isSelfie,
  }) async {
    expect(isSelfie, isTrue);
    expect(filePath, '/test/selfie.jpg');
    if (failUpload) throw StateError('Upload failed');
    return selfieUploadCompletedMarker;
  }

  final postalResult = Completer<List<MemberProfileRegion>>();
  final postalRequests = <String>[];
  @override
  Future<List<MemberProfileRegion>> fetchRegionsByZip({required String zip}) {
    postalRequests.add(zip);
    return postalResult.future;
  }

  @override
  Future<MemberProfileDetails?> readLocalProfile() async =>
      MemberProfileDetails(
        nationality: nationality,
        taxcountry: taxcountry,
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
  for (final (flavor, fails, expectedCalls) in [
    (AppFlavor.staging, true, 1),
    (AppFlavor.prod, true, 0),
    (AppFlavor.prod, false, 1),
  ]) {
    testWidgets('settings selfie on $flavor with upload failure=$fails', (
      tester,
    ) async {
      final collector = _Collector();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appEnvironmentProvider.overrideWithValue(
              EnvironmentFactory.fromFlavor(flavor),
            ),
            memberProfileRepositoryProvider.overrideWithValue(
              _Profiles(failUpload: fails),
            ),
            profileDocumentImagePickerProvider.overrideWithValue(
              _SelfiePicker(),
            ),
            settingsRealPersonVerifiedProvider.overrideWith((_) async => false),
            identityAuthCoordinatorProvider.overrideWithValue(_Coordinator()),
            identityAuthLivenessCollectorProvider.overrideWithValue(collector),
          ],
          child: MaterialApp(
            theme: AppThemeFactory.light(),
            locale: const Locale('ja'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const SettingsFaceVerificationPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l = AppLocalizations.of(
        tester.element(find.byType(SettingsFaceVerificationPage)),
      );
      final upload = find.text(l.settingsFaceVerificationSelfieTitle);
      await tester.ensureVisible(upload);
      await tester.tap(upload);
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.profileDocumentPickFromGallery));
      await tester.pumpAndSettle();
      expect(collector.calls, expectedCalls);
      expect(
        tester
                .widget<PrimaryCtaButton>(find.byType(PrimaryCtaButton))
                .onPressed !=
            null,
        expectedCalls == 1,
      );
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });
  }

  testWidgets(
    'personal postal search shows progress and refocuses after an empty result',
    (tester) async {
      final repo = _Profiles();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            memberProfileRepositoryProvider.overrideWithValue(repo),
            currentAuthUserProvider.overrideWith((_) async => null),
          ],
          child: MaterialApp(
            locale: const Locale('ja'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: AppThemeFactory.light(),
            home: const MemberProfileEditFlowPage(
              initialStep: MemberProfileEditStep.addressInfo,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final postal = find.byType(TextField).first;
      await tester.enterText(postal, '0000000');
      expect(repo.postalRequests, isEmpty);
      await tester.tap(find.text('住所検索'));
      await tester.pump();
      final busy = find.ancestor(
        of: find.byType(CircularProgressIndicator),
        matching: find.byType(FilledButton),
      );
      expect(tester.widget<FilledButton>(busy).onPressed, isNull);
      expect(repo.postalRequests, ['0000000']);
      repo.postalResult.complete([]);
      await tester.pumpAndSettle();
      expect(find.text('該当する住所が見つかりませんでした。'), findsOneWidget);
      await tester.tap(find.text('再入力'));
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(postal).focusNode!.hasFocus, isTrue);
    },
  );

  for (final (nationality, taxcountry) in [('', ''), ('中国', ''), ('', '米国')]) {
    testWidgets(
      'prefill blank countries independently [$nationality, $taxcountry]',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              memberProfileRepositoryProvider.overrideWithValue(
                _Profiles(nationality: nationality, taxcountry: taxcountry),
              ),
              currentAuthUserProvider.overrideWith((_) async => null),
            ],
            child: MaterialApp(
              locale: const Locale('ja'),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              theme: AppThemeFactory.light(),
              home: const MemberProfileEditFlowPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final form = tester.widget<MemberProfileBasicInfoStepPage>(
          find.byType(MemberProfileBasicInfoStepPage),
        );
        expect(
          form.nationalityController.text,
          nationality.isEmpty ? '日本' : nationality,
        );
        expect(
          form.taxCountryController.text,
          taxcountry.isEmpty ? '日本' : taxcountry,
        );
      },
    );
  }

  for (final scenario in [
    (AppFlavor.prod, false),
    (AppFlavor.dev, true),
    (AppFlavor.prod, true),
  ]) {
    testWidgets(
      'selfie upload and face verification in ${scenario.$1}, failure=${scenario.$2}',
      (tester) async {
        final repo = _Profiles(failUpload: scenario.$2);
        final picker = _SelfiePicker();
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
              path: '/home',
              builder: (_, _) => const Scaffold(body: Text('home')),
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
              profileDocumentImagePickerProvider.overrideWithValue(picker),
              appEnvironmentProvider.overrideWithValue(
                EnvironmentFactory.fromFlavor(scenario.$1),
              ),
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
        expect(find.text('result'), findsNothing);
        await tap(l.memberProfileSelfieTitle);
        await tap(l.profileDocumentTakePhoto);
        await tap(l.identityAuthStartAction);
        expect(find.text('result'), findsNothing);
        await tap(l.memberProfileSelfieTitle);
        await tap(l.profileDocumentPickFromGallery);
        expect(picker.sources, [
          ProfileDocumentImageSource.camera,
          ProfileDocumentImageSource.gallery,
        ]);
        if (scenario.$2 && scenario.$1 == AppFlavor.prod) {
          expect(repo.draft?.selfiePhotoPath, isNull);
          await tap(l.identityAuthStartAction);
          expect(find.text('result'), findsNothing);
          await tester.pump(const Duration(seconds: 3));
          await tester.pumpAndSettle();
          return;
        }
        expect(
          repo.draft?.selfiePhotoPath,
          scenario.$2
              ? testSelfieUploadFallbackMarker
              : selfieUploadCompletedMarker,
        );
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
        await tester.tap(find.byTooltip(l.commonClose));
        await tester.pumpAndSettle();
        await tap(l.corpExitStay);
        expect(find.byType(MemberProfileConsentStepPage), findsOneWidget);
        await tester.tap(find.byTooltip(l.commonClose));
        await tester.pumpAndSettle();
        await tap(l.commonClose);
        expect(find.text('home'), findsOneWidget);
        expect(
          repo.draft?.lastEditingStep,
          MemberProfileEditStep.consent.index,
        );
      },
    );
  }

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
