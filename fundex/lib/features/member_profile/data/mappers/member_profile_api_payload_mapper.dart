import '../../../auth/data/models/auth_user_dto.dart';
import '../../domain/entities/member_profile_details.dart';

class MemberProfileApiPayloadMapper {
  const MemberProfileApiPayloadMapper._();

  static Map<String, dynamic> toSaveMemberInfoRequest({
    required MemberProfileDetails profile,
    String? documentFrontImage,
    String? documentBackImage,
    AuthUserDto? authUser,
  }) {
    final (String fallbackFamilyName, String fallbackGivenName) =
        _splitJapaneseName(profile.nameKanji);
    final familyName = _firstNonEmpty(<String>[
      profile.familyName,
      fallbackFamilyName,
      authUser?.firstName ?? '',
    ]);
    final givenName = _firstNonEmpty(<String>[
      profile.givenName,
      fallbackGivenName,
      authUser?.lastName ?? '',
    ]);
    final familyNameEn = _firstNonEmpty(<String>[
      profile.familyNameEn,
      authUser?.firstNameEn ?? '',
      familyName,
    ]);
    final givenNameEn = _firstNonEmpty(<String>[
      profile.givenNameEn,
      authUser?.lastNameEn ?? '',
      givenName,
    ]);
    final katakana = _firstNonEmpty(<String>[
      _joinNonEmpty(<String?>[profile.familyNameKana, profile.givenNameKana]),
      profile.katakana,
      authUser?.katakana ?? '',
    ]);

    final bank = _buildBankPayload(profile: profile, authUser: authUser);

    final baseInfo = <String, dynamic>{
      'firstName': familyName,
      'lastName': givenName,
      'firstNameEn': familyNameEn,
      'lastNameEn': givenNameEn,
      'katakana': katakana,
      'birthday': _normalizeBirthday(
        _firstNonEmpty(<String>[
          profile.birthday ?? '',
          authUser?.birthday ?? '',
        ]),
      ),
      'zipCode': _firstNonEmpty(<String>[
        profile.zipCode,
        authUser?.zipCode ?? '',
      ]),
      'address': _firstNonEmpty(<String>[
        profile.address,
        _joinNonEmpty(<String?>[profile.prefectureCode, profile.cityAddress]),
        authUser?.address ?? '',
      ]),
      'sex': authUser?.sex ?? 1,
      'liveJp': authUser?.liveJp ?? 1,
      'nationality': _firstNonEmpty(<String>[
        authUser?.nationality ?? '',
        '日本',
      ]),
      'taxcountry': _firstNonEmpty(<String>[authUser?.taxcountry ?? '', '日本']),
    };
    if (bank.isNotEmpty) {
      baseInfo['bank'] = bank;
    }

    final payload = <String, dynamic>{'baseInfo': baseInfo};
    final identityVerification = _buildIdentityVerificationPayload(
      profile: profile,
      documentFrontImage: documentFrontImage,
      documentBackImage: documentBackImage,
    );
    if (identityVerification.isNotEmpty) {
      payload['identityVerification'] = identityVerification;
    }
    final suitabilityRequest = _buildSuitabilityRequest(profile);
    if (suitabilityRequest.isNotEmpty) {
      payload['suitabilityRequest'] = suitabilityRequest;
    }
    return payload;
  }

  static Map<String, dynamic> _buildBankPayload({
    required MemberProfileDetails profile,
    required AuthUserDto? authUser,
  }) {
    final Map<String, dynamic> payload = <String, dynamic>{
      if (authUser?.bank != null) ...Map<String, dynamic>.from(authUser!.bank!),
    };
    final bankName = _firstNonEmpty(<String>[
      profile.bankName,
      _readBankString(authUser?.bank, 'bankName'),
    ]);
    if (bankName.isNotEmpty) {
      payload['bankName'] = bankName;
    }
    final branchBankName = _firstNonEmpty(<String>[
      profile.branchBankName,
      _readBankString(authUser?.bank, 'branchBankName'),
    ]);
    if (branchBankName.isNotEmpty) {
      payload['branchBankName'] = branchBankName;
    }
    final branchBankNumber = _firstNonEmpty(<String>[
      profile.branchBankNumber,
      _readBankString(authUser?.bank, 'branchBankNumber'),
    ]);
    if (branchBankNumber.isNotEmpty) {
      payload['branchBankNumber'] = branchBankNumber;
    }
    final bankNumber = _firstNonEmpty(<String>[
      profile.bankNumber,
      _readBankString(authUser?.bank, 'bankNumber'),
    ]);
    if (bankNumber.isNotEmpty) {
      payload['bankNumber'] = bankNumber;
    }
    final bankAccountOwnerName = _firstNonEmpty(<String>[
      profile.bankAccountOwnerName,
      _readBankString(authUser?.bank, 'bankAccountOwnerName'),
    ]);
    if (bankAccountOwnerName.isNotEmpty) {
      payload['bankAccountOwnerName'] = bankAccountOwnerName;
    }
    final bankType = _readBankInt(authUser?.bank, 'bankType') ?? 0;
    final bankAccountOwnerNationality = _firstNonEmpty(<String>[
      _readBankString(authUser?.bank, 'bankAccountOwnerNationality'),
    ]);
    if (bankAccountOwnerNationality.isNotEmpty) {
      payload['bankAccountOwnerNationality'] = bankAccountOwnerNationality;
    }
    final bankCountry = _firstNonEmpty(<String>[
      _readBankString(authUser?.bank, 'bankCountry'),
      if (bankType == 0) '日本',
    ]);
    if (bankCountry.isNotEmpty) {
      payload['bankCountry'] = bankCountry;
    }
    final bankAccountType = _mapBankAccountTypeOrNull(profile.bankAccountType);
    if (bankAccountType != null) {
      payload['bankAccountType'] = bankAccountType;
    }
    if (bankType != 0 || _readBankInt(authUser?.bank, 'bankType') != null) {
      payload['bankType'] = bankType;
    }
    final liveType = _readBankInt(authUser?.bank, 'liveType');
    if (liveType != null) {
      payload['liveType'] = liveType;
    }
    payload.removeWhere((_, dynamic value) {
      if (value == null) {
        return true;
      }
      if (value is String) {
        return value.trim().isEmpty;
      }
      return false;
    });
    if (payload.isNotEmpty &&
        bankType == 0 &&
        !payload.containsKey('bankAccountOwnerNationality')) {
      payload['bankAccountOwnerNationality'] = '';
    }
    if (payload.isNotEmpty && !payload.containsKey('bankType')) {
      payload['bankType'] = 0;
    }
    return payload;
  }

  static Map<String, dynamic> _buildIdentityVerificationPayload({
    required MemberProfileDetails profile,
    String? documentFrontImage,
    String? documentBackImage,
  }) {
    final normalizedFrontImage = documentFrontImage?.trim() ?? '';
    final normalizedBackImage = documentBackImage?.trim() ?? '';
    if (normalizedFrontImage.isEmpty || normalizedBackImage.isEmpty) {
      return const <String, dynamic>{};
    }
    return <String, dynamic>{
      'documentType': _mapDocumentType(profile.ekycDocumentType),
      'documentFrontImage': normalizedFrontImage,
      'documentBackImage': normalizedBackImage,
    };
  }

  static Map<String, dynamic> _buildSuitabilityRequest(
    MemberProfileDetails profile,
  ) {
    final occupation = _mapOccupationOrNull(profile.occupationCode);
    final annualIncome = _mapAnnualIncomeOrNull(profile.annualIncomeCode);
    final financialAssets = _mapFinancialAssetsOrNull(
      profile.financialAssetsCode,
    );
    final investmentExperiences = _mapInvestmentExperiencesOrNull(
      profile.investmentExperienceCodes,
    );
    final investmentPurpose = _mapInvestmentPurposeOrNull(
      profile.investmentPurposeCode,
    );
    final natureOfFunds = _mapNatureOfFundsOrNull(profile.fundSourceCode);
    final riskTolerance = _mapRiskToleranceOrNull(profile.riskToleranceCode);

    final payload = <String, dynamic>{
      'occupation': occupation,
      'annualIncome': annualIncome,
      'financialAssets': financialAssets,
      'investmentExperiences': investmentExperiences,
      'investmentPurpose': investmentPurpose,
      'natureOfFunds': natureOfFunds,
      'riskTolerance': riskTolerance,
    }..removeWhere((_, dynamic value) => value == null);

    return payload;
  }

  static String _readBankString(Map<String, dynamic>? bank, String key) {
    if (bank == null) {
      return '';
    }
    final value = bank[key];
    if (value == null) {
      return '';
    }
    final text = value.toString().trim();
    return text;
  }

  static int? _readBankInt(Map<String, dynamic>? bank, String key) {
    if (bank == null) {
      return null;
    }
    final value = bank[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value == null) {
      return null;
    }
    return int.tryParse(value.toString());
  }

  static String _normalizeBirthday(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return '';
    }
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(normalized)) {
      return normalized;
    }
    final parsed = DateTime.tryParse(normalized);
    if (parsed == null) {
      return normalized;
    }
    final month = parsed.month.toString().padLeft(2, '0');
    final day = parsed.day.toString().padLeft(2, '0');
    return '${parsed.year}-$month-$day';
  }

  static int _mapDocumentType(String raw) {
    final normalized = raw.trim().toLowerCase();
    if (normalized.isEmpty) {
      return 11;
    }
    final numeric = int.tryParse(normalized);
    if (numeric != null) {
      return numeric;
    }
    const map = <String, int>{
      'drivers_license': 11,
      'my_number': 12,
      'residence_card': 13,
      'passport': 14,
      'other': 20,
    };
    return map[normalized] ?? 11;
  }

  static int _mapBankAccountType(String raw) {
    final normalized = raw.trim().toLowerCase();
    if (normalized.isEmpty) {
      return 1;
    }
    final numeric = int.tryParse(normalized);
    if (numeric != null) {
      return numeric;
    }
    switch (normalized) {
      case 'ordinary':
      case '普通':
      case '普通預金':
        return 1;
      case 'checking':
      case 'current':
      case '当座':
      case '当座預金':
        return 2;
      case 'savings':
      case '貯蓄':
        return 3;
      default:
        return 1;
    }
  }

  static int? _mapBankAccountTypeOrNull(String raw) {
    final normalized = raw.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return _mapBankAccountType(normalized);
  }

  static String _mapOccupation(String raw) {
    const map = <String, String>{
      'employee': 'COMPANY_EMPLOYEE',
      'self_employed': 'SELF_EMPLOYED',
      'public_servant': 'CIVIL_SERVANT',
      'homemaker': 'HOMEMAKER',
      'student': 'STUDENT',
      'pensioner': 'HOMEMAKER',
      'other': 'PART_TIME',
    };
    return _mapEnum(raw, map, fallback: 'COMPANY_EMPLOYEE');
  }

  static String _mapAnnualIncome(String raw) {
    const map = <String, String>{
      'lt_3m': 'UNDER_3M',
      '3_5m': 'FROM_3M_TO_5M',
      '5_10m': 'FROM_5M_TO_7M',
      'gt_10m': 'OVER_10M',
    };
    return _mapEnum(raw, map, fallback: 'UNDER_3M');
  }

  static String _mapFinancialAssets(String raw) {
    const map = <String, String>{
      'lt_1m': 'UNDER_1M',
      '1_5m': 'FROM_1M_TO_3M',
      '5_10m': 'FROM_5M_TO_10M',
      'gt_10m': 'FROM_10M_TO_30M',
    };
    return _mapEnum(raw, map, fallback: 'UNDER_1M');
  }

  static String _mapInvestmentPurpose(String raw) {
    const map = <String, String>{
      'growth': 'ASSET_FORMATION',
      'income': 'YIELD_FOCUS',
      'idle_cash': 'ASSET_FORMATION',
      'diversification': 'DIVERSIFICATION',
    };
    return _mapEnum(raw, map, fallback: 'ASSET_FORMATION');
  }

  static String _mapNatureOfFunds(String raw) {
    const map = <String, String>{
      'ok': 'SURPLUS_FUNDS',
      'warn': 'SAVINGS_FOR_FUTURE',
      'ng': 'BORROWED_MONEY',
    };
    return _mapEnum(raw, map, fallback: 'SURPLUS_FUNDS');
  }

  static String _mapRiskTolerance(String raw) {
    const map = <String, String>{
      'accept_loss': 'HIGH_RISK_TOLERANCE',
      'low_risk': 'LOW_RISK_TOLERANCE',
      'high_risk': 'HIGH_RISK_TOLERANCE',
    };
    return _mapEnum(raw, map, fallback: 'LOW_RISK_TOLERANCE');
  }

  static List<String> _mapInvestmentExperiences(List<String> values) {
    if (values.isEmpty) {
      return const <String>['NONE'];
    }

    const map = <String, String>{
      'stocks': 'STOCK_ETF',
      'mutual_funds': 'MUTUAL_FUND',
      'real_estate': 'REAL_ESTATE',
      'real_estate_crowdfunding': 'REAL_ESTATE_CROWDFUNDING',
      'bonds': 'BOND',
      'fx_crypto': 'FX_CRYPTO',
      'none': 'NONE',
    };

    final mapped = values
        .map((value) => _mapEnum(value, map, fallback: '').trim().toUpperCase())
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList(growable: false);
    if (mapped.isEmpty) {
      return const <String>['NONE'];
    }
    if (mapped.contains('NONE') && mapped.length > 1) {
      return mapped.where((value) => value != 'NONE').toList(growable: false);
    }
    return mapped;
  }

  static String? _mapOccupationOrNull(String raw) {
    final normalized = raw.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return _mapOccupation(normalized);
  }

  static String? _mapAnnualIncomeOrNull(String raw) {
    final normalized = raw.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return _mapAnnualIncome(normalized);
  }

  static String? _mapFinancialAssetsOrNull(String raw) {
    final normalized = raw.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return _mapFinancialAssets(normalized);
  }

  static String? _mapInvestmentPurposeOrNull(String raw) {
    final normalized = raw.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return _mapInvestmentPurpose(normalized);
  }

  static String? _mapNatureOfFundsOrNull(String raw) {
    final normalized = raw.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return _mapNatureOfFunds(normalized);
  }

  static String? _mapRiskToleranceOrNull(String raw) {
    final normalized = raw.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return _mapRiskTolerance(normalized);
  }

  static List<String>? _mapInvestmentExperiencesOrNull(List<String> values) {
    if (values.isEmpty) {
      return null;
    }
    final mapped = _mapInvestmentExperiences(values);
    return mapped.isEmpty ? null : mapped;
  }

  static String _mapEnum(
    String raw,
    Map<String, String> map, {
    required String fallback,
  }) {
    final normalized = raw.trim();
    if (normalized.isEmpty) {
      return fallback;
    }
    final upper = normalized.toUpperCase();
    if (map.containsValue(upper)) {
      return upper;
    }
    return map[normalized] ?? map[normalized.toLowerCase()] ?? fallback;
  }

  static String _firstNonEmpty(List<String> values) {
    for (final value in values) {
      if (value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }

  static String _joinNonEmpty(List<String?> values) {
    return values
        .map((String? value) => value?.trim() ?? '')
        .where((String value) => value.isNotEmpty)
        .join(' ');
  }

  static (String, String) _splitJapaneseName(String fullName) {
    final parts = fullName
        .split(RegExp(r'\s+'))
        .where((part) => part.trim().isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) {
      return ('', '');
    }
    if (parts.length == 1) {
      return (parts.first, '');
    }
    return (parts.first, parts.skip(1).join(' '));
  }
}
