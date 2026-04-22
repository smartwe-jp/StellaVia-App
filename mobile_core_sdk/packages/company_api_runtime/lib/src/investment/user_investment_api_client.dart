import 'dart:convert';
import 'dart:typed_data';

import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'user_investment_dtos.dart';

typedef DioForPath = Dio Function(String path);

class UserInvestmentApiPaths {
  const UserInvestmentApiPaths._();

  static const String accountStatistic = '/member/login/account-statistic';
  static const String assetTrend = '/member/wx/account/stellavia-asset-trend';
  static const String apply = '/crowdfunding/user/apply';
  static const String applyList = '/crowdfunding/user/apply/list';
  static const String userWithdraw = '/crowdfunding/user/withdraw';
  static const String orderInquiryPage = '/crowdfunding/secondary/market/page';
  static const String offlineOrderInquiryPage =
      '/crowdfunding/offline/secondary/market/page';
  static const String myInvestmentList = '/crowdfunding/user/invest/list';
  static const String userInvestPdf = '/crowdfunding/user/invest/pdf';
  static const String benefitProject = '/crowdfunding/benefit/project';
  static const String benefitDownload = '/crowdfunding/benefit/download';
  static const String benefitWithdrawal = '/crowdfunding/benefit/withdrawal';
  static const String secondaryMarketCreate =
      '/crowdfunding/secondary/market/create';
  static const String secondaryMarketModify =
      '/crowdfunding/secondary/market/modify';
  static const String secondaryMarketPurchase =
      '/crowdfunding/user/applySecondartMarket';
}

class UserInvestmentApiClient {
  UserInvestmentApiClient({
    required DioForPath dioForPath,
    LegacyEnvelopeCodec? envelopeCodec,
    LegacyPageProfile? pageProfile,
    this.accountStatisticPath = UserInvestmentApiPaths.accountStatistic,
    this.assetTrendPath = UserInvestmentApiPaths.assetTrend,
    this.applyPath = UserInvestmentApiPaths.apply,
    this.applyListPath = UserInvestmentApiPaths.applyList,
    this.userWithdrawPath = UserInvestmentApiPaths.userWithdraw,
    this.orderInquiryPagePath = UserInvestmentApiPaths.orderInquiryPage,
    this.offlineOrderInquiryPagePath =
        UserInvestmentApiPaths.offlineOrderInquiryPage,
    this.myInvestmentListPath = UserInvestmentApiPaths.myInvestmentList,
    this.userInvestPdfPath = UserInvestmentApiPaths.userInvestPdf,
    this.benefitProjectPath = UserInvestmentApiPaths.benefitProject,
    this.benefitDownloadPath = UserInvestmentApiPaths.benefitDownload,
    this.benefitWithdrawalPath = UserInvestmentApiPaths.benefitWithdrawal,
    this.secondaryMarketCreatePath =
        UserInvestmentApiPaths.secondaryMarketCreate,
    this.secondaryMarketModifyPath =
        UserInvestmentApiPaths.secondaryMarketModify,
    this.secondaryMarketPurchasePath =
        UserInvestmentApiPaths.secondaryMarketPurchase,
  }) : _dioForPath = dioForPath,
       _envelopeCodec = envelopeCodec ?? const LegacyEnvelopeCodec(),
       _pageProfile = pageProfile ?? const LegacyPageProfile();

  final DioForPath _dioForPath;
  final LegacyEnvelopeCodec _envelopeCodec;
  final LegacyPageProfile _pageProfile;

  final String accountStatisticPath;
  final String assetTrendPath;
  final String applyPath;
  final String applyListPath;
  final String userWithdrawPath;
  final String orderInquiryPagePath;
  final String offlineOrderInquiryPagePath;
  final String myInvestmentListPath;
  final String userInvestPdfPath;
  final String benefitProjectPath;
  final String benefitDownloadPath;
  final String benefitWithdrawalPath;
  final String secondaryMarketCreatePath;
  final String secondaryMarketModifyPath;
  final String secondaryMarketPurchasePath;

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

  Future<List<UserInvestmentAssetTrendDto>> fetchAssetTrend({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _dioForPath(assetTrendPath)
        .get<Map<String, dynamic>>(
          assetTrendPath,
          queryParameters: <String, dynamic>{
            'startDate': _formatApiDate(startDate),
            'endDate': _formatApiDate(endDate),
          },
          options: authRequired(true),
        );

    final rows = _envelopeCodec.extractDataList(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load asset trend.',
    );
    return rows
        .map(
          (Map<String, dynamic> row) =>
              UserInvestmentAssetTrendDto.fromJson(row),
        )
        .toList(growable: false);
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
    int? startPage,
    int? limit,
    List<int>? statuses,
  }) async {
    final body = <String, dynamic>{
      if (startPage != null) 'startPage': startPage,
      if (limit != null) 'limit': limit,
      if (statuses != null && statuses.isNotEmpty) 'status': statuses,
    };
    final response = await _dioForPath(applyListPath)
        .post<Map<String, dynamic>>(
          applyListPath,
          data: body.isEmpty ? null : body,
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

  Future<void> submitUserWithdraw({
    required String processId,
    String? remark,
  }) async {
    final response = await _dioForPath(userWithdrawPath)
        .post<Map<String, dynamic>>(
          userWithdrawPath,
          data: <String, dynamic>{
            'processId': processId,
            if (remark != null && remark.trim().isNotEmpty)
              'remark': remark.trim(),
          },
          options: authRequired(true),
        );

    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to submit user withdraw request.',
      requireTruthyData: false,
    );
  }

  Future<List<UserInvestmentOrderInquiryRecordDto>> fetchOrderInquiryList({
    int? userId,
    String? status,
    int startPage = 1,
    int limit = 20,
    bool publicAccess = false,
  }) async {
    final path = publicAccess
        ? offlineOrderInquiryPagePath
        : orderInquiryPagePath;
    final response = await _dioForPath(path).post<Map<String, dynamic>>(
      path,
      data: <String, dynamic>{
        'startPage': startPage,
        'limit': limit,
        if (userId != null) 'userId': userId,
        if (status != null && status.trim().isNotEmpty) 'status': status.trim(),
      },
      options: authRequired(!publicAccess),
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

  Future<List<UserInvestmentContractProjectPdfDto>> fetchInvestPdfList({
    int startPage = 1,
    int limit = 300,
  }) async {
    final response = await _dioForPath(userInvestPdfPath)
        .post<Map<String, dynamic>>(
          userInvestPdfPath,
          data: <String, dynamic>{'startPage': startPage, 'limit': limit},
          options: authRequired(true),
        );

    final rows = _envelopeCodec.extractPagedRows(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load contract document list.',
      pageProfile: _pageProfile,
    );
    return rows
        .map(
          (Map<String, dynamic> row) =>
              UserInvestmentContractProjectPdfDto.fromJson(row),
        )
        .toList(growable: false);
  }

  Future<UserInvestmentProjectBenefitDto> fetchProjectBenefit({
    required String projectId,
  }) async {
    final response = await _dioForPath(benefitProjectPath)
        .get<Map<String, dynamic>>(
          benefitProjectPath,
          queryParameters: <String, dynamic>{
            'projectId': int.tryParse(projectId) ?? projectId,
          },
          options: authRequired(true),
        );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load project benefit details.',
    );
    return UserInvestmentProjectBenefitDto.fromJson(data);
  }

  Future<Uint8List> downloadBenefitReport({required String benefitId}) async {
    final response = await _dioForPath(benefitDownloadPath).put<List<int>>(
      benefitDownloadPath,
      queryParameters: <String, dynamic>{
        'benefitId': int.tryParse(benefitId) ?? benefitId,
      },
      options: authRequired(true).copyWith(responseType: ResponseType.bytes),
    );

    final rawBytes = response.data ?? const <int>[];
    if (rawBytes.isEmpty) {
      return Uint8List(0);
    }
    final bytes = Uint8List.fromList(rawBytes);
    final header = utf8
        .decode(
          bytes.length > 128 ? bytes.sublist(0, 128) : bytes,
          allowMalformed: true,
        )
        .trimLeft();
    if (header.startsWith('%PDF-')) {
      return bytes;
    }

    final contentType =
        response.headers.value(Headers.contentTypeHeader)?.toLowerCase() ?? '';
    if (contentType.contains('json') || header.startsWith('{')) {
      final decoded = utf8.decode(bytes, allowMalformed: true);
      final payload = _envelopeCodec.toJsonMap(
        jsonDecode(decoded) as Map<String, dynamic>,
      );
      if (payload.isEmpty) {
        throw StateError('Failed to load benefit report.');
      }

      if (_envelopeCodec.looksLikeEnvelope(payload)) {
        _envelopeCodec.assertSuccessIfEnvelope(
          payload,
          fallbackMessage: 'Failed to load benefit report.',
          requireTruthyData: false,
        );
        final inlineText =
            payload[_envelopeCodec.profile.dataKey]?.toString().trim() ?? '';
        if (inlineText.isEmpty) {
          return Uint8List(0);
        }
      }
    }

    throw StateError('Failed to load benefit report.');
  }

  Future<bool> submitBenefitWithdrawal({required String benefitId}) async {
    final response = await _dioForPath(benefitWithdrawalPath)
        .get<Map<String, dynamic>>(
          benefitWithdrawalPath,
          queryParameters: <String, dynamic>{
            'id': int.tryParse(benefitId) ?? benefitId,
          },
          options: authRequired(true),
        );

    final payload = _envelopeCodec.toJsonMap(response.data);
    _envelopeCodec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to submit benefit withdrawal request.',
      requireTruthyData: true,
    );

    if (_envelopeCodec.looksLikeEnvelope(payload)) {
      return _envelopeCodec.isTruthyData(payload['data']);
    }
    return true;
  }

  Future<void> submitSecondaryMarketCreate({
    required String fromProcessId,
    required int sellNum,
    required int price,
  }) async {
    final response = await _dioForPath(secondaryMarketCreatePath)
        .post<Map<String, dynamic>>(
          secondaryMarketCreatePath,
          data: <String, dynamic>{
            'fromProcessId': fromProcessId,
            'sellNum': sellNum.toString(),
            'price': price,
          },
          options: authRequired(true),
        );

    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to create secondary market sell order.',
      requireTruthyData: false,
    );
  }

  Future<void> submitSecondaryMarketModify({
    required String id,
    required String fromProcessId,
    required int sellNum,
    required int price,
    required String status,
    int thisTimeSoldNum = 0,
  }) async {
    final response = await _dioForPath(secondaryMarketModifyPath)
        .post<Map<String, dynamic>>(
          secondaryMarketModifyPath,
          data: <String, dynamic>{
            'id': id,
            'fromProcessId': fromProcessId,
            'sellNum': sellNum,
            'price': price,
            'status': status,
            'thisTimeSoldNum': thisTimeSoldNum,
          },
          options: authRequired(true),
        );

    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to modify secondary market order.',
      requireTruthyData: false,
    );
  }

  Future<void> submitSecondaryMarketPurchase({
    required String id,
    required int buyNum,
  }) async {
    final response = await _dioForPath(secondaryMarketPurchasePath)
        .post<Map<String, dynamic>>(
          secondaryMarketPurchasePath,
          data: <String, dynamic>{'buyNum': buyNum.toString(), 'id': id},
          options: authRequired(true),
        );

    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to submit secondary market purchase.',
      requireTruthyData: false,
    );
  }
}

String _formatApiDate(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
