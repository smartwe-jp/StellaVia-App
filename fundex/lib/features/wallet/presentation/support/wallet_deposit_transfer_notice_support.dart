import '../../../auth/domain/entities/auth_user.dart';

String formatWalletDepositTransferNoticeAccountId(AuthUser? user) {
  final accountId = _normalizeTransferNoticePart(user?.accountId);
  if (accountId.isEmpty) {
    return '';
  }

  final katakana = _normalizeTransferNoticePart(user?.katakana);
  if (katakana.isNotEmpty) {
    return '$accountId $katakana';
  }

  final romanName = _joinTransferNoticeParts(<String?>[
    user?.lastNameEn,
    user?.firstNameEn,
  ]);
  if (romanName.isNotEmpty) {
    return '$accountId $romanName';
  }

  return accountId;
}

String _joinTransferNoticeParts(Iterable<String?> values) {
  return values
      .map(_normalizeTransferNoticePart)
      .where((String value) => value.isNotEmpty)
      .join(' ');
}

String _normalizeTransferNoticePart(String? value) {
  return value?.trim().replaceAll(RegExp(r'\s+'), ' ') ?? '';
}
