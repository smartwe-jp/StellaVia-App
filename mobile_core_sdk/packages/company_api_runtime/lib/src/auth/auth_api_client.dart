import 'package:core_network/core_network.dart';
import 'package:encrypt/encrypt.dart' as crypto;

import '../envelope/legacy_envelope_codec.dart';
import 'auth_dtos.dart';

typedef AuthDioForPath = Dio Function(String path);

class AuthApiDefaults {
  const AuthApiDefaults._();

  static const String defaultIntlCode = '81';
  static const String oauthClientAuthorization = 'Basic d2ViQXBwOndlYkFwcA==';
}

class AuthApiPaths {
  const AuthApiPaths._();

  static const String smsCode = '/mss/smsCode';
  static const String emailLoginCode = '/member/user/emailLoginCode';
  static const String createRegisterMobileCode =
      '/member/user/createRegisterMobileCode';
  static const String createRegisterEmailCode =
      '/member/user/createRegisterEmailCode';
  static const String registerApply = '/member/user/registerApply';
  static const String changePhoneOnlineSend =
      '/member/change/phone/online/send';
  static const String changePhoneOnlineCheck =
      '/member/change/phone/online/check';
  static const String memberLoginIndex = '/member/login/index';
  static const String oauthToken = '/uaa/oauth/token';
  static const String crowdfundingUserIndex = '/crowdfunding/user/index-new';
}

class AuthApiClient {
  AuthApiClient({
    required AuthDioForPath dioForPath,
    LegacyEnvelopeCodec? envelopeCodec,
    this.defaultIntlCode = AuthApiDefaults.defaultIntlCode,
    this.oauthClientAuthorization = AuthApiDefaults.oauthClientAuthorization,
    this.smsCodePath = AuthApiPaths.smsCode,
    this.emailLoginCodePath = AuthApiPaths.emailLoginCode,
    this.createRegisterMobileCodePath = AuthApiPaths.createRegisterMobileCode,
    this.createRegisterEmailCodePath = AuthApiPaths.createRegisterEmailCode,
    this.registerApplyPath = AuthApiPaths.registerApply,
    this.changePhoneOnlineSendPath = AuthApiPaths.changePhoneOnlineSend,
    this.changePhoneOnlineCheckPath = AuthApiPaths.changePhoneOnlineCheck,
    this.memberLoginIndexPath = AuthApiPaths.memberLoginIndex,
    this.oauthTokenPath = AuthApiPaths.oauthToken,
    this.crowdfundingUserIndexPath = AuthApiPaths.crowdfundingUserIndex,
  }) : _dioForPath = dioForPath,
       _envelopeCodec =
           envelopeCodec ??
           const LegacyEnvelopeCodec(
             profile: LegacyEnvelopeProfile(successCodes: <String>{'200'}),
           );

  final AuthDioForPath _dioForPath;
  final LegacyEnvelopeCodec _envelopeCodec;

  final String defaultIntlCode;
  final String oauthClientAuthorization;
  final String smsCodePath;
  final String emailLoginCodePath;
  final String createRegisterMobileCodePath;
  final String createRegisterEmailCodePath;
  final String registerApplyPath;
  final String changePhoneOnlineSendPath;
  final String changePhoneOnlineCheckPath;
  final String memberLoginIndexPath;
  final String oauthTokenPath;
  final String crowdfundingUserIndexPath;

  Future<void> sendLoginCode({
    required String account,
    String? intlCode,
  }) async {
    final normalizedAccount = account.trim();
    if (_isEmailAccount(normalizedAccount)) {
      final response = await _dioForPath(emailLoginCodePath)
          .get<Map<String, dynamic>>(
            emailLoginCodePath,
            queryParameters: <String, dynamic>{'email': normalizedAccount},
            options: authRequired(false),
          );
      _assertLegacyBoolSuccessIfPresent(
        _envelopeCodec.toJsonMap(response.data),
        fallbackMessage: 'Failed to send login code.',
      );
      return;
    }

    final response = await _dioForPath(smsCodePath).get<Map<String, dynamic>>(
      smsCodePath,
      queryParameters: <String, dynamic>{
        'mobile': normalizedAccount,
        'biz': _normalizedIntlCode(intlCode),
        'secret': _buildSmsSecret(normalizedAccount),
      },
      options: authRequired(
        false,
      ).copyWith(contentType: Headers.formUrlEncodedContentType),
    );
    _assertLegacyBoolSuccessIfPresent(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to send login code.',
    );
  }

  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  }) async {
    final normalizedAccount = account.trim();
    final normalizedIntlCode = intlCode.trim().isEmpty
        ? defaultIntlCode
        : intlCode.trim();

    if (_isEmailAccount(normalizedAccount)) {
      final response = await _dioForPath(createRegisterEmailCodePath)
          .get<Map<String, dynamic>>(
            createRegisterEmailCodePath,
            queryParameters: <String, dynamic>{'email': normalizedAccount},
            options: authRequired(false),
          );
      _assertLegacyBoolSuccessIfPresent(
        _envelopeCodec.toJsonMap(response.data),
        fallbackMessage: 'Failed to send registration code.',
      );
      return;
    }

    final response = await _dioForPath(createRegisterMobileCodePath)
        .get<Map<String, dynamic>>(
          createRegisterMobileCodePath,
          queryParameters: <String, dynamic>{
            'mobile': normalizedAccount,
            'biz': normalizedIntlCode,
            'secret': _buildSmsSecret(normalizedAccount),
          },
          options: authRequired(
            false,
          ).copyWith(contentType: Headers.formUrlEncodedContentType),
        );
    _assertLegacyBoolSuccessIfPresent(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to send registration code.',
    );
  }

  Future<void> sendOnlinePhoneChangeCode({
    required String mobile,
    required String bizId,
  }) async {
    final response = await _dioForPath(changePhoneOnlineSendPath)
        .post<Map<String, dynamic>>(
          changePhoneOnlineSendPath,
          queryParameters: <String, dynamic>{
            'bizId': bizId.trim(),
            'mobile': mobile.trim(),
          },
          options: authRequired(true),
        );
    _assertEnvelopeSuccessAllowZero(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to send phone verification code.',
    );
  }

  Future<void> verifyOnlinePhoneChangeCode({
    required String mobile,
    required String bizId,
    required String code,
  }) async {
    final response = await _dioForPath(changePhoneOnlineCheckPath)
        .post<Map<String, dynamic>>(
          changePhoneOnlineCheckPath,
          queryParameters: <String, dynamic>{
            'bizId': bizId.trim(),
            'mobile': mobile.trim(),
            'code': code.trim(),
          },
          options: authRequired(true),
        );
    _assertEnvelopeSuccessAllowZero(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to verify phone code.',
    );
  }

  Future<AuthMemberLoginIndexDto?> fetchMemberLoginIndexStatus({
    required String deviceId,
    required int deviceType,
    required String version,
    String app = 'STELLAVIA',
  }) async {
    final normalizedDeviceId = deviceId.trim();
    final normalizedVersion = version.trim();
    final normalizedApp = app.trim();
    if (normalizedDeviceId.isEmpty ||
        normalizedVersion.isEmpty ||
        normalizedApp.isEmpty) {
      return null;
    }

    final response = await _dioForPath(memberLoginIndexPath)
        .post<Map<String, dynamic>>(
          memberLoginIndexPath,
          data: _buildMemberLoginIndexPayload(
            app: normalizedApp,
            deviceId: normalizedDeviceId,
            deviceType: deviceType,
            version: normalizedVersion,
          ),
          options: authRequired(true),
        );

    final payload = _extractEnvelopeDataPayloadAllowZero(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load member verification status.',
    );
    if (payload.isEmpty) {
      return null;
    }
    return AuthMemberLoginIndexDto.fromJson(payload);
  }

  Future<void> updateLoginDevice({
    required String deviceId,
    required int deviceType,
    required String version,
    String app = 'STELLAVIA',
  }) async {
    final normalizedDeviceId = deviceId.trim();
    final normalizedVersion = version.trim();
    final normalizedApp = app.trim();
    if (normalizedDeviceId.isEmpty ||
        normalizedVersion.isEmpty ||
        normalizedApp.isEmpty) {
      return;
    }

    final response = await _dioForPath(memberLoginIndexPath)
        .post<Map<String, dynamic>>(
          memberLoginIndexPath,
          data: _buildMemberLoginIndexPayload(
            app: normalizedApp,
            deviceId: normalizedDeviceId,
            deviceType: deviceType,
            version: normalizedVersion,
          ),
          options: authRequired(true),
        );

    final payload = _envelopeCodec.toJsonMap(response.data);
    _assertEnvelopeSuccessAllowZero(
      payload,
      fallbackMessage: 'Failed to register push device.',
    );
  }

  Future<AuthLoginResultDto> loginWithCode({
    required String account,
    required String code,
    String? intlCode,
  }) async {
    final normalizedAccount = account.trim();
    final isEmail = _isEmailAccount(normalizedAccount);
    final normalizedIntlCode = _normalizedIntlCode(intlCode);

    final response = await _dioForPath(oauthTokenPath)
        .post<Map<String, dynamic>>(
          oauthTokenPath,
          data: <String, dynamic>{
            'username': normalizedAccount,
            'password': code.trim(),
            'grant_type': 'password',
            'auth_type': isEmail ? 'email' : 'mobile',
            'scope': 'app',
            if (!isEmail) 'code': normalizedIntlCode,
          },
          options: authRequired(false).copyWith(
            headers: <String, dynamic>{
              'Authorization': oauthClientAuthorization,
            },
            contentType: Headers.formUrlEncodedContentType,
          ),
        );

    final payload = _extractTokenPayload(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Login failed.',
    );
    final session = AuthSessionDto.fromJson(payload);
    final user = AuthUserDto.tryFromLoginPayload(payload);
    return AuthLoginResultDto(session: session, user: user);
  }

  Future<AuthUserDto?> fetchCurrentUser() async {
    final normalizedPayload = await fetchCurrentUserPayload();
    if (normalizedPayload.isEmpty) {
      return null;
    }
    return AuthUserDto.tryFromCurrentUserPayload(normalizedPayload);
  }

  Future<Map<String, dynamic>> fetchCurrentUserPayload() async {
    final response = await _dioForPath(crowdfundingUserIndexPath)
        .get<Map<String, dynamic>>(
          crowdfundingUserIndexPath,
          options: authRequired(true),
        );

    final payload = _extractEnvelopeDataPayload(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load current user profile.',
    );
    if (payload.isEmpty) {
      return const <String, dynamic>{};
    }

    final normalizedPayload = _normalizeCurrentUserPayload(payload);
    return normalizedPayload;
  }

  Future<void> registerApply({
    required String account,
    required String code,
    required String intlCode,
    String? contact,
  }) async {
    final normalizedAccount = account.trim();
    final normalizedCode = code.trim();
    final normalizedIntlCode = intlCode.trim().isEmpty
        ? defaultIntlCode
        : intlCode.trim();
    final normalizedContact = contact?.trim();

    final isEmail = _isEmailAccount(normalizedAccount);

    final payload = <String, dynamic>{
      'code': normalizedCode,
      'intlTelCode': normalizedIntlCode,
      'type': isEmail ? 'email' : 'mobile',
      if (isEmail) 'email': normalizedAccount else 'mobile': normalizedAccount,
    };

    if (isEmail) {
      if (normalizedContact == null || normalizedContact.isEmpty) {
        throw StateError('Mobile number is required for email registration.');
      }
      payload['mobile'] = normalizedContact;
    } else if (normalizedContact != null && normalizedContact.contains('@')) {
      payload['email'] = normalizedContact;
    }

    final response = await _dioForPath(registerApplyPath)
        .post<Map<String, dynamic>>(
          registerApplyPath,
          data: payload,
          options: authRequired(
            false,
          ).copyWith(contentType: Headers.jsonContentType),
        );
    _assertLegacyBoolSuccessIfPresent(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Registration failed.',
    );
  }

  Future<AuthSessionDto?> refreshSession({required String refreshToken}) async {
    final normalizedRefreshToken = refreshToken.trim();
    if (normalizedRefreshToken.isEmpty) {
      return null;
    }

    final response = await _dioForPath(oauthTokenPath)
        .post<Map<String, dynamic>>(
          oauthTokenPath,
          data: <String, dynamic>{
            'grant_type': 'refresh_token',
            'refresh_token': normalizedRefreshToken,
          },
          options: authRequired(false).copyWith(
            headers: <String, dynamic>{
              'Authorization': oauthClientAuthorization,
            },
            contentType: Headers.formUrlEncodedContentType,
          ),
        );

    final rawPayload = _envelopeCodec.toJsonMap(response.data);
    if (rawPayload.isEmpty) {
      return null;
    }

    final tokenPayload = _extractTokenPayload(
      rawPayload,
      fallbackMessage: 'Failed to refresh session.',
    );
    if (tokenPayload.isEmpty) {
      return null;
    }

    try {
      return AuthSessionDto.fromJson(tokenPayload);
    } on FormatException {
      return null;
    }
  }

  Future<void> logout({required String accessToken}) async {
    final normalizedAccessToken = accessToken.trim();
    if (normalizedAccessToken.isEmpty) {
      return;
    }

    await _dioForPath(oauthTokenPath).delete<void>(
      oauthTokenPath,
      data: <String, dynamic>{'accessToken': normalizedAccessToken},
      options: authRequired(false).copyWith(
        headers: <String, dynamic>{'Authorization': oauthClientAuthorization},
        contentType: Headers.jsonContentType,
      ),
    );
  }

  bool _isEmailAccount(String account) => account.contains('@');

  Map<String, dynamic> _buildMemberLoginIndexPayload({
    required String app,
    required String deviceId,
    required int deviceType,
    required String version,
  }) {
    return <String, dynamic>{
      'app': app,
      'deviceId': deviceId,
      'deviceType': deviceType,
      'version': version,
    };
  }

  String _normalizedIntlCode(String? intlCode) {
    final value = intlCode?.trim();
    return (value == null || value.isEmpty) ? defaultIntlCode : value;
  }

  String _buildSmsSecret(String mobile) {
    final key = crypto.Key.fromUtf8('ookawasebirukura');
    final iv = crypto.IV.fromUtf8('fkabushikigaisha');
    final aes = crypto.Encrypter(crypto.AES(key, mode: crypto.AESMode.cbc));
    return aes.encrypt(mobile, iv: iv).base64;
  }

  bool _hasOauthTokenFields(Map<String, dynamic> payload) {
    return payload.containsKey('access_token') ||
        payload.containsKey('refresh_token') ||
        payload.containsKey('accessToken') ||
        payload.containsKey('refreshToken');
  }

  void _assertLegacyBoolSuccessIfPresent(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    _envelopeCodec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: fallbackMessage,
      requireTruthyData: true,
    );
  }

  void _assertEnvelopeSuccessAllowZero(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    if (payload.isEmpty || !_envelopeCodec.looksLikeEnvelope(payload)) {
      return;
    }

    final code = payload['code']?.toString().trim() ?? '';
    final isSuccess = code == '0' || code == '200';
    if (isSuccess) {
      return;
    }

    final message = _toNormalizedString(payload['msg']);
    throw StateError(message ?? fallbackMessage);
  }

  Map<String, dynamic> _extractTokenPayload(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    if (payload.isEmpty) {
      return payload;
    }

    if (_hasOauthTokenFields(payload)) {
      return payload;
    }

    if (_envelopeCodec.looksLikeEnvelope(payload)) {
      return _envelopeCodec.extractDataMap(
        payload,
        fallbackMessage: fallbackMessage,
      );
    }

    return payload;
  }

  Map<String, dynamic> _extractEnvelopeDataPayload(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    if (payload.isEmpty) {
      return payload;
    }

    return _envelopeCodec.extractDataMap(
      payload,
      fallbackMessage: fallbackMessage,
    );
  }

  Map<String, dynamic> _extractEnvelopeDataPayloadAllowZero(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    if (payload.isEmpty) {
      return payload;
    }
    if (!_envelopeCodec.looksLikeEnvelope(payload)) {
      return payload;
    }

    final code = payload['code']?.toString().trim() ?? '';
    final isSuccess = code == '0' || code == '200';
    if (!isSuccess) {
      final message = _toNormalizedString(payload['msg']);
      throw StateError(message ?? fallbackMessage);
    }

    return _toJsonMap(payload['data']);
  }

  Map<String, dynamic> _normalizeCurrentUserPayload(
    Map<String, dynamic> payload,
  ) {
    if (payload.isEmpty) {
      return const <String, dynamic>{};
    }

    final baseInfo = _toJsonMap(payload['baseInfo']);
    final identityInfo = _toJsonMap(payload['identityInfo']);
    final suitabilityInfo = _toJsonMap(payload['suitabilityInfo']);

    final normalized = <String, dynamic>{
      ...((baseInfo.isNotEmpty ? baseInfo : payload)),
    };

    if (_toNormalizedString(normalized['frontUrl']) == null) {
      final frontImage = _toNormalizedString(
        identityInfo['documentFrontImage'],
      );
      if (frontImage != null) {
        normalized['frontUrl'] = frontImage;
      }
    }
    if (_toNormalizedString(normalized['backUrl']) == null) {
      final backImage = _toNormalizedString(identityInfo['documentBackImage']);
      if (backImage != null) {
        normalized['backUrl'] = backImage;
      }
    }

    // Keep full sections for future consumers while preserving AuthUserDto compatibility.
    if (identityInfo.isNotEmpty) {
      normalized['identityInfo'] = identityInfo;
    }
    if (suitabilityInfo.isNotEmpty) {
      normalized['suitabilityInfo'] = suitabilityInfo;
    }

    return normalized;
  }

  Map<String, dynamic> _toJsonMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return const <String, dynamic>{};
  }

  String? _toNormalizedString(Object? value) {
    if (value == null) {
      return null;
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
