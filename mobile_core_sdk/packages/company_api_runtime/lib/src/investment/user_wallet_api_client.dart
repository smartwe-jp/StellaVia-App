import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'user_wallet_dtos.dart';

typedef UserWalletDioForPath = Dio Function(String path);

class UserWalletApiPaths {
  const UserWalletApiPaths._();

  static const String accountHistory = '/member/wx/account/history';
  static const String bankAccountApply = '/member/bank-account/apply';
  static const String bankAccountInfo = '/member/bank-account/info';
  static const String bankAccountStatus = '/member/bank-account/status';
  static const String bankAccountAdd = '/member/bank-account/add';
}

class UserWalletApiClient {
  UserWalletApiClient({
    required UserWalletDioForPath dioForPath,
    LegacyEnvelopeCodec? envelopeCodec,
    this.accountHistoryPath = UserWalletApiPaths.accountHistory,
    this.bankAccountApplyPath = UserWalletApiPaths.bankAccountApply,
    this.bankAccountInfoPath = UserWalletApiPaths.bankAccountInfo,
    this.bankAccountStatusPath = UserWalletApiPaths.bankAccountStatus,
    this.bankAccountAddPath = UserWalletApiPaths.bankAccountAdd,
  }) : _dioForPath = dioForPath,
       _envelopeCodec =
           envelopeCodec ??
           const LegacyEnvelopeCodec(
             profile: LegacyEnvelopeProfile(successCodes: <String>{'0', '200'}),
           );

  final UserWalletDioForPath _dioForPath;
  final LegacyEnvelopeCodec _envelopeCodec;

  final String accountHistoryPath;
  final String bankAccountApplyPath;
  final String bankAccountInfoPath;
  final String bankAccountStatusPath;
  final String bankAccountAddPath;

  /// 0: all records, 1: CNY, 2: USD
  Future<List<UserWalletAccountHistoryItemDto>> fetchAccountHistory({
    int accountType = 0,
  }) async {
    final response = await _dioForPath(accountHistoryPath)
        .get<Map<String, dynamic>>(
          accountHistoryPath,
          queryParameters: <String, dynamic>{'accountType': accountType},
          options: authRequired(true),
        );

    final payload = _envelopeCodec.toJsonMap(response.data);
    final rows = _extractRows(
      payload,
      fallbackMessage: 'Failed to load account history.',
    );
    return rows
        .map(
          (Map<String, dynamic> row) =>
              UserWalletAccountHistoryItemDto.fromJson(row),
        )
        .toList(growable: false);
  }

  Future<List<UserWalletBankAccountPoolDto>> fetchBankAccountList() async {
    final response = await _dioForPath(bankAccountStatusPath)
        .get<Map<String, dynamic>>(
          bankAccountStatusPath,
          queryParameters: const <String, dynamic>{'status': 1},
          options: authRequired(true),
        );
    return _extractRows(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load bank account list.',
    ).map(UserWalletBankAccountPoolDto.fromJson).toList(growable: false);
  }

  Future<void> applyBankAccount() async {
    final response = await _dioForPath(bankAccountApplyPath)
        .get<Map<String, dynamic>>(
          bankAccountApplyPath,
          options: authRequired(true),
        );
    final payload = _envelopeCodec.toJsonMap(response.data);
    if (payload.isEmpty) {
      return;
    }
    _envelopeCodec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to apply bank account.',
    );
  }

  Future<void> addBankAccount(
    UserWalletBankAccountAddRequestDto request,
  ) async {
    final response = await _dioForPath(bankAccountAddPath)
        .post<Map<String, dynamic>>(
          bankAccountAddPath,
          data: request.toJson(),
          options: authRequired(true),
        );
    final payload = _envelopeCodec.toJsonMap(response.data);
    if (payload.isEmpty) {
      return;
    }
    _envelopeCodec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to add bank account.',
    );
  }

  Future<UserWalletBankAccountInfoDto?> fetchBankAccountInfo() async {
    final response = await _dioForPath(bankAccountInfoPath)
        .get<Map<String, dynamic>>(
          bankAccountInfoPath,
          options: authRequired(true),
        );
    final payload = _envelopeCodec.toJsonMap(response.data);
    if (payload.isEmpty) {
      return null;
    }

    Map<String, dynamic> dataMap;
    if (_envelopeCodec.looksLikeEnvelope(payload)) {
      _envelopeCodec.assertSuccessIfEnvelope(
        payload,
        fallbackMessage: 'Failed to load bank account info.',
      );
      dataMap = _envelopeCodec.toJsonMap(payload['data']);
    } else {
      dataMap = payload;
    }

    if (dataMap.isEmpty) {
      return null;
    }
    return UserWalletBankAccountInfoDto.fromJson(dataMap);
  }

  List<Map<String, dynamic>> _extractRows(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    if (payload.isEmpty) {
      return const <Map<String, dynamic>>[];
    }

    if (_envelopeCodec.looksLikeEnvelope(payload)) {
      _envelopeCodec.assertSuccessIfEnvelope(
        payload,
        fallbackMessage: fallbackMessage,
      );
      final data = payload['data'];
      if (data is List) {
        return _envelopeCodec.toJsonMapList(data);
      }
      final dataMap = _envelopeCodec.toJsonMap(data);
      if (dataMap.isEmpty) {
        return const <Map<String, dynamic>>[];
      }
      if (dataMap['rows'] is List) {
        return _envelopeCodec.toJsonMapList(dataMap['rows']);
      }
      if (dataMap['list'] is List) {
        return _envelopeCodec.toJsonMapList(dataMap['list']);
      }
      return const <Map<String, dynamic>>[];
    }

    if (payload['rows'] is List) {
      return _envelopeCodec.toJsonMapList(payload['rows']);
    }
    if (payload['list'] is List) {
      return _envelopeCodec.toJsonMapList(payload['list']);
    }
    return _envelopeCodec.toJsonMapList(payload);
  }
}
