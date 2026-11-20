import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/corporate_form_draft.dart';

String corporateFieldLabel(AppLocalizations l, CorporateField field) =>
    switch (field) {
      CorporateField.businessName => l.corpFormBusinessName,
      CorporateField.businessKana => l.corpFormBusinessKana,
      CorporateField.legalForm => l.corpFormForm,
      CorporateField.number => l.corpFormNumber,
      CorporateField.postal => l.corpFormPostal,
      CorporateField.office => l.corpFormOffice,
      CorporateField.founded => l.corpFormFounded,
      CorporateField.phone => l.corpFormPhone,
      CorporateField.business => l.corpFormBusiness,
      CorporateField.purpose => l.corpFormPurpose,
      CorporateField.otherPurpose => l.corpFormOtherPurpose,
      CorporateField.name => l.corpFormName,
      CorporateField.kana => l.corpFormKana,
      CorporateField.role => l.corpFormRole,
      CorporateField.address => l.corpFormAddress,
      CorporateField.birth => l.corpFormBirth,
      CorporateField.email => l.corpFormEmail,
      CorporateField.bankName => l.walletBankNameLabel,
      CorporateField.manualBankName => l.corpBankManual,
      CorporateField.branchName => l.walletBranchNameLabel,
      CorporateField.branchCode => l.walletBankSettingsBranchNumberLabel,
      CorporateField.accountNumber => l.memberProfileAccountNumberLabel,
      CorporateField.accountType => l.memberProfileAccountTypeLabel,
      CorporateField.accountHolder => l.memberProfileAccountHolderLabel,
      CorporateField.department => l.corpFormDepartment,
    };
String sectionTitle(AppLocalizations l, CorporateSection s) => switch (s) {
  CorporateSection.company => l.corpFormCompany,
  CorporateSection.representative => l.corpFormRep,
  CorporateSection.handler => l.corpFormHandler,
  CorporateSection.bank => l.corpBankTitle,
  CorporateSection.documents => l.corpDocsTitle,
  CorporateSection.owners => l.corpOwnerTitle,
};
Map<String, String> pickerOptions(AppLocalizations l, CorporateField f) =>
    switch (f) {
      CorporateField.bankName => {
        for (final bank in const [
          'みずほ銀行',
          '三菱UFJ銀行',
          '三井住友銀行',
          'りそな銀行',
          'ゆうちょ銀行',
          'PayPay銀行',
        ])
          bank: bank,
        'other': l.corpFormOther,
      },
      CorporateField.accountType => {
        '1': l.accountTypeOrdinary,
        '2': l.accountTypeChecking,
        '3': l.corpBankSavings,
      },
      CorporateField.legalForm => {
        for (final form in const [
          '株式会社',
          '有限会社',
          '合同会社',
          '合名会社',
          '合資会社',
          '一般社団法人',
          '一般財団法人',
        ])
          form: form,
        'その他': l.corpFormOther,
      },
      CorporateField.purpose => {
        'surplus_fund': l.corpFormSurplus,
        'asset_management': l.corpFormAsset,
        'other': l.corpFormOther,
      },
      _ => {},
    };
bool requiredField(CorporateSection s, CorporateField f) =>
    !(s == CorporateSection.representative && f == CorporateField.email);
String? corporateFieldError(
  AppLocalizations l,
  CorporateSection s,
  CorporateField f,
  String raw,
) {
  final v = raw.trim();
  if (v.isEmpty) return requiredField(s, f) ? l.corpFormMissing : null;
  switch (f) {
    case CorporateField.branchCode:
      return RegExp(r'^\d{3}$').hasMatch(v) ? null : l.corpBankBranchError;
    case CorporateField.accountNumber:
      return RegExp(r'^\d{7}$').hasMatch(v) ? null : l.corpBankNumberError;
    case CorporateField.accountHolder:
      return RegExp(r'^[ァ-ヺー・ヽヾｦ-ﾟ（）()　 A-ZＡ-Ｚ0-9０-９.．－-]+$').hasMatch(v)
          ? null
          : l.corpFormInvalidKana;
    case CorporateField.businessKana:
    case CorporateField.kana:
      return RegExp(r'^[ァ-ヺー・ヽヾ　 ]+$').hasMatch(v)
          ? null
          : l.corpFormInvalidKana;
    case CorporateField.postal:
      return RegExp(r'^\d{3}-?\d{4}$').hasMatch(v)
          ? null
          : l.corpFormInvalidPostal;
    case CorporateField.number:
      return RegExp(r'^\d{13}$').hasMatch(v) ? null : l.corpFormInvalidNumber;
    case CorporateField.birth:
    case CorporateField.founded:
      final date = DateTime.tryParse(v);
      return RegExp(r'^\d{4}-\d\d-\d\d$').hasMatch(v) &&
              date != null &&
              date.toIso8601String().startsWith('${v}T')
          ? null
          : l.corpFormInvalidDate;
    case CorporateField.email:
      return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v)
          ? null
          : l.corpFormInvalidEmail;
    default:
      return null;
  }
}

const corporateRoutePrefix = 'corporate-verification/';
String corporateStepRoute(CorporateSection s) =>
    '$corporateRoutePrefix${s.name}';
