import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'user_wallet_dtos.dart';

typedef UserWalletDioForPath = Dio Function(String path);

class UserWalletApiPaths {
  const UserWalletApiPaths._();

  static const String accountHistory = '/member/wx/account/history';
  static const String withdrawApply = '/member/wx/account/withdraw/apply-v1';
  static const String withdrawCancel = '/member/wx/account/withdraw/cancel';
  static const String withdrawCost = '/member/wx/account/withdraw/cost';
  static const String paymentConfirmation =
      '/member/wx/account/payment-confirmation';
  static const String withdrawApplySendCode =
      '/member/wx/account/withdraw-apply-send-code';
  static const String withdrawHistory = '/member/wx/account/withdraw-list';
  static const String withdrawingList = '/member/wx/account/withdrawing/list';
  static const String bankAccountApply = '/member/bank-account/apply';
  static const String bankAccountInfo = '/member/bank-account/info';
  static const String bankAccountList = '/member/bank/list';
  static const String bankAccountAdd = '/member/bank/new';
  static const String bankAccountDelete = '/member/bank/delete';
}

class UserWalletApiClient {
  UserWalletApiClient({
    required UserWalletDioForPath dioForPath,
    LegacyEnvelopeCodec? envelopeCodec,
    this.accountHistoryPath = UserWalletApiPaths.accountHistory,
    this.withdrawApplyPath = UserWalletApiPaths.withdrawApply,
    this.withdrawCancelPath = UserWalletApiPaths.withdrawCancel,
    this.withdrawCostPath = UserWalletApiPaths.withdrawCost,
    this.paymentConfirmationPath = UserWalletApiPaths.paymentConfirmation,
    this.withdrawApplySendCodePath = UserWalletApiPaths.withdrawApplySendCode,
    this.withdrawHistoryPath = UserWalletApiPaths.withdrawHistory,
    this.withdrawingListPath = UserWalletApiPaths.withdrawingList,
    this.bankAccountApplyPath = UserWalletApiPaths.bankAccountApply,
    this.bankAccountInfoPath = UserWalletApiPaths.bankAccountInfo,
    this.bankAccountListPath = UserWalletApiPaths.bankAccountList,
    this.bankAccountAddPath = UserWalletApiPaths.bankAccountAdd,
    this.bankAccountDeletePath = UserWalletApiPaths.bankAccountDelete,
  }) : _dioForPath = dioForPath,
       _envelopeCodec =
           envelopeCodec ??
           const LegacyEnvelopeCodec(
             profile: LegacyEnvelopeProfile(successCodes: <String>{'0', '200'}),
           );

  final UserWalletDioForPath _dioForPath;
  final LegacyEnvelopeCodec _envelopeCodec;

  final String accountHistoryPath;
  final String withdrawApplyPath;
  final String withdrawCancelPath;
  final String withdrawCostPath;
  final String paymentConfirmationPath;
  final String withdrawApplySendCodePath;
  final String withdrawHistoryPath;
  final String withdrawingListPath;
  final String bankAccountApplyPath;
  final String bankAccountInfoPath;
  final String bankAccountListPath;
  final String bankAccountAddPath;
  final String bankAccountDeletePath;

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

  Future<void> applyWithdraw(UserWalletWithdrawApplyRequestDto request) async {
    final response = await _dioForPath(withdrawApplyPath)
        .put<Map<String, dynamic>>(
          withdrawApplyPath,
          data: request.toJson(),
          options: authRequired(true),
        );
    final payload = _envelopeCodec.toJsonMap(response.data);
    if (payload.isEmpty) {
      return;
    }
    _envelopeCodec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to submit withdraw request.',
    );
  }

  Future<void> cancelWithdraw(UserWalletWithdrawCancelRequestDto request) async {
    final response = await _dioForPath(withdrawCancelPath)
        .put<Map<String, dynamic>>(
          withdrawCancelPath,
          data: request.toJson(),
          options: authRequired(true),
        );
    final payload = _envelopeCodec.toJsonMap(response.data);
    if (payload.isEmpty) {
      return;
    }
    _envelopeCodec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to cancel withdraw request.',
    );
  }

  Future<num> fetchWithdrawCost({required Object bankId}) async {
    final response = await _dioForPath(withdrawCostPath).get<Map<String, dynamic>>(
      withdrawCostPath,
      queryParameters: <String, dynamic>{'bankId': bankId},
      options: authRequired(true),
    );
    final payload = _envelopeCodec.toJsonMap(response.data);
    if (payload.isEmpty) {
      return 0;
    }
    _envelopeCodec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to load withdraw cost.',
    );
    return _asNumOrZero(payload['data']);
  }

  Future<void> confirmPayment({required Object amount}) async {
    final response = await _dioForPath(paymentConfirmationPath)
        .get<Map<String, dynamic>>(
          paymentConfirmationPath,
          queryParameters: <String, dynamic>{'amount': amount},
          options: authRequired(true),
        );
    final payload = _envelopeCodec.toJsonMap(response.data);
    if (payload.isEmpty) {
      return;
    }
    _envelopeCodec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to confirm payment.',
    );
  }

  Future<void> sendWithdrawApplyCode() async {
    final response = await _dioForPath(withdrawApplySendCodePath)
        .get<Map<String, dynamic>>(
          withdrawApplySendCodePath,
          options: authRequired(true),
        );
    final payload = _envelopeCodec.toJsonMap(response.data);
    if (payload.isEmpty) {
      return;
    }
    _envelopeCodec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to send withdraw verification code.',
      requireTruthyData: true,
    );
  }

  Future<List<UserWalletWithdrawRecordDto>> fetchWithdrawHistory() async {
    final response = await _dioForPath(withdrawHistoryPath)
        .post<Map<String, dynamic>>(
          withdrawHistoryPath,
          data: <String, dynamic>{'startPage': '1', 'limit': '10'},
          options: authRequired(true),
        );
    return _extractRows(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load withdraw history.',
    ).map(UserWalletWithdrawRecordDto.fromJson).toList(growable: false);
  }

  Future<List<UserWalletWithdrawRecordDto>> fetchWithdrawingList() async {
    final response = await _dioForPath(withdrawingListPath)
        .get<Map<String, dynamic>>(
          withdrawingListPath,
          options: authRequired(true),
        );
    return _extractRows(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load withdrawing list.',
    ).map(UserWalletWithdrawRecordDto.fromJson).toList(growable: false);
  }

  Future<List<UserWalletBankAccountPoolDto>> fetchBankAccountList() async {
    final response = await _dioForPath(bankAccountListPath)
        .get<Map<String, dynamic>>(
          bankAccountListPath,
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

  Future<void> deleteBankAccount({required Object id}) async {
    final response = await _dioForPath(bankAccountDeletePath)
        .delete<Map<String, dynamic>>(
          bankAccountDeletePath,
          data: <String, dynamic>{'id': id},
          options: authRequired(true),
        );
    final payload = _envelopeCodec.toJsonMap(response.data);
    if (payload.isEmpty) {
      return;
    }
    _envelopeCodec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to delete bank account.',
      requireTruthyData: true,
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

  num _asNumOrZero(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is num) {
      return value;
    }
    return num.tryParse(value.toString()) ?? 0;
  }
}
