import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations_ext.dart';

class MemberProfileBankAccountStepPage extends StatelessWidget {
  const MemberProfileBankAccountStepPage({
    super.key,
    required this.bankNameController,
    required this.branchNameController,
    required this.accountType,
    required this.accountTypeItems,
    required this.accountNumberController,
    required this.accountHolderController,
    this.primaryButtonEnabled = true,
    this.onAccountTypeChanged,
    this.onNext,
  });

  final TextEditingController bankNameController;
  final TextEditingController branchNameController;
  final String? accountType;
  final List<DropdownMenuItem<String>> accountTypeItems;
  final TextEditingController accountNumberController;
  final TextEditingController accountHolderController;
  final bool primaryButtonEnabled;
  final ValueChanged<String?>? onAccountTypeChanged;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MemberProfileEditStepScaffold(
      title: l10n.memberProfileStep5Title,
      description: l10n.memberProfileStep5Description,
      primaryButtonLabel: l10n.memberProfileNextConsent,
      onPrimaryPressed: onNext,
      primaryButtonEnabled: primaryButtonEnabled,
      child: MemberProfileBankAccountFormSection(
        bankNameLabel: l10n.memberProfileBankNameLabel,
        bankNameController: bankNameController,
        bankNameHintText: l10n.memberProfileBankNameHint,
        branchNameLabel: l10n.memberProfileBranchLabel,
        branchNameController: branchNameController,
        branchNameHintText: l10n.memberProfileBranchHint,
        accountTypeLabel: l10n.memberProfileAccountTypeLabel,
        accountType: accountType,
        accountTypeItems: accountTypeItems,
        onAccountTypeChanged: onAccountTypeChanged,
        accountNumberLabel: l10n.memberProfileAccountNumberLabel,
        accountNumberController: accountNumberController,
        accountNumberHintText: l10n.memberProfileAccountNumberHint,
        accountHolderLabel: l10n.memberProfileAccountHolderLabel,
        accountHolderController: accountHolderController,
        accountHolderHintText: l10n.memberProfileAccountHolderHint,
      ),
    );
  }
}
