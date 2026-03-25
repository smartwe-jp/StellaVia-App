import 'dart:async';

import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:test/test.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._handler);

  final Future<ResponseBody> Function(RequestOptions options) _handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return _handler(options);
  }
}

ResponseBody _jsonOk([String body = '{}']) {
  return ResponseBody.fromString(
    body,
    200,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>['application/json'],
    },
  );
}

Dio _buildDio(Future<ResponseBody> Function(RequestOptions options) handler) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com/api'));
  dio.httpClientAdapter = _FakeAdapter(handler);
  return dio;
}

void main() {
  group('UserWalletApiClient', () {
    test('fetchAccountHistory sends GET with accountType query', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('GET'));
        expect(options.path, equals(UserWalletApiPaths.accountHistory));
        expect(
          options.queryParameters,
          equals(<String, dynamic>{'accountType': 1}),
        );
        expect(options.extra['auth_required'], isTrue);
        return _jsonOk(
          '{"msg":"success","code":200,"data":[{"amount":"50000","inOut":"收","tradeType":"借入金より振替","businessId":null,"balance":"12000","tradeTime":"2026-03-15","createTime":"2026-03-15 10:00:00","remark":"入金"}]}',
        );
      });
      final api = UserWalletApiClient(dioForPath: (_) => dio);

      final rows = await api.fetchAccountHistory(accountType: 1);

      expect(rows, hasLength(1));
      expect(rows.first.amount, equals(50000));
      expect(rows.first.inOut, equals('收'));
      expect(rows.first.tradeType, equals('借入金より振替'));
      expect(rows.first.businessId, isNull);
      expect(rows.first.balance, equals(12000));
      expect(rows.first.remark, equals('入金'));
      expect(rows.first.tradeTime, equals('2026-03-15'));
    });

    test('fetchAccountHistory throws when envelope code failed', () async {
      final dio = _buildDio((_) async {
        return _jsonOk('{"msg":"failed","code":500,"data":null}');
      });
      final api = UserWalletApiClient(dioForPath: (_) => dio);

      expect(() => api.fetchAccountHistory(), throwsA(isA<StateError>()));
    });

    test('fetchBankAccountInfo parses account pool and expiry', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('GET'));
        expect(options.path, equals(UserWalletApiPaths.bankAccountInfo));
        expect(options.extra['auth_required'], isTrue);
        return _jsonOk(
          '{"msg":"success","code":200,"data":{"accountPool":{"id":"464950875485437952","bankName":"りそな銀行","branchName":"振込集中第一","accountType":"普通","accountNumber":"0550102","accountName":"カ)タニマチクン","version":1},"userId":48815,"bankAccountId":"464950875485437952","bindStatus":0,"expireTime":"2026-04-15","zeroBalanceStartTime":null,"createTime":"2026-03-16 17:22:16","updateTime":"2026-03-16 17:22:16"}}',
        );
      });
      final api = UserWalletApiClient(dioForPath: (_) => dio);

      final info = await api.fetchBankAccountInfo();

      expect(info, isNotNull);
      expect(info?.accountPool?.bankName, equals('りそな銀行'));
      expect(info?.accountPool?.accountNumber, equals('0550102'));
      expect(info?.expireTime, equals('2026-04-15'));
    });

    test('fetchBankAccountInfo returns null when data is empty', () async {
      final dio = _buildDio((_) async {
        return _jsonOk('{"msg":"success","code":200,"data":null}');
      });
      final api = UserWalletApiClient(dioForPath: (_) => dio);

      final info = await api.fetchBankAccountInfo();

      expect(info, isNull);
    });

    test('fetchBankAccountList sends GET and maps new member bank list fields',
        () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('GET'));
        expect(options.path, equals(UserWalletApiPaths.bankAccountList));
        expect(options.queryParameters, isEmpty);
        expect(options.extra['auth_required'], isTrue);
        return _jsonOk(
          '{"msg":"success","code":0,"data":[{"bankName":"みずほ銀行","branchBankName":"渋谷支店","bankAccountType":1,"bankNumber":"1234567","bankAccountOwnerName":"ヤマダ タロウ","id":82828}]}',
        );
      });
      final api = UserWalletApiClient(dioForPath: (_) => dio);

      final rows = await api.fetchBankAccountList();

      expect(rows, hasLength(1));
      expect(rows.first.id, equals('82828'));
      expect(rows.first.bankName, equals('みずほ銀行'));
      expect(rows.first.branchName, equals('渋谷支店'));
      expect(rows.first.accountType, equals('1'));
      expect(rows.first.accountNumber, equals('1234567'));
      expect(rows.first.accountName, equals('ヤマダ タロウ'));
    });

    test('fetchWithdrawCost sends GET with bankId query', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('GET'));
        expect(options.path, equals(UserWalletApiPaths.withdrawCost));
        expect(
          options.queryParameters,
          equals(<String, dynamic>{'bankId': '82828'}),
        );
        expect(options.extra['auth_required'], isTrue);
        return _jsonOk('{"msg":"success","code":0,"data":15}');
      });
      final api = UserWalletApiClient(dioForPath: (_) => dio);

      final cost = await api.fetchWithdrawCost(bankId: '82828');

      expect(cost, equals(15));
    });

    test('fetchWithdrawHistory sends POST and maps withdraw-list fields',
        () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(UserWalletApiPaths.withdrawHistory));
        expect(options.extra['auth_required'], isTrue);
        expect(options.data, equals(<String, dynamic>{
          'startPage': '1',
          'limit': '10',
        }));
        return _jsonOk(
          '{"msg":"success","code":200,"data":{"total":1,"limit":10,"currentPage":1,"rows":[{"withdrawId":"465110732059508736","memberId":125530,"processId":"2737333","withdrawType":0,"bookCrashDate":null,"applyTime":"2026-03-23","withdrawCost":10000,"applyAmount":50000,"bankName":"Peoplebank","branchBankName":"Zhdjd","bankNumber":"5484848467","confirmPayTime":null,"payStatus":2,"payRemark":"审核中"}]}}',
        );
      });
      final api = UserWalletApiClient(dioForPath: (_) => dio);

      final rows = await api.fetchWithdrawHistory();

      expect(rows, hasLength(1));
      expect(rows.first.withdrawId, equals('465110732059508736'));
      expect(rows.first.memberId, equals(125530));
      expect(rows.first.processId, equals('2737333'));
      expect(rows.first.amount, equals(50000));
      expect(rows.first.cost, equals(10000));
      expect(rows.first.bankName, equals('Peoplebank'));
      expect(rows.first.bankBranch, equals('Zhdjd'));
      expect(rows.first.bankNumber, equals('5484848467'));
      expect(rows.first.payStatus, equals(2));
      expect(rows.first.status, equals(2));
      expect(rows.first.remark, equals('审核中'));
    });

    test('cancelWithdraw sends PUT with withdraw detail body', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('PUT'));
        expect(options.path, equals(UserWalletApiPaths.withdrawCancel));
        expect(options.extra['auth_required'], isTrue);
        expect(options.data, isA<Map<String, dynamic>>());
        final body = options.data as Map<String, dynamic>;
        expect(body['withdrawId'], equals('123456'));
        expect(body['payStatus'], equals(0));
        expect(body['amount'], equals(5000));
        expect(body['cost'], equals(10));
        expect(body['bankNumber'], equals('1234567'));
        return _jsonOk('{"msg":"success","code":200,"data":true}');
      });
      final api = UserWalletApiClient(dioForPath: (_) => dio);

      await api.cancelWithdraw(
        const UserWalletWithdrawCancelRequestDto(
          withdrawId: '123456',
          amount: 5000,
          bankNumber: '1234567',
          cost: 10,
          payStatus: 0,
          withdrawType: 0,
        ),
      );
    });

    test('applyBankAccount sends GET and checks success envelope', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('GET'));
        expect(options.path, equals(UserWalletApiPaths.bankAccountApply));
        expect(options.extra['auth_required'], isTrue);
        return _jsonOk('{"msg":"success","code":200,"data":true}');
      });
      final api = UserWalletApiClient(dioForPath: (_) => dio);

      await api.applyBankAccount();
    });

    test('addBankAccount sends POST with domestic payload', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(UserWalletApiPaths.bankAccountAdd));
        expect(options.extra['auth_required'], isTrue);
        final body = options.data as Map<String, dynamic>;
        expect(body['bankType'], equals(0));
        expect(body['bankName'], equals('みずほ銀行'));
        expect(body['branchName'], equals('渋谷支店'));
        expect(body['branchBankName'], equals('渋谷支店'));
        expect(body['accountType'], equals('ordinary'));
        expect(body['bankAccountType'], equals('ordinary'));
        expect(body['accountNumber'], equals('1234567'));
        expect(body['bankNumber'], equals('1234567'));
        expect(body['accountName'], equals('ヤマダ タロウ'));
        expect(body['bankAccountOwnerName'], equals('ヤマダ タロウ'));
        return _jsonOk('{"msg":"success","code":200,"data":true}');
      });
      final api = UserWalletApiClient(dioForPath: (_) => dio);

      await api.addBankAccount(
        const UserWalletBankAccountAddRequestDto(
          bankName: 'みずほ銀行',
          bankType: 0,
          branchName: '渋谷支店',
          accountType: 'ordinary',
          accountNumber: '1234567',
          accountName: 'ヤマダ タロウ',
        ),
      );
    });

    test('addBankAccount sends POST with overseas payload', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(UserWalletApiPaths.bankAccountAdd));
        expect(options.extra['auth_required'], isTrue);
        final body = options.data as Map<String, dynamic>;
        expect(body['bankType'], equals(1));
        expect(body['bankName'], equals('Peoplebank'));
        expect(body['branchName'], equals('Zhdjd'));
        expect(body['branchBankName'], equals('Zhdjd'));
        expect(body['branchBankNumber'], equals('001'));
        expect(body['accountNumber'], equals('5484848467'));
        expect(body['bankNumber'], equals('5484848467'));
        expect(body['accountName'], equals('Diaowen'));
        expect(body['bankAccountOwnerName'], equals('Diaowen'));
        expect(body['bankAccountOwnerAddress'], equals('大阪'));
        expect(body['bankAccountOwnerNationality'], equals('中国'));
        expect(body['bankAccountSwiftCode'], equals('AAAABBCCDDD'));
        expect(body['bankCountry'], equals('日本'));
        expect(body['branchBankAddress'], equals('東京都千代田区'));
        return _jsonOk('{"msg":"success","code":200,"data":true}');
      });
      final api = UserWalletApiClient(dioForPath: (_) => dio);

      await api.addBankAccount(
        const UserWalletBankAccountAddRequestDto(
          bankName: 'Peoplebank',
          bankType: 1,
          branchName: 'Zhdjd',
          branchBankNumber: '001',
          accountNumber: '5484848467',
          accountName: 'Diaowen',
          bankAccountOwnerAddress: '大阪',
          bankAccountOwnerNationality: '中国',
          bankAccountSwiftCode: 'AAAABBCCDDD',
          bankCountry: '日本',
          branchBankAddress: '東京都千代田区',
        ),
      );
    });
  });
}
