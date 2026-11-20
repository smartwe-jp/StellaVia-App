import 'dart:convert';
import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/data/mappers/corporate_detail_mapper.dart';
import 'package:fundex/features/member_profile/domain/entities/corporate_form_draft.dart';
import 'package:fundex/features/member_profile/domain/entities/corporate_documents.dart';
import 'package:fundex/features/member_profile/domain/repositories/verification_entry_repository.dart';
import 'package:fundex/features/member_profile/presentation/pages/corporate_detail_page.dart';
import 'package:fundex/features/member_profile/presentation/pages/corporate_progress_page.dart';
import 'package:fundex/features/member_profile/presentation/pages/corporate_form_page.dart';
import 'package:fundex/features/member_profile/presentation/providers/verification_entry_provider.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  for (final status in ['APPROVED', 'SUBMITTED']) {
    testWidgets('progress opens submitted application and respects $status', (
      t,
    ) async {
      final draft = corporateDetailForm(
        CorporateDetailDto.fromJson({
          'application': {'id': 71, 'companyName': 'テスト法人'},
          'representative': {'name': '山田'},
          'handler': {'handlerType': 'delegate', 'name': '田中'},
          'beneficialOwners': [
            {
              'boStatus': 'YES',
              'name': '鈴木',
              'controlType': 'material_influence',
            },
          ],
          'bank': {'bankNumber': '0123456'},
          'documents': [
            {
              'documentCategory': 'registry',
              'fileName': '登記.pdf',
              'fileUrl': '/files/registry',
            },
          ],
        }),
      );
      await t.pumpWidget(
        ProviderScope(
          overrides: [
            corporateAttachmentProvider.overrideWith((ref, url) async {
              expect(url, '/files/registry');
              return base64Decode(
                'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aCJUAAAAASUVORK5CYII=',
              );
            }),
            verificationEntryProvider.overrideWith(
              (_) async => VerificationEntry(
                VerificationEntryKind.corporate,
                applicationId: 71,
                status: status,
                companyName: 'テスト法人',
                submittedForm: draft,
              ),
            ),
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
      Future<void> tap(String label) async {
        final item = find.text(label);
        if (item.evaluate().isEmpty) {
          await t.scrollUntilVisible(
            item,
            300,
            scrollable: find.byType(Scrollable).first,
          );
        }
        await t.ensureVisible(item);
        await t.pumpAndSettle();
        await t.tap(item);
        await t.pumpAndSettle();
      }

      await tap(l.corpDetailView);
      expect(find.byType(CorporateDetailPage), findsOneWidget);
      expect(find.textContaining('•••3456'), findsOneWidget);
      expect(find.textContaining('0123456'), findsNothing);
      expect(find.textContaining('田中'), findsOneWidget);
      expect(find.textContaining('鈴木'), findsOneWidget);
      expect(find.text(l.corpDetailPreview), findsNothing);
      expect(find.textContaining(l.corpDetailExpand), findsNothing);
      expect(find.text('登記.pdf'), findsOneWidget);
      await tap('登記.pdf');
      expect(find.byType(InteractiveViewer), findsOneWidget);
      await t.tap(find.byType(BackButton));
      await t.pumpAndSettle();
      if (status == 'APPROVED') {
        expect(find.text(l.corpDetailCorrect), findsNothing);
        return;
      }
      await tap(l.corpDetailCorrect);
      await tap(l.corpDetailStart);
      final form = t
          .widget<CorporateFormPage>(find.byType(CorporateFormPage))
          .draft;
      expect(
        form.value(CorporateSection.company, CorporateField.businessName),
        'テスト法人',
      );
      expect(form.handler, CorporateHandler.delegate);
      expect(form.declaredOwners.single.name, '鈴木');
      expect(
        form.documents.uploaded[CorporateDocument.registry]?.url,
        '/files/registry',
      );
      expect(form.sections, isNot(contains(CorporateSection.bank)));
      expect(form.sourceApplicationId, 71);
      form.owners.clear();
      form.documents.uploaded.clear();
      expect(draft.declaredOwners, hasLength(1));
      expect(draft.documents.uploaded, hasLength(1));
    });
  }
}
