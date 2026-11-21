import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/investment/domain/entities/fund_project.dart';
import 'package:fundex/features/wallet/domain/entities/wallet_bank_account_info.dart';
import 'package:fundex/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:fundex/features/wallet/presentation/widgets/project_deposit_bank_card.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  for (final scenario in ['dedicated', 'missing', 'incomplete', 'error']) {
    testWidgets('project deposit account lookup — $scenario', (tester) async {
      final lookup = Completer<WalletBankAccountInfo?>();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            depositBankAccountProvider.overrideWith((ref) => lookup.future),
          ],
          child: MaterialApp(
            theme: AppThemeFactory.light(locale: const Locale('ja')),
            locale: const Locale('ja'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(
              body: SingleChildScrollView(
                child: ProjectDepositBankCard(
                  liveJapanBank: FundProjectLiveJapanBank(
                    bankName: 'Project bank',
                  ),
                  notLiveJapanBank: null,
                  texts: _texts,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Project bank'), findsNothing);
      if (scenario == 'error') {
        lookup.completeError(StateError('unavailable'));
      } else {
        lookup.complete(
          scenario == 'missing'
              ? null
              : WalletBankAccountInfo(
                  bankName: 'Member bank',
                  branchName: 'Member branch',
                  accountType: '普通',
                  accountNumber: scenario == 'incomplete' ? '--' : '1234567',
                  accountHolder: 'Member holder',
                ),
        );
      }
      await tester.pumpAndSettle();
      final dedicated = scenario == 'dedicated';
      expect(
        find.text('Member bank'),
        dedicated ? findsOneWidget : findsNothing,
      );
      expect(
        find.text('Project bank'),
        dedicated ? findsNothing : findsOneWidget,
      );
    });
  }
}

const _texts = ProjectDepositBankCardTexts(
  domesticTitle: 'domesticTitle',
  overseasTitle: 'overseasTitle',
  domesticSegmentLabel: 'domesticSegmentLabel',
  overseasSegmentLabel: 'overseasSegmentLabel',
  copyLabel: 'copyLabel',
  copyDoneMessage: 'copyDoneMessage',
  bankInfoSectionTitle: 'bankInfoSectionTitle',
  recipientInfoSectionTitle: 'recipientInfoSectionTitle',
  bankNameLabel: 'bankNameLabel',
  swiftCodeLabel: 'swiftCodeLabel',
  branchNameLabel: 'branchNameLabel',
  branchAddressLabel: 'branchAddressLabel',
  bankCountryLabel: 'bankCountryLabel',
  accountNumberLabel: 'accountNumberLabel',
  accountHolderLabel: 'accountHolderLabel',
  accountHolderAddressLabel: 'accountHolderAddressLabel',
  transferNotice: 'transferNotice',
  transferName: 'transferName',
  transferNameCopyButtonLabel: 'transferNameCopyButtonLabel',
);
