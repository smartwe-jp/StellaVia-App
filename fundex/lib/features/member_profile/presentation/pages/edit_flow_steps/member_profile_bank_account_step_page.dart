import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../app/localization/app_localizations_ext.dart';

class MemberProfileBankAccountStepPage extends StatelessWidget {
  const MemberProfileBankAccountStepPage({
    super.key,
    required this.bankRegionLabel,
    required this.bankRegionType,
    required this.bankRegionItems,
    required this.bankNameController,
    required this.branchNameController,
    required this.branchNumberController,
    required this.accountType,
    required this.accountTypeItems,
    required this.accountNumberController,
    required this.accountHolderController,
    required this.accountHolderAddressController,
    required this.accountHolderNationalityController,
    required this.swiftCodeController,
    required this.bankCountryController,
    required this.branchAddressController,
    required this.domesticTip,
    required this.overseasTip,
    this.primaryButtonEnabled = true,
    this.showSkip = false,
    this.titleOverride,
    this.descriptionOverride,
    this.secondaryButtonLabelOverride,
    this.onSecondaryPressed,
    this.primaryButtonLabelOverride,
    this.onBankRegionChanged,
    this.onAccountTypeChanged,
    this.onNext,
    this.onSkip,
  });

  final String bankRegionLabel;
  final String? bankRegionType;
  final List<DropdownMenuItem<String>> bankRegionItems;
  final TextEditingController bankNameController;
  final TextEditingController branchNameController;
  final TextEditingController branchNumberController;
  final String? accountType;
  final List<DropdownMenuItem<String>> accountTypeItems;
  final TextEditingController accountNumberController;
  final TextEditingController accountHolderController;
  final TextEditingController accountHolderAddressController;
  final TextEditingController accountHolderNationalityController;
  final TextEditingController swiftCodeController;
  final TextEditingController bankCountryController;
  final TextEditingController branchAddressController;
  final String domesticTip;
  final String overseasTip;
  final bool primaryButtonEnabled;
  final bool showSkip;
  final String? titleOverride;
  final String? descriptionOverride;
  final String? secondaryButtonLabelOverride;
  final VoidCallback? onSecondaryPressed;
  final String? primaryButtonLabelOverride;
  final ValueChanged<String?>? onBankRegionChanged;
  final ValueChanged<String?>? onAccountTypeChanged;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isOverseas = bankRegionType == 'overseas';

    return MemberProfileEditStepScaffold(
      title: titleOverride ?? l10n.memberProfileStep5Title,
      description: descriptionOverride ?? l10n.memberProfileStep5Description,
      secondaryButtonLabel: secondaryButtonLabelOverride,
      onSecondaryPressed: onSecondaryPressed,
      primaryButtonLabel:
          primaryButtonLabelOverride ?? l10n.memberProfileNextConsent,
      onPrimaryPressed: onNext,
      primaryButtonEnabled: primaryButtonEnabled,
      showSkip: showSkip,
      skipLabel: l10n.commonSkipChevron,
      onSkip: onSkip,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MemberProfileSelectField<String>(
            label: bankRegionLabel,
            value: bankRegionType,
            items: bankRegionItems,
            onChanged: onBankRegionChanged,
            isRequired: true,
          ),
          const SizedBox(height: 18),
          if (isOverseas)
            _OverseasBankAccountFormSection(
              bankNameController: bankNameController,
              branchNameController: branchNameController,
              branchNumberController: branchNumberController,
              accountNumberController: accountNumberController,
              accountHolderController: accountHolderController,
              accountHolderAddressController: accountHolderAddressController,
              accountHolderNationalityController:
                  accountHolderNationalityController,
              swiftCodeController: swiftCodeController,
              bankCountryController: bankCountryController,
              branchAddressController: branchAddressController,
            )
          else
            MemberProfileBankAccountFormSection(
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
              accountHolderInputFormatters: <TextInputFormatter>[
                MemberProfileInputFormatters.katakanaOnly,
              ],
            ),
          const SizedBox(height: 18),
          _BankAccountTipBanner(
            message: isOverseas ? overseasTip : domesticTip,
          ),
        ],
      ),
    );
  }
}

class _OverseasBankAccountFormSection extends StatelessWidget {
  const _OverseasBankAccountFormSection({
    required this.bankNameController,
    required this.branchNameController,
    required this.branchNumberController,
    required this.accountNumberController,
    required this.accountHolderController,
    required this.accountHolderAddressController,
    required this.accountHolderNationalityController,
    required this.swiftCodeController,
    required this.bankCountryController,
    required this.branchAddressController,
  });

  final TextEditingController bankNameController;
  final TextEditingController branchNameController;
  final TextEditingController branchNumberController;
  final TextEditingController accountNumberController;
  final TextEditingController accountHolderController;
  final TextEditingController accountHolderAddressController;
  final TextEditingController accountHolderNationalityController;
  final TextEditingController swiftCodeController;
  final TextEditingController bankCountryController;
  final TextEditingController branchAddressController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: <Widget>[
        MemberProfileTextField(
          label: l10n.memberProfileBankNameLabel,
          controller: bankNameController,
          hintText: l10n.walletBankSettingsOverseasBankNameHint,
        ),
        const SizedBox(height: 18),
        MemberProfileTextField(
          label: l10n.memberProfileBranchLabel,
          controller: branchNameController,
          hintText: l10n.walletBankSettingsOverseasBranchNameHint,
        ),
        const SizedBox(height: 18),
        MemberProfileTextField(
          label: l10n.walletBankSettingsBranchNumberLabel,
          controller: branchNumberController,
          hintText: l10n.walletBankSettingsOverseasBranchNumberHint,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 18),
        MemberProfileTextField(
          label: l10n.memberProfileAccountNumberLabel,
          controller: accountNumberController,
          hintText: l10n.walletBankSettingsOverseasAccountNumberHint,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 18),
        MemberProfileTextField(
          label: l10n.walletBankSettingsOverseasAccountHolderLabel,
          controller: accountHolderController,
          hintText: l10n.walletBankSettingsOverseasAccountHolderHint,
        ),
        const SizedBox(height: 18),
        MemberProfileTextField(
          label: l10n.walletBankSettingsOwnerAddressLabel,
          controller: accountHolderAddressController,
          hintText: l10n.walletBankSettingsOwnerAddressHint,
          maxLines: 2,
        ),
        const SizedBox(height: 18),
        MemberProfileTextField(
          label: l10n.walletBankSettingsOwnerNationalityLabel,
          controller: accountHolderNationalityController,
          hintText: l10n.walletBankSettingsOwnerNationalityHint,
        ),
        const SizedBox(height: 18),
        MemberProfileTextField(
          label: l10n.walletBankSettingsSwiftCodeLabel,
          controller: swiftCodeController,
          hintText: l10n.walletBankSettingsSwiftCodeHint,
        ),
        const SizedBox(height: 18),
        MemberProfileTextField(
          label: l10n.walletBankSettingsBankCountryLabel,
          controller: bankCountryController,
          hintText: l10n.walletBankSettingsBankCountryHint,
        ),
        const SizedBox(height: 18),
        MemberProfileTextField(
          label: l10n.walletBankSettingsBranchAddressLabel,
          controller: branchAddressController,
          hintText: l10n.walletBankSettingsBranchAddressHint,
          maxLines: 2,
        ),
      ],
    );
  }
}

class _BankAccountTipBanner extends StatelessWidget {
  const _BankAccountTipBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: colors.warningSubtle,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.warningBorder),
      ),
      child: Text(
        message,
        style: appText.body.copyWith(
          color: colors.warningForeground,
          height: 1.5,
        ),
      ),
    );
  }
}
