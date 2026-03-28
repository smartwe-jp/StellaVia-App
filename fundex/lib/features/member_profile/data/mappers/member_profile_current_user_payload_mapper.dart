import '../../../auth/data/models/auth_user_dto.dart';
import '../../domain/entities/member_profile_details.dart';

class MemberProfileCurrentUserPayloadMapper {
  const MemberProfileCurrentUserPayloadMapper._();

  static MemberProfileDetails? toEntity(Map<String, dynamic> payload) {
    if (payload.isEmpty) {
      return null;
    }

    final authUser = AuthUserDto.tryFromCurrentUserPayload(payload);
    final identityInfo = _jsonMap(
      payload['identityInfo'] ?? payload['identityVerification'],
    );
    final suitabilityInfo = _jsonMap(
      payload['suitabilityInfo'] ?? payload['suitabilityRequest'],
    );
    final bank = authUser?.bank ?? _jsonMap(payload['bank']);

    final familyName = _firstNonEmpty(<String>[
      _string(payload['firstName']),
      authUser?.firstName ?? '',
    ]);
    final givenName = _firstNonEmpty(<String>[
      _string(payload['lastName']),
      authUser?.lastName ?? '',
    ]);
    final (String familyNameKana, String givenNameKana) = _splitName(
      _firstNonEmpty(<String>[
        _string(payload['katakana']),
        authUser?.katakana ?? '',
      ]),
    );
    final address = _firstNonEmpty(<String>[
      _string(payload['address']),
      authUser?.address ?? '',
    ]);
    final zipCode = _firstNonEmpty(<String>[
      _string(payload['zipCode']),
      authUser?.zipCode ?? '',
    ]);
    final prefectureCode = _firstNonEmpty(<String>[
      _normalizePrefectureCode(_string(payload['prefectureCode'])),
      _normalizePrefectureCode(_string(payload['prefecture'])),
      _resolvePrefectureFromAddress(address),
    ]);
    final cityAddress = _firstNonEmpty(<String>[
      _string(payload['cityAddress']),
      address,
    ]);
    final sex = _parseSex(payload['sex']) ?? authUser?.sex;
    final taxcountry = _firstNonEmpty(<String>[
      _string(payload['taxcountry']),
      authUser?.taxcountry ?? '',
    ]);

    final profile = MemberProfileDetails(
      familyName: familyName,
      givenName: givenName,
      familyNameKana: familyNameKana,
      givenNameKana: givenNameKana,
      familyNameEn: _firstNonEmpty(<String>[
        _string(payload['firstNameEn']),
        authUser?.firstNameEn ?? '',
      ]),
      givenNameEn: _firstNonEmpty(<String>[
        _string(payload['lastNameEn']),
        authUser?.lastNameEn ?? '',
      ]),
      nameKanji: _joinNonEmpty(<String>[familyName, givenName]),
      katakana: _joinNonEmpty(<String>[familyNameKana, givenNameKana]),
      address: address,
      birthday: _emptyToNull(
        _firstNonEmpty(<String>[
          _string(payload['birthday']),
          authUser?.birthday ?? '',
        ]),
      ),
      sex: sex,
      taxcountry: taxcountry,
      zipCode: zipCode,
      prefectureCode: prefectureCode,
      cityAddress: cityAddress,
      phoneIntlCode: _firstNonEmpty(<String>[
        _string(payload['intlTelCode']),
        authUser?.intlTelCode ?? '',
        '81',
      ]),
      phone: _firstNonEmpty(<String>[
        _string(payload['phone']),
        authUser?.phone ?? '',
        authUser?.mobile ?? '',
      ]),
      email: _firstNonEmpty(<String>[
        _string(payload['email']),
        authUser?.email ?? '',
      ]),
      occupationCode: _mapOccupationFromRemote(
        _string(suitabilityInfo['occupation']),
      ),
      annualIncomeCode: _mapAnnualIncomeFromRemote(
        _string(suitabilityInfo['annualIncome']),
      ),
      financialAssetsCode: _mapFinancialAssetsFromRemote(
        _string(suitabilityInfo['financialAssets']),
      ),
      investmentExperienceCodes: _mapInvestmentExperiencesFromRemote(
        suitabilityInfo['investmentExperiences'],
      ),
      investmentPurposeCode: _mapInvestmentPurposeFromRemote(
        _string(suitabilityInfo['investmentPurpose']),
      ),
      fundSourceCode: _mapNatureOfFundsFromRemote(
        _string(suitabilityInfo['natureOfFunds']),
      ),
      riskToleranceCode: _mapRiskToleranceFromRemote(
        _string(suitabilityInfo['riskTolerance']),
      ),
      ekycDocumentType: _mapDocumentTypeFromRemote(
        _string(identityInfo['documentType']),
      ),
      idDocumentPhotoPath: _emptyToNull(
        _firstNonEmpty(<String>[
          _string(identityInfo['documentFrontImage']),
          authUser?.frontUrl ?? '',
        ]),
      ),
      idDocumentBackPhotoPath: _emptyToNull(
        _firstNonEmpty(<String>[
          _string(identityInfo['documentBackImage']),
          authUser?.backUrl ?? '',
        ]),
      ),
      selfiePhotoPath: _emptyToNull(
        _firstNonEmpty(<String>[
          _string(identityInfo['selfieImage']),
          _string(identityInfo['personImage']),
          _string(identityInfo['realPersonImage']),
        ]),
      ),
      bankName: _string(bank['bankName']),
      branchBankName: _string(bank['branchBankName']),
      branchBankNumber: _string(bank['branchBankNumber']),
      bankNumber: _string(bank['bankNumber']),
      bankAccountType: _mapBankAccountTypeFromRemote(
        _string(bank['bankAccountType']),
      ),
      bankAccountOwnerName: _string(bank['bankAccountOwnerName']),
      lastUpdatedAt: DateTime.now().toUtc(),
    );

    return profile.hasAnyInput ? profile : null;
  }

  static Map<String, dynamic> _jsonMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return const <String, dynamic>{};
  }

  static String _string(Object? value) {
    if (value == null) {
      return '';
    }
    return value.toString().trim();
  }

  static int? _parseSex(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value == 0 || value == 1 ? value : null;
    }
    final normalized = value.toString().trim();
    if (normalized.isEmpty) {
      return null;
    }
    final parsed = int.tryParse(normalized);
    return parsed == 0 || parsed == 1 ? parsed : null;
  }

  static String _firstNonEmpty(List<String> values) {
    for (final value in values) {
      if (value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }

  static String _joinNonEmpty(List<String> values) {
    return values
        .map((String value) => value.trim())
        .where((String value) => value.isNotEmpty)
        .join(' ');
  }

  static (String, String) _splitName(String fullName) {
    final parts = fullName
        .split(RegExp(r'\s+'))
        .where((String part) => part.trim().isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) {
      return ('', '');
    }
    if (parts.length == 1) {
      return (parts.first, '');
    }
    return (parts.first, parts.skip(1).join(' '));
  }

  static String? _emptyToNull(String value) {
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }

  static String _mapOccupationFromRemote(String raw) {
    const mapping = <String, String>{
      'COMPANY_EMPLOYEE': 'employee',
      'SELF_EMPLOYED': 'self_employed',
      'CIVIL_SERVANT': 'public_servant',
      'HOMEMAKER': 'homemaker',
      'STUDENT': 'student',
      'PART_TIME': 'other',
    };
    return _reverseMap(raw, mapping);
  }

  static String _mapAnnualIncomeFromRemote(String raw) {
    const mapping = <String, String>{
      'UNDER_3M': 'lt_3m',
      'FROM_3M_TO_5M': '3_5m',
      'FROM_5M_TO_7M': '5_10m',
      'FROM_7M_TO_10M': '5_10m',
      'OVER_10M': 'gt_10m',
    };
    return _reverseMap(raw, mapping);
  }

  static String _mapFinancialAssetsFromRemote(String raw) {
    const mapping = <String, String>{
      'UNDER_1M': 'lt_1m',
      'FROM_1M_TO_3M': '1_5m',
      'FROM_3M_TO_5M': '1_5m',
      'FROM_5M_TO_10M': '5_10m',
      'FROM_10M_TO_30M': 'gt_10m',
      'OVER_30M': 'gt_10m',
    };
    return _reverseMap(raw, mapping);
  }

  static String _mapInvestmentPurposeFromRemote(String raw) {
    const mapping = <String, String>{
      'ASSET_FORMATION': 'growth',
      'YIELD_FOCUS': 'income',
      'DIVERSIFICATION': 'diversification',
    };
    return _reverseMap(raw, mapping);
  }

  static String _mapNatureOfFundsFromRemote(String raw) {
    const mapping = <String, String>{
      'SURPLUS_FUNDS': 'ok',
      'SAVINGS_FOR_FUTURE': 'warn',
      'BORROWED_MONEY': 'ng',
    };
    return _reverseMap(raw, mapping);
  }

  static String _mapRiskToleranceFromRemote(String raw) {
    const mapping = <String, String>{
      'LOW_RISK_TOLERANCE': 'low_risk',
      'HIGH_RISK_TOLERANCE': 'accept_loss',
    };
    return _reverseMap(raw, mapping);
  }

  static List<String> _mapInvestmentExperiencesFromRemote(Object? value) {
    final rawValues = switch (value) {
      List<dynamic> list => list.map((dynamic item) => _string(item)).toList(),
      String text when text.trim().isNotEmpty =>
        text.split(',').map((String item) => item.trim()).toList(),
      _ => const <String>[],
    };

    const mapping = <String, String>{
      'STOCK_ETF': 'stocks',
      'MUTUAL_FUND': 'mutual_funds',
      'REAL_ESTATE': 'real_estate',
      'REAL_ESTATE_CROWDFUNDING': 'real_estate_crowdfunding',
      'BOND': 'bonds',
      'FX_CRYPTO': 'fx_crypto',
      'NONE': 'none',
    };

    final mapped = rawValues
        .map((String item) => mapping[item.trim().toUpperCase()] ?? '')
        .where((String item) => item.isNotEmpty)
        .toSet()
        .toList(growable: false);
    if (mapped.contains('none') && mapped.length > 1) {
      return mapped.where((String item) => item != 'none').toList();
    }
    return mapped;
  }

  static String _mapDocumentTypeFromRemote(String raw) {
    const mapping = <String, String>{
      '11': 'drivers_license',
      '12': 'my_number',
      '13': 'residence_card',
      '14': 'passport',
      '20': 'other',
      'DRIVERS_LICENSE': 'drivers_license',
      'MY_NUMBER': 'my_number',
      'RESIDENCE_CARD': 'residence_card',
      'PASSPORT': 'passport',
      'OTHER': 'other',
    };
    return _reverseMap(raw, mapping, preserveUnknown: false);
  }

  static String _mapBankAccountTypeFromRemote(String raw) {
    const mapping = <String, String>{
      '1': 'ordinary',
      '2': 'checking',
      'ORDINARY': 'ordinary',
      '普通': 'ordinary',
      '普通預金': 'ordinary',
      'CHECKING': 'checking',
      'CURRENT': 'checking',
      '当座': 'checking',
      '当座預金': 'checking',
    };
    return _reverseMap(raw, mapping, preserveUnknown: false);
  }

  static String _reverseMap(
    String raw,
    Map<String, String> mapping, {
    bool preserveUnknown = true,
  }) {
    final normalized = raw.trim();
    if (normalized.isEmpty) {
      return '';
    }
    final upper = normalized.toUpperCase();
    if (mapping.containsKey(upper)) {
      return mapping[upper]!;
    }
    if (mapping.containsKey(normalized)) {
      return mapping[normalized]!;
    }
    return preserveUnknown ? normalized : '';
  }

  static String _normalizePrefectureCode(String raw) {
    final normalized = raw.trim().toLowerCase();
    if (normalized.isEmpty) {
      return '';
    }
    const mapping = <String, String>{
      'tokyo': 'tokyo',
      '東京都': 'tokyo',
      'osaka': 'osaka',
      '大阪府': 'osaka',
      'kanagawa': 'kanagawa',
      '神奈川県': 'kanagawa',
      'aichi': 'aichi',
      '愛知県': 'aichi',
      'fukuoka': 'fukuoka',
      '福岡県': 'fukuoka',
    };
    return mapping[normalized] ?? '';
  }

  static String _resolvePrefectureFromAddress(String address) {
    if (address.isEmpty) {
      return '';
    }
    if (address.contains('東京都')) {
      return 'tokyo';
    }
    if (address.contains('大阪府')) {
      return 'osaka';
    }
    if (address.contains('神奈川県')) {
      return 'kanagawa';
    }
    if (address.contains('愛知県')) {
      return 'aichi';
    }
    if (address.contains('福岡県')) {
      return 'fukuoka';
    }
    return '';
  }
}
