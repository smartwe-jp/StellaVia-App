import 'dart:typed_data';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/domain/entities/corporate_documents.dart';
import 'package:fundex/features/member_profile/domain/entities/corporate_form_draft.dart';
import 'package:fundex/features/member_profile/presentation/pages/corporate_documents_page.dart';
import 'package:fundex/features/member_profile/presentation/providers/corporate_document_upload_provider.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  test('size, extension, signature and role-dependent requirements', () {
    const slot = CorporateDocument.registry;
    final pdf = Uint8List.fromList('%PDF-'.codeUnits);
    expect(slot.mimeType('one.PDF', pdf), 'application/pdf');
    expect(slot.mimeType('one.png', pdf), isNull);
    expect(slot.mimeType('one.pdf', Uint8List(0)), isNull);
    expect(
      slot.mimeType(
        'one.pdf',
        Uint8List(CorporateDocument.maxBytes)..setAll(0, pdf),
      ),
      'application/pdf',
    );
    expect(
      slot.mimeType(
        'one.pdf',
        Uint8List(CorporateDocument.maxBytes + 1)..setAll(0, pdf),
      ),
      isNull,
    );
    expect(
      CorporateDocument.representativeIdFront.mimeType('id.jpg', pdf),
      isNull,
    );
    final d = CorporateDocuments();
    const file = (filename: 'test', fileId: '1', url: '/test');
    d.uploaded[slot] = file;
    expect(d.complete(false, false), isTrue);
    expect(d.complete(false, true), isFalse);
    d.uploaded[CorporateDocument.delegation] = file;
    expect(d.complete(false, true), isTrue);
    for (final type in CorporateIdType.values) {
      d.selectType(false, type);
      expect(d.complete(true, false), isFalse);
      d.uploaded[CorporateDocument.representativeIdFront] = file;
      expect(d.complete(true, false), type == CorporateIdType.myNumber);
      for (final s in d.idSlots(false)) {
        d.uploaded[s] = file;
      }
      expect(d.complete(true, false), isTrue);
      expect(d.complete(true, true), isFalse);
    }
    d.selectType(true, CorporateIdType.myNumber);
    d.uploaded[CorporateDocument.handlerIdFront] = file;
    expect(d.complete(true, true), isTrue);
  });

  testWidgets(
    'upload retry, identity sides and selected files survive back navigation',
    (tester) async {
      final draft = CorporateFormDraft()
        ..handler = CorporateHandler.representative;
      var attempts = 0, picks = 0;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            corporateDocumentPickerProvider.overrideWithValue((slot) async {
              picks++;
              return XFile.fromData(
                Uint8List.fromList(
                  slot.identity ? [255, 216, 255, 1] : '%PDF-test'.codeUnits,
                ),
                name: slot.identity ? 'front.jpg' : 'registry.pdf',
                path: slot.identity ? 'front.jpg' : 'registry.pdf',
              );
            }),
            corporateUploadProvider.overrideWithValue((file) async {
              if (++attempts == 1) throw StateError('offline');
              return (fileId: 'abc', url: '/uploaded/${file.filename}');
            }),
          ],
          child: MaterialApp(
            locale: const Locale('ja'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: AppThemeFactory.light(),
            home: CorporateDocumentsPage(draft: draft),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l = AppLocalizations.of(
        tester.element(find.byType(CorporateDocumentsPage)),
      );
      Future<void> tap(Finder target) async {
        await tester.ensureVisible(target);
        await tester.pumpAndSettle();
        await tester.tap(target);
        await tester.pumpAndSettle();
      }

      await tap(find.byKey(const ValueKey(CorporateDocument.registry)));
      await tap(find.text(l.commonRetry));
      expect(picks, 1);
      expect(
        draft.documents.uploaded[CorporateDocument.registry]?.fileId,
        'abc',
      );
      await tap(find.text(l.corpDocsIdentity));
      await tap(find.byType(DropdownButtonFormField<CorporateIdType>));
      await tap(find.text(l.documentTypeMyNumber).last);
      expect(
        find.byKey(const ValueKey(CorporateDocument.representativeIdBack)),
        findsNothing,
      );
      await tap(
        find.byKey(const ValueKey(CorporateDocument.representativeIdFront)),
      );
      expect(
        draft
            .documents
            .uploaded[CorporateDocument.representativeIdFront]
            ?.fileId,
        '12',
      );
      await tap(find.text(l.profilePrevStep));
      expect(find.textContaining('registry.pdf'), findsOneWidget);
      await tap(find.text(l.corpDocsIdentity));
      expect(find.textContaining('front.jpg'), findsOneWidget);
      await tap(find.text(l.corpFormReview));
      expect(find.text(l.corpFormReviewTitle), findsOneWidget);
    },
  );
}
