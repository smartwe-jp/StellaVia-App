import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/investment/domain/entities/fund_project.dart';
import 'package:fundex/features/investment/presentation/support/fund_project_detail_view_data.dart';
import 'package:fundex/features/settings/presentation/support/settings_operating_company_content.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
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
}
