import 'package:core_network/core_network.dart';
import '../envelope/legacy_envelope_codec.dart';
import '../statistics/statistics_wire_values.dart';
import 'asset_statistics_dtos.dart';

/// Source: funding Swagger, checked 2026-10-29; /crowdfunding cluster.
class AssetStatisticsApiPaths {
  const AssetStatisticsApiPaths._();
  static const fetchInvestments = '/crowdfunding/user/invest/chart';
  static const fetchCumulativeBenefit =
      '/crowdfunding/benefit/chart/cumulative';
  static const fetchForecast = '/crowdfunding/benefit/expect';
  static const fetchYearlyBenefits = '/crowdfunding/benefit/year-statistic';
}

class AssetStatisticsApiClient {
  AssetStatisticsApiClient({
    required Dio Function(String) dioForPath,
    LegacyEnvelopeCodec? envelopeCodec,
  }) : _dioForPath = dioForPath,
       _codec = envelopeCodec ?? const LegacyEnvelopeCodec();
  final Dio Function(String) _dioForPath;
  final LegacyEnvelopeCodec _codec;
  Future<AssetInvestmentChartDto> fetchInvestments() async {
    const path = AssetStatisticsApiPaths.fetchInvestments;
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
      fallbackMessage: 'Failed to fetchInvestments.',
    );
    final data = payload[_codec.profile.dataKey];
    return readObject(data, AssetInvestmentChartDto.fromJson);
  }

  Future<AssetCumulativeBenefitDto> fetchCumulativeBenefit({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final range = apiDateRange(startDate, endDate);
    const path = AssetStatisticsApiPaths.fetchCumulativeBenefit;
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
      fallbackMessage: 'Failed to fetchCumulativeBenefit.',
    );
    final data = payload[_codec.profile.dataKey];
    return readObject(data, AssetCumulativeBenefitDto.fromJson);
  }

  Future<AssetBenefitForecastDto> fetchForecast({
    required DateTime endYearMonth,
  }) async {
    const path = AssetStatisticsApiPaths.fetchForecast;
    final response = await _dioForPath(path).get<Map<String, dynamic>>(
      path,
      queryParameters: {'endYearMonth': apiMonth(endYearMonth)},
      options: authRequired(true),
    );
    final payload = _codec.toJsonMap(response.data);
    // An absent/invalid envelope must not masquerade as a zero/empty account.
    if (!_codec.looksLikeEnvelope(payload)) {
      throw const FormatException('Missing response envelope.');
    }
    _codec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to fetchForecast.',
    );
    final data = payload[_codec.profile.dataKey];
    return readObject(data, AssetBenefitForecastDto.fromJson);
  }

  Future<List<AssetYearlyBenefitDto>> fetchYearlyBenefits({
    required int startYear,
  }) async {
    if (startYear < 1 || startYear > 9999) {
      throw ArgumentError.value(startYear, 'startYear');
    }
    const path = AssetStatisticsApiPaths.fetchYearlyBenefits;
    final response = await _dioForPath(path).get<Map<String, dynamic>>(
      path,
      queryParameters: {'startYear': startYear},
      options: authRequired(true),
    );
    final payload = _codec.toJsonMap(response.data);
    // An absent/invalid envelope must not masquerade as a zero/empty account.
    if (!_codec.looksLikeEnvelope(payload)) {
      throw const FormatException('Missing response envelope.');
    }
    _codec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to fetchYearlyBenefits.',
    );
    final data = payload[_codec.profile.dataKey];
    return readList(
      data,
      (value) => readObject(value, AssetYearlyBenefitDto.fromJson),
    );
  }
}
