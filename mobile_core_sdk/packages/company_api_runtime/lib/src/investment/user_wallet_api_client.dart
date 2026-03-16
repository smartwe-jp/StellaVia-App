import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'user_wallet_dtos.dart';

typedef UserWalletDioForPath = Dio Function(String path);

class UserWalletApiPaths {
  const UserWalletApiPaths._();

  static const String accountHistory = '/member/wx/account/history';
}

class UserWalletApiClient {
  UserWalletApiClient({
    required UserWalletDioForPath dioForPath,
    LegacyEnvelopeCodec? envelopeCodec,
    this.accountHistoryPath = UserWalletApiPaths.accountHistory,
  }) : _dioForPath = dioForPath,
       _envelopeCodec =
           envelopeCodec ??
           const LegacyEnvelopeCodec(
             profile: LegacyEnvelopeProfile(successCodes: <String>{'0', '200'}),
           );

  final UserWalletDioForPath _dioForPath;
  final LegacyEnvelopeCodec _envelopeCodec;

  final String accountHistoryPath;

  Future<List<UserWalletAccountHistoryItemDto>> fetchAccountHistory({
    int startPage = 1,
    int limit = 20,
  }) async {
    final response = await _dioForPath(accountHistoryPath)
        .post<Map<String, dynamic>>(
          accountHistoryPath,
          data: <String, dynamic>{'startPage': startPage, 'limit': limit},
          options: authRequired(true),
        );

    final payload = _envelopeCodec.toJsonMap(response.data);
    final rows = _extractRows(payload);
    return rows
        .map(
          (Map<String, dynamic> row) =>
              UserWalletAccountHistoryItemDto.fromJson(row),
        )
        .toList(growable: false);
  }

  List<Map<String, dynamic>> _extractRows(Map<String, dynamic> payload) {
    if (payload.isEmpty) {
      return const <Map<String, dynamic>>[];
    }

    if (_envelopeCodec.looksLikeEnvelope(payload)) {
      _envelopeCodec.assertSuccessIfEnvelope(
        payload,
        fallbackMessage: 'Failed to load account history.',
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
    return _envelopeCodec.toJsonMapList(payload);
  }
}
