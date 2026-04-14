import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/investment/data/datasources/fund_project_remote_data_source.dart';
import 'package:fundex/features/investment/data/models/fund_project_dto.dart';
import 'package:fundex/features/investment/data/repositories/fund_project_repository_impl.dart';

class _FakeFundProjectRemoteDataSource implements FundProjectRemoteDataSource {
  List<FundProjectDto> result = const <FundProjectDto>[];
  FundProjectDto detailResult = const FundProjectDto(
    id: 'detail',
    projectName: 'detail',
  );
  int callCount = 0;
  int detailCallCount = 0;
  int submitCallCount = 0;
  String? submittedProjectId;
  int? submittedUnits;
  int? submittedAmount;

  @override
  Future<List<FundProjectDto>> fetchFundProjectList() async {
    callCount += 1;
    return result;
  }

  @override
  Future<FundProjectDto> fetchFundProjectDetail({required String id}) async {
    detailCallCount += 1;
    return detailResult;
  }

  @override
  Future<void> submitLotteryApply({
    required String projectId,
    required int units,
    required int amount,
  }) async {
    submitCallCount += 1;
    submittedProjectId = projectId;
    submittedUnits = units;
    submittedAmount = amount;
  }
}

void main() {
  group('FundProjectRepositoryImpl', () {
    test('fetchFundProjectList maps DTO list to domain entities', () async {
      final remote = _FakeFundProjectRemoteDataSource()
        ..result = <FundProjectDto>[
          const FundProjectDto(
            id: 'p1',
            projectName: '繁星優選Fund商品20241123',
            expectedDistributionRatioMax: 0.02,
            expectedDistributionRatioMin: 0.01,
            investmentUnit: 100000,
            maximumInvestmentPerPerson: 100,
            projectStatus: 4,
            investorTypes: <FundProjectInvestorTypeDto>[
              FundProjectInvestorTypeDto(
                id: 'i1',
                investorType: 'INVESTMENT',
                investorCode: '優先出資者A',
              ),
            ],
            pdfDocuments: <FundProjectPdfDocumentDto>[
              FundProjectPdfDocumentDto(
                projectId: 'p1',
                type: 1,
                description: '契約成立前書面',
                urls: <FundProjectPdfUrlDto>[
                  FundProjectPdfUrlDto(
                    name: '契約成立前書面.pdf',
                    url: 'https://cdn.example.com/a.pdf',
                    createTime: '2026-03-17T04:43:45.454Z',
                  ),
                ],
              ),
            ],
          ),
        ];

      final repository = FundProjectRepositoryImpl(remote: remote);

      final entities = await repository.fetchFundProjectList();

      expect(remote.callCount, 1);
      expect(entities, hasLength(1));
      expect(entities.first.id, 'p1');
      expect(entities.first.projectName, '繁星優選Fund商品20241123');
      expect(entities.first.projectStatus, 4);
      expect(entities.first.investorTypes, hasLength(1));
      expect(entities.first.investorTypes.first.investorCode, '優先出資者A');
      expect(entities.first.pdfDocuments, hasLength(1));
      expect(entities.first.pdfDocuments.first.description, '契約成立前書面');
      expect(entities.first.pdfDocuments.first.urls, hasLength(1));
      expect(entities.first.pdfDocuments.first.urls.first.name, '契約成立前書面.pdf');
      expect(
        entities.first.pdfDocuments.first.urls.first.url,
        'https://cdn.example.com/a.pdf',
      );
    });

    test('fetchFundProjectDetail maps DTO to domain entity', () async {
      final remote = _FakeFundProjectRemoteDataSource()
        ..detailResult = const FundProjectDto(
          id: 'p-detail',
          projectName: '繁星優選Fund商品20241123',
          distributionDate: '2025-03-31',
          typeOfOffering: 'LOTTERY',
          operatingCompany: '運営会社',
          operatingCompanyAccount: 127005,
          accountId: '48978',
          liveJapanBank: FundProjectLiveJapanBankDto(
            bankName: 'みずほ銀行',
            branchBankName: '船場支店',
            bankNumber: '普通3081072',
            bankAccountOwnerName: '株式会社繁星優選 大阪2号',
          ),
          detailData: <String, Object?>{'permitNumber': '東京都知事 第001号'},
        );

      final repository = FundProjectRepositoryImpl(remote: remote);

      final entity = await repository.fetchFundProjectDetail(id: 'p-detail');

      expect(remote.detailCallCount, 1);
      expect(entity.id, 'p-detail');
      expect(entity.projectName, '繁星優選Fund商品20241123');
      expect(entity.distributionDate, '2025-03-31');
      expect(entity.typeOfOffering, 'LOTTERY');
      expect(entity.operatingCompany, '運営会社');
      expect(entity.operatingCompanyAccount, 127005);
      expect(entity.accountId, '48978');
      expect(entity.liveJapanBank?.bankName, 'みずほ銀行');
      expect(entity.liveJapanBank?.branchBankName, '船場支店');
      expect(entity.liveJapanBank?.bankNumber, '普通3081072');
      expect(entity.detailData['permitNumber'], '東京都知事 第001号');
    });

    test('submitLotteryApply delegates to remote data source', () async {
      final remote = _FakeFundProjectRemoteDataSource();
      final repository = FundProjectRepositoryImpl(remote: remote);

      await repository.submitLotteryApply(
        projectId: '453461223659215318',
        units: 5,
        amount: 500000,
      );

      expect(remote.submitCallCount, 1);
      expect(remote.submittedProjectId, '453461223659215318');
      expect(remote.submittedUnits, 5);
      expect(remote.submittedAmount, 500000);
    });
  });
}
