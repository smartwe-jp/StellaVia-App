import 'package:core_network/core_network.dart';
import '../envelope/legacy_envelope_codec.dart';
import '../statistics/statistics_wire_values.dart';
import 'host_miles_dtos.dart';

/// Source: funding Swagger, checked 2026-10-29; /crowdfunding cluster.
class HostMilesApiPaths {
  const HostMilesApiPaths._();
  static const fetchTier = '/crowdfunding/points/user-tier-info';
  static const fetchAccount = '/crowdfunding/points/user-account-summary';
  static const fetchExpiryAlerts = '/crowdfunding/points/user-expire-alert';
  static const fetchTierRules = '/crowdfunding/offline/listRules';
  static const fetchChart = '/crowdfunding/points/chart';
  static const fetchCumulativeChart = '/crowdfunding/points/cumulative-chart';
  static const fetchTransactions = '/crowdfunding/points/user-transactions';
}

class HostMilesApiClient {
  HostMilesApiClient({
    required Dio Function(String) dioForPath,
    LegacyEnvelopeCodec? envelopeCodec,
  }) : _dioForPath = dioForPath,
       _codec = envelopeCodec ?? const LegacyEnvelopeCodec();
  final Dio Function(String) _dioForPath;
  final LegacyEnvelopeCodec _codec;
  Future<HostMilesTierDto> fetchTier() async {
    const path = HostMilesApiPaths.fetchTier;
    final response = await _dioForPath(path).get<Map<String, dynamic>>(
      path,
      queryParameters: null,
      options: authRequired(true),
    );
    final payload = _codec.toJsonMap(response.data);
    // An absent/invalid envelope must not masquerade as a zero/empty account.
    if (!_codec.looksLikeEnvelope(payload)) {
      throw const FormatException('Missing response envelope.');
    }
    _codec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to fetchTier.',
    );
    final data = payload[_codec.profile.dataKey];
    return readObject(data, HostMilesTierDto.fromJson);
  }

  Future<HostMilesAccountDto> fetchAccount() async {
    const path = HostMilesApiPaths.fetchAccount;
    final response = await _dioForPath(path).get<Map<String, dynamic>>(
      path,
      queryParameters: null,
      options: authRequired(true),
    );
    final payload = _codec.toJsonMap(response.data);
    // An absent/invalid envelope must not masquerade as a zero/empty account.
    if (!_codec.looksLikeEnvelope(payload)) {
      throw const FormatException('Missing response envelope.');
    }
    _codec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to fetchAccount.',
    );
    final data = payload[_codec.profile.dataKey];
    return readObject(data, HostMilesAccountDto.fromJson);
  }

  Future<List<HostMilesExpiryDto>> fetchExpiryAlerts() async {
    const path = HostMilesApiPaths.fetchExpiryAlerts;
    final response = await _dioForPath(path).get<Map<String, dynamic>>(
      path,
      queryParameters: null,
      options: authRequired(true),
    );
    final payload = _codec.toJsonMap(response.data);
    // An absent/invalid envelope must not masquerade as a zero/empty account.
    if (!_codec.looksLikeEnvelope(payload)) {
      throw const FormatException('Missing response envelope.');
    }
    _codec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to fetchExpiryAlerts.',
    );
    final data = payload[_codec.profile.dataKey];
    return readList(
      data,
      (value) => readObject(value, HostMilesExpiryDto.fromJson),
    );
  }

  Future<List<HostMilesTierRuleDto>> fetchTierRules() async {
    const path = HostMilesApiPaths.fetchTierRules;
    final response = await _dioForPath(path).get<Map<String, dynamic>>(
      path,
      queryParameters: null,
      options: authRequired(false),
    );
    final payload = _codec.toJsonMap(response.data);
    // An absent/invalid envelope must not masquerade as a zero/empty account.
    if (!_codec.looksLikeEnvelope(payload)) {
      throw const FormatException('Missing response envelope.');
    }
    _codec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to fetchTierRules.',
    );
    final data = payload[_codec.profile.dataKey];
    return readList(
      data,
      (value) => readObject(value, HostMilesTierRuleDto.fromJson),
    );
  }

  Future<List<HostMilesChartEntryDto>> fetchChart({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final range = apiDateRange(startDate, endDate);
    const path = HostMilesApiPaths.fetchChart;
    final response = await _dioForPath(path).post<Map<String, dynamic>>(
      path,
      data: range,
      options: authRequired(true),
    );
    final payload = _codec.toJsonMap(response.data);
    // An absent/invalid envelope must not masquerade as a zero/empty account.
    if (!_codec.looksLikeEnvelope(payload)) {
      throw const FormatException('Missing response envelope.');
    }
    _codec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to fetchChart.',
    );
    final data = payload[_codec.profile.dataKey];
    return readList(
      data,
      (value) => readObject(value, HostMilesChartEntryDto.fromJson),
    );
  }

  Future<HostMilesCumulativeChartDto> fetchCumulativeChart({
    required DateTime startMonth,
  }) async {
    const path = HostMilesApiPaths.fetchCumulativeChart;
    final response = await _dioForPath(path).get<Map<String, dynamic>>(
      path,
      queryParameters: {'startMonth': apiMonth(startMonth)},
      options: authRequired(true),
    );
    final payload = _codec.toJsonMap(response.data);
    // An absent/invalid envelope must not masquerade as a zero/empty account.
    if (!_codec.looksLikeEnvelope(payload)) {
      throw const FormatException('Missing response envelope.');
    }
    _codec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to fetchCumulativeChart.',
    );
    final data = payload[_codec.profile.dataKey];
    return readObject(data, HostMilesCumulativeChartDto.fromJson);
  }

  Future<HostMilesTransactionPageDto> fetchTransactions({
    String? bizType,
    int startPage = 1,
    int limit = 20,
  }) async {
    if (startPage < 1 || limit < 1) {
      throw ArgumentError('Pagination must be positive.');
    }
    const path = HostMilesApiPaths.fetchTransactions;
    final response = await _dioForPath(path).post<Map<String, dynamic>>(
      path,
      data: {
        'startPage': startPage,
        'limit': limit,
        if (bizType != null) 'bizType': bizType,
      },
      options: authRequired(true),
    );
    final payload = _codec.toJsonMap(response.data);
    // An absent/invalid envelope must not masquerade as a zero/empty account.
    if (!_codec.looksLikeEnvelope(payload)) {
      throw const FormatException('Missing response envelope.');
    }
    _codec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to fetchTransactions.',
    );
    final data = payload[_codec.profile.dataKey];
    return readObject(data, HostMilesTransactionPageDto.fromJson);
  }
}
