import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'fund_project_dto.dart';

class FundProjectApiPaths {
  const FundProjectApiPaths._();

  static const String projectList = '/crowdfunding/offline/project/list';
  static const String projectDetail = '/crowdfunding/offline/project/detail';
  static const String projectApplyDetail =
      '/crowdfunding/offline/project/apply-detail-by-projectId';
}

class FundProjectApiClient {
  FundProjectApiClient(
    this._client, {
    LegacyEnvelopeCodec? envelopeCodec,
    this.projectListPath = FundProjectApiPaths.projectList,
    this.projectDetailPath = FundProjectApiPaths.projectDetail,
    this.projectApplyDetailPath = FundProjectApiPaths.projectApplyDetail,
  }) : _envelopeCodec = envelopeCodec ?? const LegacyEnvelopeCodec();

  final CoreHttpClient _client;
  final LegacyEnvelopeCodec _envelopeCodec;
  final String projectListPath;
  final String projectDetailPath;
  final String projectApplyDetailPath;

  Future<List<FundProjectDto>> fetchFundProjectList() async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      projectListPath,
      options: authRequired(true),
    );

    final rows = _envelopeCodec.extractDataList(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load fund project list.',
    );
    return rows
        .map((Map<String, dynamic> row) => FundProjectDto.fromJson(row))
        .toList(growable: false);
  }

  Future<FundProjectDto> fetchFundProjectDetail({required String id}) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      projectDetailPath,
      queryParameters: <String, dynamic>{'id': id},
      options: authRequired(true),
    );

    final row = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load fund project detail.',
    );
    if (row.isEmpty) {
      throw StateError('Failed to load fund project detail.');
    }
    return FundProjectDto.fromJson(row);
  }

  Future<FundProjectApplyDetailDto> fetchProjectApplyDetail({
    required String projectId,
  }) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      projectApplyDetailPath,
      queryParameters: <String, dynamic>{'projectId': projectId},
      options: authRequired(true),
    );

    final row = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load project apply detail.',
    );
    if (row.isEmpty) {
      throw StateError('Failed to load project apply detail.');
    }
    return FundProjectApplyDetailDto.fromJson(row);
  }
}
