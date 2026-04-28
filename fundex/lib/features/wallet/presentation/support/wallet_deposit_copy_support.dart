class WalletDepositCopyRow {
  const WalletDepositCopyRow({required this.label, required this.value});

  final String label;
  final String? value;
}

String formatWalletDepositCopyText(List<WalletDepositCopyRow> rows) {
  final lines = <String>[];
  for (final row in rows) {
    final label = row.label.trim();
    final value = row.value?.trim() ?? '';
    if (label.isEmpty || value.isEmpty) {
      continue;
    }
    lines.add('$label: $value');
  }
  return lines.join('\n');
}

String resolveWalletDepositBranchCopyValue(String? rawValue) {
  final value = rawValue?.trim() ?? '';
  if (value.isEmpty) {
    return '';
  }

  final matches = RegExp(r'[（(]([^（）()]*)[）)]').allMatches(value).toList();
  if (matches.isEmpty) {
    return value;
  }

  final bracketValue = matches.last.group(1)?.trim() ?? '';
  return bracketValue.isEmpty ? value : bracketValue;
}

String resolveWalletDepositAccountNumberCopyValue(String? rawValue) {
  final value = rawValue?.trim() ?? '';
  if (value.isEmpty) {
    return '';
  }

  final normalizedValue = value.replaceAllMapped(RegExp(r'[０-９]'), (match) {
    final digit = match.group(0)!;
    return String.fromCharCode(digit.codeUnitAt(0) - 0xff10 + 0x30);
  });
  final digits = RegExp(
    r'\d+',
  ).allMatches(normalizedValue).map((match) => match.group(0)!).join();
  return digits.isEmpty ? value : digits;
}
