import '../../../auth/data/models/auth_user_dto.dart';
import '../../domain/entities/member_profile_details.dart';

class MemberProfileApiPayloadMapper {
  const MemberProfileApiPayloadMapper._();

  static Map<String, dynamic> toSaveMemberInfoRequest({
    required MemberProfileDetails profile,
    required String documentFrontImage,
    String? documentBackImage,
    AuthUserDto? authUser,
  }) {
    final (String fallbackFamilyName, String fallbackGivenName) =
        _splitJapaneseName(profile.nameKanji);
    final familyName = _firstNonEmpty(<String>[
      profile.familyName,
      fallbackFamilyName,
      authUser?.lastName ?? '',
    ]);
    final givenName = _firstNonEmpty(<String>[
      profile.givenName,
      fallbackGivenName,
      authUser?.firstName ?? '',
    ]);
    final familyNameEn = _firstNonEmpty(<String>[
      profile.familyNameEn,
      authUser?.lastNameEn ?? '',
      familyName,
    ]);
    final givenNameEn = _firstNonEmpty(<String>[
      profile.givenNameEn,
      authUser?.firstNameEn ?? '',
      givenName,
    ]);
    final katakana = _firstNonEmpty(<String>[
      _joinNonEmpty(<String?>[profile.familyNameKana, profile.givenNameKana]),
      profile.katakana,
      authUser?.katakana ?? '',
    ]);

    final bank = _buildBankPayload(profile: profile, authUser: authUser);

    return <String, dynamic>{
      'baseInfo': <String, dynamic>{
        'firstName': givenName,
        'lastName': familyName,
        'firstNameEn': givenNameEn,
        'lastNameEn': familyNameEn,
        'katakana': katakana,
        'birthday': _normalizeBirthday(
          _firstNonEmpty(<String>[
            profile.birthday ?? '',
            authUser?.birthday ?? '',
          ]),
        ),
        'intlTelCode': _parseIntlCode(
          _firstNonEmpty(<String>[
            profile.phoneIntlCode,
            authUser?.intlTelCode ?? '',
          ]),
        ),
        'phone': _firstNonEmpty(<String>[
          profile.phone,
          authUser?.phone ?? '',
          authUser?.mobile ?? '',
        ]),
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
        'taxcountry': _firstNonEmpty(<String>[
          authUser?.taxcountry ?? '',
          '日本',
        ]),
        'bank': bank,
      },
      'identityVerification': <String, dynamic>{
        'documentType': _mapDocumentType(profile.ekycDocumentType),
        'documentFrontImage': documentFrontImage,
        'documentBackImage': (documentBackImage?.trim().isNotEmpty ?? false)
            ? documentBackImage!.trim()
            : documentFrontImage,
      },
      'suitabilityRequest': <String, dynamic>{
        'occupation': _mapOccupation(profile.occupationCode),
        'annualIncome': _mapAnnualIncome(profile.annualIncomeCode),
        'financialAssets': _mapFinancialAssets(profile.financialAssetsCode),
        'investmentExperiences': _mapInvestmentExperiences(
          profile.investmentExperienceCodes,
        ),
        'investmentPurpose': _mapInvestmentPurpose(
          profile.investmentPurposeCode,
        ),
        'natureOfFunds': _mapNatureOfFunds(profile.fundSourceCode),
        'riskTolerance': _mapRiskTolerance(profile.riskToleranceCode),
      },
    };
  }

  static Map<String, dynamic> _buildBankPayload({
    required MemberProfileDetails profile,
    required AuthUserDto? authUser,
  }) {
    final Map<String, dynamic> payload = <String, dynamic>{
      if (authUser?.bank != null) ...Map<String, dynamic>.from(authUser!.bank!),
    };
    payload['bankName'] = _firstNonEmpty(<String>[
      profile.bankName,
      _readBankString(authUser?.bank, 'bankName'),
    ]);
    payload['branchBankName'] = _firstNonEmpty(<String>[
      profile.branchBankName,
      _readBankString(authUser?.bank, 'branchBankName'),
    ]);
    payload['bankNumber'] = _firstNonEmpty(<String>[
      profile.bankNumber,
      _readBankString(authUser?.bank, 'bankNumber'),
    ]);
    payload['bankAccountOwnerName'] = _firstNonEmpty(<String>[
      profile.bankAccountOwnerName,
      _readBankString(authUser?.bank, 'bankAccountOwnerName'),
    ]);
    payload['bankAccountType'] = _mapBankAccountType(profile.bankAccountType);
    payload['bankType'] = _readBankInt(authUser?.bank, 'bankType') ?? 0;
    payload['liveType'] = _readBankInt(authUser?.bank, 'liveType') ?? 0;
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

  static int _parseIntlCode(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 81;
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
