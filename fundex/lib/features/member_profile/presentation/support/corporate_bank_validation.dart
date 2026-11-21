import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:unorm_dart/unorm_dart.dart' as unicode;

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/corporate_form_draft.dart';

String _normalized(String value) =>
    unicode.nfkc(value).replaceAll(RegExp(r'\s+'), '').toUpperCase();

String _holderName(String input) {
  var value = _normalized(input);
  for (final entry in const {
    'カ': 'カブシキガイシャ',
    'ユ': 'ユウゲンガイシャ',
    'ド': 'ゴウドウガイシャ',
  }.entries) {
    value = value
        .replaceFirst(RegExp('^${entry.key}\\)'), entry.value)
        .replaceFirst(RegExp('\\(${entry.key}\$'), entry.value);
  }
  return value;
}

String _bankKey(String value) => _normalized(value)
    .replaceAll('-', 'ー')
    .replaceFirst(RegExp(r'銀行$'), '')
    .replaceFirst(RegExp(r'信用金庫$'), '信金')
    .replaceFirst(RegExp(r'信用組合$'), '信組')
    .replaceFirst(RegExp(r'労働金庫$'), '労金')
    .replaceFirst(RegExp(r'農業協同組合$'), '農協');

class CorporateBankDirectory {
  CorporateBankDirectory._(this._banks);
  final Set<String> _banks;

  static Future<CorporateBankDirectory> load() async {
    final bytes = await rootBundle.load('assets/content/jp_bank_branches.json');
    final json = utf8.decode(Uint8List.sublistView(bytes));
    final data = jsonDecode(json) as Map<String, dynamic>;
    return CorporateBankDirectory._(data.keys.map(_bankKey).toSet());
  }

  String? validate(
    AppLocalizations l,
    CorporateFormDraft draft,
    CorporateField field,
  ) {
    String read(CorporateField f) => draft.value(CorporateSection.bank, f);
    final selected = read(CorporateField.bankName);
    final manual = selected == 'other';
    final nameField = manual
        ? CorporateField.manualBankName
        : CorporateField.bankName;
    if (field == nameField && !_banks.contains(_bankKey(read(nameField)))) {
      return l.corpBankDomesticError;
    }
    if (field == CorporateField.accountHolder &&
        _holderName(read(field)) !=
            _holderName(
              draft.value(
                CorporateSection.company,
                CorporateField.businessKana,
              ),
            )) {
      return l.corpBankHolderMismatch;
    }
    return null;
  }
}
