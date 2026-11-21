import 'dart:async';
import 'dart:typed_data';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/investment/presentation/providers/fund_project_providers.dart';
import 'package:fundex/features/member_profile/domain/entities/mypage_models.dart';
import 'package:fundex/features/member_profile/domain/usecases/download_mypage_benefit_report_usecase.dart';
import 'package:fundex/features/member_profile/presentation/pages/my_page_active_fund_detail_page.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_providers.dart';
import 'package:fundex/l10n/app_localizations.dart';

class _Download implements DownloadMyPageBenefitReportUseCase {
  final result = Completer<Uint8List>();
  final ids = <String>[];
  @override
  Future<Uint8List> call({required String benefitId}) {
    ids.add(benefitId);
    return result.future;
  }
}

void main() {
  testWidgets('report shows progress, ignores repeated taps and allows retry', (
    tester,
  ) async {
    final download = _Download();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          downloadMyPageBenefitReportUseCaseProvider.overrideWithValue(
            download,
          ),
          myPageProjectBenefitProvider('p').overrideWith(
            (_) async => const MyPageProjectBenefit(
              details: [MyPageBenefitDetail(id: 'a', withdrawalTime: 'done')],
            ),
          ),
          myPageInvestmentListProvider.overrideWith((_) async => []),
          fundProjectListProvider.overrideWith((_) async => []),
        ],
        child: MaterialApp(
          locale: const Locale('ja'),
          theme: AppThemeFactory.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const MyPageActiveFundDetailPage(projectId: 'p'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final report = find.widgetWithText(OutlinedButton, 'レポート');
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    await tester.tap(report);
    await tester.tap(report);
    await tester.pump();
    expect(download.ids, ['a']);
    final spinner = find.descendant(
      of: find.byType(OutlinedButton),
      matching: find.byType(CircularProgressIndicator),
    );
    expect(spinner, findsOneWidget);
    download.result.completeError(StateError('unavailable'));
    await tester.pumpAndSettle();
    expect(spinner, findsNothing);
    expect(tester.widget<OutlinedButton>(report).onPressed, isNotNull);
    await tester.pump(const Duration(seconds: 2));
  });
}
