import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations_ext.dart';

class MemberProfileBankAccountStepPage extends StatelessWidget {
  const MemberProfileBankAccountStepPage({
    super.key,
    required this.bankNameController,
    required this.branchNameController,
    required this.branchNumberController,
    required this.accountType,
    required this.accountTypeItems,
    required this.accountNumberController,
    required this.accountHolderController,
    this.primaryButtonEnabled = true,
    this.showSkip = false,
    this.titleOverride,
    this.descriptionOverride,
    this.primaryButtonLabelOverride,
    this.onAccountTypeChanged,
    this.onNext,
    this.onSkip,
  });

  final TextEditingController bankNameController;
  final TextEditingController branchNameController;
  final TextEditingController branchNumberController;
  final String? accountType;
  final List<DropdownMenuItem<String>> accountTypeItems;
  final TextEditingController accountNumberController;
  final TextEditingController accountHolderController;
  final bool primaryButtonEnabled;
  final bool showSkip;
  final String? titleOverride;
  final String? descriptionOverride;
  final String? primaryButtonLabelOverride;
  final ValueChanged<String?>? onAccountTypeChanged;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MemberProfileEditStepScaffold(
      title: titleOverride ?? l10n.memberProfileStep5Title,
      description: descriptionOverride ?? l10n.memberProfileStep5Description,
      primaryButtonLabel:
          primaryButtonLabelOverride ?? l10n.memberProfileNextConsent,
      onPrimaryPressed: onNext,
      primaryButtonEnabled: primaryButtonEnabled,
      showSkip: showSkip,
      skipLabel: l10n.commonSkipChevron,
      onSkip: onSkip,
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
        branchNumberLabel: l10n.walletBankSettingsBranchNumberLabel,
        branchNumberController: branchNumberController,
        branchNumberHintText: l10n.walletBankSettingsBranchNumberHint,
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
