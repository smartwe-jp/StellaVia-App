import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'user_investment_dtos.dart';

typedef DioForPath = Dio Function(String path);

class UserInvestmentApiPaths {
  const UserInvestmentApiPaths._();

  static const String accountStatistic = '/member/login/account-statistic';
  static const String apply = '/crowdfunding/user/apply';
  static const String applyList = '/crowdfunding/user/apply/list';
  static const String orderInquiryPage = '/crowdfunding/secondary/market/page';
  static const String myInvestmentList = '/crowdfunding/user/invest/list';
}

class UserInvestmentApiClient {
  UserInvestmentApiClient({
    required DioForPath dioForPath,
    LegacyEnvelopeCodec? envelopeCodec,
    LegacyPageProfile? pageProfile,
    this.accountStatisticPath = UserInvestmentApiPaths.accountStatistic,
    this.applyPath = UserInvestmentApiPaths.apply,
    this.applyListPath = UserInvestmentApiPaths.applyList,
    this.orderInquiryPagePath = UserInvestmentApiPaths.orderInquiryPage,
    this.myInvestmentListPath = UserInvestmentApiPaths.myInvestmentList,
  }) : _dioForPath = dioForPath,
       _envelopeCodec = envelopeCodec ?? const LegacyEnvelopeCodec(),
       _pageProfile = pageProfile ?? const LegacyPageProfile();

  final DioForPath _dioForPath;
  final LegacyEnvelopeCodec _envelopeCodec;
  final LegacyPageProfile _pageProfile;

  final String accountStatisticPath;
  final String applyPath;
  final String applyListPath;
  final String orderInquiryPagePath;
  final String myInvestmentListPath;

  Future<UserInvestmentAccountStatisticDto> fetchAccountStatistic() async {
    final response = await _dioForPath(accountStatisticPath)
        .get<Map<String, dynamic>>(
          accountStatisticPath,
          options: authRequired(true),
        );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load account statistic.',
    );
    return UserInvestmentAccountStatisticDto.fromJson(data);
  }

  Future<void> submitApply({
    required String projectId,
    required int units,
    required int amount,
  }) async {
    final response = await _dioForPath(applyPath).post<Map<String, dynamic>>(
      applyPath,
      data: <String, dynamic>{
        'projectId': int.tryParse(projectId) ?? projectId,
        'num': units,
        'money': amount,
      },
      options: authRequired(true),
    );

    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to submit fund application.',
    );
  }

  Future<List<UserInvestmentApplyRecordDto>> fetchApplyList({
    int startPage = 1,
    int limit = 20,
  }) async {
    final response = await _dioForPath(applyListPath)
        .post<Map<String, dynamic>>(
          applyListPath,
          data: <String, dynamic>{'startPage': startPage, 'limit': limit},
          options: authRequired(true),
        );

    final rows = _envelopeCodec.extractPagedRows(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load member apply list.',
      pageProfile: _pageProfile,
    );
    return rows
        .map(
          (Map<String, dynamic> row) =>
              UserInvestmentApplyRecordDto.fromJson(row),
        )
        .toList(growable: false);
  }

  Future<List<UserInvestmentOrderInquiryRecordDto>> fetchOrderInquiryList({
    required int userId,
    int startPage = 1,
    int limit = 20,
  }) async {
    final response = await _dioForPath(orderInquiryPagePath)
        .post<Map<String, dynamic>>(
          orderInquiryPagePath,
          data: <String, dynamic>{
            'startPage': startPage,
            'limit': limit,
            'userId': userId,
          },
          options: authRequired(true),
        );

    final rows = _envelopeCodec.extractPagedRows(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load order inquiry list.',
      pageProfile: _pageProfile,
    );
    return rows
        .map(
          (Map<String, dynamic> row) =>
              UserInvestmentOrderInquiryRecordDto.fromJson(row),
        )
        .toList(growable: false);
  }

  Future<List<UserInvestmentRecordDto>> fetchInvestmentList({
    int startPage = 1,
    int limit = 20,
  }) async {
    final response = await _dioForPath(myInvestmentListPath)
        .post<Map<String, dynamic>>(
          myInvestmentListPath,
          data: <String, dynamic>{'startPage': startPage, 'limit': limit},
          options: authRequired(true),
        );

    final rows = _envelopeCodec.extractPagedRows(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load my investment list.',
      pageProfile: _pageProfile,
    );
    return rows
        .map(
          (Map<String, dynamic> row) => UserInvestmentRecordDto.fromJson(row),
        )
        .toList(growable: false);
  }
}
