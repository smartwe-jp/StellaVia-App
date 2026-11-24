import "package:core_ui_kit/core_ui_kit.dart";
import "package:flutter/material.dart";
import "package:fundex/features/member_profile/domain/entities/corporate_documents.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:fundex/features/member_profile/domain/entities/corporate_form_draft.dart";
import "package:fundex/features/member_profile/domain/entities/beneficial_owner.dart";
import "package:fundex/features/member_profile/presentation/pages/corporate_form_page.dart";
import "package:fundex/features/member_profile/presentation/support/corporate_form_fields.dart";
import "package:fundex/l10n/app_localizations.dart";

import 'package:fundex/features/settings/presentation/providers/settings_two_factor_providers.dart';

void main() {
  test('delegate email is optional and validates a provided address', () {
    final l = lookupAppLocalizations(const Locale('ja'));
    String? validate(String value) => corporateFieldError(
      l,
      CorporateSection.handler,
      CorporateField.email,
      value,
    );
    expect(validate(''), isNull);
    expect(validate('invalid'), l.corpFormInvalidEmail);
    expect(validate('delegate@example.com'), isNull);
  });

  test('corporate birthdays require age 18 from midnight in Japan', () {
    final l = lookupAppLocalizations(const Locale('ja'));
    for (final section in [
      CorporateSection.representative,
      CorporateSection.handler,
      CorporateSection.owners,
    ]) {
      String? check(DateTime instant, String birth) => corporateFieldError(
        l,
        section,
        CorporateField.birth,
        birth,
        now: instant,
      );
      expect(
        check(DateTime.utc(2026, 11, 23, 14, 59), '2008-11-24'),
        l.memberProfileUnderageTitle,
      );
      expect(check(DateTime.utc(2026, 11, 23, 15), '2008-11-24'), isNull);
      expect(
        check(DateTime.utc(2026, 11, 23, 15), '2008-11-25'),
        l.memberProfileUnderageTitle,
      );
      expect(
        check(DateTime.utc(2026, 11, 23, 15), '2008-02-30'),
        l.corpFormInvalidDate,
      );
    }
  });

  testWidgets(
    'correction goes directly from owners to documents without a bank section',
    (tester) async {
      final draft = CorporateFormDraft(isCorrection: true)
        ..ownerPresence = OwnerPresence.no;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppThemeFactory.light(locale: const Locale('ja')),
            locale: const Locale('ja'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: CorporateFormPage(
              draft: draft,
              section: CorporateSection.owners,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l = AppLocalizations.of(
        tester.element(find.byType(CorporateFormPage)),
      );
      final action = find.text(l.corpDocsTitle);
      await tester.ensureVisible(action);
      await tester.tap(action);
      await tester.pumpAndSettle();
      expect(find.text(l.corpDocsCompany), findsOneWidget);
      expect(draft.sections, isNot(contains(CorporateSection.bank)));
    },
  );
  testWidgets(
    "company to representative to delegate or self, retaining previous entries",
    (tester) async {
      final draft = CorporateFormDraft();
      for (final section in [
        CorporateSection.company,
        CorporateSection.representative,
      ]) {
        for (final f in draft.fields(section)) {
          draft.set(section, f, switch (f) {
            CorporateField.businessKana || CorporateField.kana => "テスト",
            CorporateField.number => "1234567890123",
            CorporateField.postal => "123-4567",
            CorporateField.birth || CorporateField.founded => "2001-02-03",
            CorporateField.legalForm => "株式会社",
            CorporateField.purpose => "asset_management",
            CorporateField.email => "",
            _ => "テスト株式会社",
          });
        }
      }
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsVerifiedEmailProvider.overrideWith(
              (_) async => "account@example.com",
            ),
          ],
          child: MaterialApp(
            locale: const Locale("ja"),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: AppThemeFactory.light(locale: const Locale("ja")),
            home: CorporateFormPage(
              draft: draft,
              section: CorporateSection.company,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l = AppLocalizations.of(
        tester.element(find.byType(CorporateFormPage)),
      );
      Future<void> tap(String text) async {
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        if (find.text(text).evaluate().isEmpty) {
          await tester.scrollUntilVisible(
            find.text(text),
            320,
            scrollable: find.byType(Scrollable).first,
          );
        }
        final target = find.text(text).last;
        await tester.ensureVisible(target);
        await tester.pumpAndSettle();
        await tester.tap(target);
        await tester.pumpAndSettle();
      }

      expect(
        corporateFieldError(
          l,
          CorporateSection.company,
          CorporateField.founded,
          "2025-02-30",
        ),
        l.corpFormInvalidDate,
      );
      expect(
        corporateFieldError(
          l,
          CorporateSection.company,
          CorporateField.number,
          "123",
        ),
        l.corpFormInvalidNumber,
      );
      expect(find.text(l.corpLoginEmail), findsOneWidget);
      expect(
        tester.widget<Text>(find.text("account@example.com")).data,
        "account@example.com",
      );
      await tap('2001-02-03');
      final calendar = tester.widget<CalendarDatePicker>(
        find.byType(CalendarDatePicker),
      );
      expect(calendar.initialDate, DateTime(2001, 2, 3));
      final dialogLabels = MaterialLocalizations.of(
        tester.element(find.byType(DatePickerDialog)),
      );
      await tap('4');
      await tap(dialogLabels.cancelButtonLabel);
      expect(
        draft.value(CorporateSection.company, CorporateField.founded),
        '2001-02-03',
      );
      await tap('2001-02-03');
      await tap('4');
      await tap(dialogLabels.okButtonLabel);
      expect(
        draft.value(CorporateSection.company, CorporateField.founded),
        '2001-02-04',
      );
      const description = 'ホテルの運営・管理\n宿泊施設の予約サービス';
      final business = find.byKey(const ValueKey(CorporateField.business)).last;
      await tester.ensureVisible(business);
      await tester.enterText(business, description);
      expect(
        draft.value(CorporateSection.company, CorporateField.business),
        description,
      );
      await tap(l.corpFormRep);
      expect(find.text(l.corpLoginEmail), findsNothing);
      expect(
        draft.value(CorporateSection.representative, CorporateField.email),
        isEmpty,
      );
      await tap(l.profilePrevStep);
      expect(find.text("1234567890123"), findsOneWidget);
      expect(find.text(description), findsOneWidget);
      await tap(l.corpFormRep);
      await tap(l.corpFormHandler);
      await tap(l.corpFormDelegate);
      await tap(l.corpOwnerTitle);
      expect(find.text(l.corpFormMissing), findsWidgets);
      await tap(l.corpFormSelf);
      expect(find.text(l.corpFormDepartment), findsNothing);
      await tap(l.corpOwnerTitle);
      await tap(l.corpOwnerYes);
      await tap(l.corpBankTitle);
      expect(find.text(l.corpOwnerMinimum), findsOneWidget);
      Future<void> addPerson(String name) async {
        await tap(l.corpOwnerAdd);
        final inputs = find.byType(TextFormField);
        for (final (i, value) in [(0, name), (2, "日本"), (3, "東京都")]) {
          await tester.ensureVisible(inputs.at(i));
          await tester.enterText(inputs.at(i), value);
        }
        await tester.ensureVisible(inputs.at(1));
        await tester.tap(inputs.at(1));
        await tester.pumpAndSettle();
        await tap(dialogLabels.okButtonLabel);
        final dropdown = find.byType(DropdownButtonFormField<OwnerControl>);
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text(l.corpOwnerInfluence).last);
        await tester.pumpAndSettle();
        await tap(l.corpOwnerConfirmAdd);
      }

      await addPerson("山田");
      await addPerson("田中");
      await tap(l.commonEditText);
      await tester.enterText(find.byType(TextFormField).first, "佐藤");
      await tap(l.corpOwnerSave);
      expect(draft.declaredOwners.map((p) => p.name), ["山田", "佐藤"]);
      await tap(l.profilePrevStep);
      await tap(l.corpOwnerTitle);
      expect(find.text("佐藤"), findsOneWidget);
      await tap(l.corpOwnerDelete);
      await tap(l.corpOwnerDelete);
      expect(draft.declaredOwners.single.name, "山田");
      await tap(l.corpOwnerNo);
      expect(draft.declaredOwners, isEmpty);
      await tap(l.corpOwnerYes);
      expect(find.text("山田"), findsOneWidget);
      await tap(l.corpBankTitle);
      await tap(l.corpDocsTitle);
      expect(find.text(l.corpFormMissing), findsWidgets);
      Future<void> choose(int index, String label) async {
        final picker = find.byType(DropdownButtonFormField<String>).at(index);
        await tester.ensureVisible(picker);
        await tester.pumpAndSettle();
        await tester.tap(picker);
        await tester.pumpAndSettle();
        await tap(label);
      }

      await choose(0, l.corpFormOther);
      for (final entry in {
        CorporateField.manualBankName: "京都銀行",
        CorporateField.branchName: "大阪営業部",
        CorporateField.branchCode: "511",
        CorporateField.accountNumber: "0012345",
        CorporateField.accountHolder: "カ）ステラ",
      }.entries) {
        final input = find.byKey(ValueKey(entry.key)).last;
        await tester.ensureVisible(input);
        await tester.enterText(input, entry.value);
      }
      await tap(l.profilePrevStep);
      await tap(l.corpBankTitle);
      expect(find.text("京都銀行"), findsOneWidget);
      expect(find.text("0012345"), findsOneWidget);
      await choose(1, l.accountTypeOrdinary);
      await tap(l.corpDocsTitle);
      expect(find.text(l.corpBankHolderMismatch), findsOneWidget);
      Future<void> changeBankField(CorporateField field, String value) async {
        final input = find.byKey(ValueKey(field)).last;
        await tester.ensureVisible(input);
        await tester.enterText(input, value);
      }

      await changeBankField(CorporateField.accountHolder, 'ﾃｽﾄ');
      await changeBankField(CorporateField.manualBankName, '海外テスト銀行');
      await tap(l.corpDocsTitle);
      expect(find.text(l.corpBankDomesticError), findsOneWidget);
      await changeBankField(CorporateField.manualBankName, 'paypay');
      await changeBankField(CorporateField.branchName, '北区408');
      await changeBankField(CorporateField.branchCode, '000');
      draft.documents.selectType(false, CorporateIdType.myNumber);
      draft.documents.uploaded[CorporateDocument.registry] = (
        filename: 'registry.pdf',
        url: '/registry',
        fileId: 'abc',
      );
      draft.documents.uploaded[CorporateDocument.representativeIdFront] = (
        filename: 'front.jpg',
        url: '/front',
        fileId: '12',
      );
      await tap(l.corpDocsTitle);
      expect(find.text(l.corpDocsCompany), findsOneWidget);
      await tap(l.corpDocsIdentity);
      await tap(l.corpFormReview);
      await tester.scrollUntilVisible(
        find.text(l.corpBankTitle),
        350,
        scrollable: find.byType(Scrollable).first,
      );
      await tap(l.corpBankTitle);
      expect(find.text("0012345"), findsOneWidget);
      expect(
        draft.documents.uploaded[CorporateDocument.registry]?.filename,
        'registry.pdf',
      );
      expect(draft.handler, CorporateHandler.representative);
    },
  );
}
