import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/investment/domain/entities/fund_project.dart';
import 'package:fundex/features/investment/presentation/support/fund_project_detail_view_data.dart';
import 'package:fundex/features/settings/presentation/support/settings_operating_company_content.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  testWidgets(
    'builds yield display without exposing offering targets in key facts',
    (WidgetTester tester) async {
      const project = FundProject(
        id: 'project-open',
        projectName: 'Open Fund',
        expectedDistributionRatioMin: 0.01,
        expectedDistributionRatioMax: 0.02,
        investorTypes: <FundProjectInvestorType>[
          FundProjectInvestorType(
            investorCode: '優先出資者A',
            earningsRadio: 0.08,
            isOpen: true,
          ),
          FundProjectInvestorType(
            investorCode: '優先出資者B',
            earningsRadio: 0.04,
            isOpen: true,
          ),
          FundProjectInvestorType(
            investorCode: '任意組合員',
            earningsRadio: 0.12,
            isOpen: false,
          ),
        ],
      );

      late FundProjectDetailViewData viewData;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ja'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppThemeFactory.light(locale: const Locale('ja')),
          home: Builder(
            builder: (BuildContext context) {
              viewData = FundProjectDetailViewDataBuilder.build(
                context: context,
                project: project,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(viewData.yieldDisplay, '4%～8%');
      expect(
        viewData.infoItems.any(
          (FundDetailInfoItemData item) => item.label == '募集対象',
        ),
        isFalse,
      );
    },
  );

  testWidgets(
    'falls back to expected distribution range when no open investor type exists',
    (WidgetTester tester) async {
      const project = FundProject(
        id: 'project-closed',
        projectName: 'Closed Fund',
        expectedDistributionRatioMin: 0.01,
        expectedDistributionRatioMax: 0.02,
        investorTypes: <FundProjectInvestorType>[
          FundProjectInvestorType(
            investorCode: '優先出資者A',
            earningsRadio: 0.08,
            isOpen: false,
          ),
        ],
      );

      late FundProjectDetailViewData viewData;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ja'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppThemeFactory.light(locale: const Locale('ja')),
          home: Builder(
            builder: (BuildContext context) {
              viewData = FundProjectDetailViewDataBuilder.build(
                context: context,
                project: project,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(viewData.yieldDisplay, '1%～2%');
    },
  );

  testWidgets(
    'shows a single yield when only one open investor type exists',
    (WidgetTester tester) async {
      const project = FundProject(
        id: 'project-single-open',
        projectName: 'Single Open Fund',
        expectedDistributionRatioMin: 0.01,
        expectedDistributionRatioMax: 0.02,
        investorTypes: <FundProjectInvestorType>[
          FundProjectInvestorType(
            investorCode: '優先出資者A',
            earningsRadio: 0.06,
            isOpen: true,
          ),
          FundProjectInvestorType(
            investorCode: '任意組合員',
            earningsRadio: 0.10,
            isOpen: false,
          ),
        ],
      );

      late FundProjectDetailViewData viewData;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ja'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppThemeFactory.light(locale: const Locale('ja')),
          home: Builder(
            builder: (BuildContext context) {
              viewData = FundProjectDetailViewDataBuilder.build(
                context: context,
                project: project,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(viewData.yieldDisplay, '6%');
    },
  );

  testWidgets(
    'uses operating company content for fund detail operator information',
    (WidgetTester tester) async {
      const project = FundProject(
        id: 'project-1',
        projectName: 'Test Fund',
        operatingCompany: 'Remote Operator',
        detailData: <String, Object?>{
          'permitNumber': 'Remote Permit',
          'representative': 'Remote Representative',
          'companyAddress': 'Remote Address',
        },
      );
      const operatingCompanyContent = SettingsOperatingCompanyContent(
        tradeName: 'Stella Asset 株式会社',
        licenseNumber: '不動産特定共同事業\n大阪府知事許可 第22号',
        licenseType: '第1号事業、第2号事業及び電子取引業務',
        representative: '代表取締役 谷中 譲',
        headOffice: '大阪府大阪市北区天満2-1-12',
        tel: '06-6940-4777',
        established: '2012年12月11日',
        business: '不動産特定共同事業、Eコマース等',
        manager: '瀬戸口 愛',
        copyright: '',
        links: <SettingsOperatingCompanyLink>[],
      );

      late FundProjectDetailViewData viewData;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ja'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppThemeFactory.light(locale: const Locale('ja')),
          home: Builder(
            builder: (BuildContext context) {
              viewData = FundProjectDetailViewDataBuilder.build(
                context: context,
                project: project,
                operatingCompanyContent: operatingCompanyContent,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(viewData.operatorItems, hasLength(4));
      expect(viewData.operatorItems[0].value, 'Stella Asset 株式会社');
      expect(viewData.operatorItems[1].value, '不動産特定共同事業\n大阪府知事許可 第22号');
      expect(viewData.operatorItems[2].value, '代表取締役 谷中 譲');
      expect(viewData.operatorItems[3].value, '大阪府大阪市北区天満2-1-12');
      expect(viewData.operatorMetaText, contains('設立：2012年12月11日'));
      expect(viewData.operatorMetaText, contains('主な事業：不動産特定共同事業、Eコマース等'));
      expect(viewData.operatorMetaText, contains('業務管理者：瀬戸口 愛'));
    },
  );

  testWidgets(
    'falls back to project operator fields when content is unavailable',
    (WidgetTester tester) async {
      const project = FundProject(
        id: 'project-2',
        projectName: 'Fallback Fund',
        operatingCompany: 'Fallback Operator',
        detailData: <String, Object?>{
          'permitNumber': 'Fallback Permit',
          'representative': 'Fallback Representative',
          'companyAddress': 'Fallback Address',
        },
      );

      late FundProjectDetailViewData viewData;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppThemeFactory.light(locale: const Locale('en')),
          home: Builder(
            builder: (BuildContext context) {
              viewData = FundProjectDetailViewDataBuilder.build(
                context: context,
                project: project,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(viewData.operatorItems, hasLength(4));
      expect(viewData.operatorItems[0].value, 'Fallback Operator');
      expect(viewData.operatorItems[1].value, 'Fallback Permit');
      expect(viewData.operatorItems[2].value, 'Fallback Representative');
      expect(viewData.operatorItems[3].value, 'Fallback Address');
    },
  );

  testWidgets(
    'maps key facts and schedule items to the requested fields',
    (WidgetTester tester) async {
      const project = FundProject(
        id: 'project-schedule',
        projectName: 'Schedule Fund',
        distributionDate: '各計算期間の属する月の2ヶ月後応当月の最終営業日まで',
        investmentPeriod: '12ヶ月',
        scheduledStartDate: '2025-09-01',
        scheduledEndDate: '2026-08-31',
        offeringStartDatetime: '2025-08-01 10:00:00',
        offeringEndDatetime: '2025-08-31 17:00:00',
        typeOfOffering: 'LOTTERY',
        offeringMethod: 'LOTTERY',
        gainType: 'INCOME_GAIN',
        investmentUnit: 1000000,
        maximumInvestmentPerPerson: 1250000000,
        amountApplication: 1250000000,
        currentlySubscribed: 1405000000,
        daysRemaining: 0,
        detailData: <String, Object?>{
          'contractType': '匿名組合型',
        },
      );

      late FundProjectDetailViewData viewData;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ja'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppThemeFactory.light(locale: const Locale('ja')),
          home: Builder(
            builder: (BuildContext context) {
              viewData = FundProjectDetailViewDataBuilder.build(
                context: context,
                project: project,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        viewData.infoItems.map((FundDetailInfoItemData item) => item.label),
        containsAll(<String>[
          '目標金額',
          '投資単位',
          '一人当たり\n投資可能上限金額',
          '募集金額',
          '運用期間',
        ]),
      );
      expect(
        viewData.infoItems.firstWhere(
          (FundDetailInfoItemData item) => item.label == '目標金額',
        ).value,
        '1,250,000,000円',
      );
      expect(
        viewData.infoItems.firstWhere(
          (FundDetailInfoItemData item) => item.label == '募集金額',
        ).value,
        '1,405,000,000円',
      );
      expect(
        viewData.contractScheduleItems.map(
          (FundDetailInfoItemData item) => item.label,
        ),
        containsAll(<String>[
          '募集期間',
          '運用期間',
          '募集方式',
          '募集種別',
          '残り日数',
          '配当日',
        ]),
      );
      expect(
        viewData.contractScheduleItems.firstWhere(
          (FundDetailInfoItemData item) => item.label == '募集種別',
        ).value,
        '匿名組合型',
      );
    },
  );
}
