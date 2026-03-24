import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/investment/domain/entities/fund_project.dart';
import 'package:fundex/features/investment/presentation/support/fund_project_yield_display.dart';

void main() {
  group('resolveFundProjectYieldDisplay', () {
    test('prefers open investor type range over expected distribution range',
        () {
      const project = FundProject(
        id: 'project-open',
        projectName: 'Open Fund',
        expectedDistributionRatioMin: 0.01,
        expectedDistributionRatioMax: 0.02,
        investorTypes: <FundProjectInvestorType>[
          FundProjectInvestorType(
            investorCode: 'A',
            earningsRadio: 0.08,
            isOpen: true,
          ),
          FundProjectInvestorType(
            investorCode: 'B',
            earningsRadio: 0.04,
            isOpen: true,
          ),
          FundProjectInvestorType(
            investorCode: 'C',
            earningsRadio: 0.10,
            isOpen: false,
          ),
        ],
      );

      expect(resolveFundProjectYieldDisplay(project), '4%～8%');
    });

    test('shows a single yield when only one open investor type exists', () {
      const project = FundProject(
        id: 'project-single',
        projectName: 'Single Fund',
        expectedDistributionRatioMin: 0.01,
        expectedDistributionRatioMax: 0.02,
        investorTypes: <FundProjectInvestorType>[
          FundProjectInvestorType(earningsRadio: 0.06, isOpen: true),
        ],
      );

      expect(resolveFundProjectYieldDisplay(project), '6%');
    });

    test('falls back to expected distribution range when no open type exists',
        () {
      const project = FundProject(
        id: 'project-closed',
        projectName: 'Closed Fund',
        expectedDistributionRatioMin: 0.01,
        expectedDistributionRatioMax: 0.02,
        investorTypes: <FundProjectInvestorType>[
          FundProjectInvestorType(earningsRadio: 0.08, isOpen: false),
        ],
      );

      expect(resolveFundProjectYieldDisplay(project), '1%～2%');
    });
  });
}
