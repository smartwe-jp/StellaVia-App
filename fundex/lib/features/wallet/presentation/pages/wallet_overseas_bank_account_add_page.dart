import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../domain/entities/wallet_bank_account_draft.dart';
import '../providers/wallet_providers.dart';

class WalletOverseasBankAccountAddPage extends ConsumerStatefulWidget {
  const WalletOverseasBankAccountAddPage({super.key});

  @override
  ConsumerState<WalletOverseasBankAccountAddPage> createState() =>
      _WalletOverseasBankAccountAddPageState();
}

class _WalletOverseasBankAccountAddPageState
    extends ConsumerState<WalletOverseasBankAccountAddPage> {
  late final TextEditingController _bankNameController;
  late final TextEditingController _branchNameController;
  late final TextEditingController _branchNumberController;
  late final TextEditingController _accountNumberController;
  late final TextEditingController _accountHolderController;
  late final TextEditingController _accountHolderAddressController;
  late final TextEditingController _accountHolderNationalityController;
  late final TextEditingController _swiftCodeController;
  late final TextEditingController _bankCountryController;
  late final TextEditingController _branchAddressController;

  @override
  void initState() {
    super.initState();
    _bankNameController = TextEditingController()..addListener(_handleChanged);
    _branchNameController = TextEditingController()
      ..addListener(_handleChanged);
    _branchNumberController = TextEditingController()
      ..addListener(_handleChanged);
    _accountNumberController = TextEditingController()
      ..addListener(_handleChanged);
    _accountHolderController = TextEditingController()
      ..addListener(_handleChanged);
    _accountHolderAddressController = TextEditingController()
      ..addListener(_handleChanged);
    _accountHolderNationalityController = TextEditingController()
      ..addListener(_handleChanged);
    _swiftCodeController = TextEditingController()..addListener(_handleChanged);
    _bankCountryController = TextEditingController()
      ..addListener(_handleChanged);
    _branchAddressController = TextEditingController()
      ..addListener(_handleChanged);
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _branchNameController.dispose();
    _branchNumberController.dispose();
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    _accountHolderAddressController.dispose();
    _accountHolderNationalityController.dispose();
    _swiftCodeController.dispose();
    _bankCountryController.dispose();
    _branchAddressController.dispose();
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  bool _isFilled(String value) => value.trim().isNotEmpty;

  bool get _canSubmit {
    return _isFilled(_bankNameController.text) &&
        _isFilled(_branchNameController.text) &&
        _isFilled(_branchNumberController.text) &&
        _isFilled(_accountNumberController.text) &&
        _isFilled(_accountHolderController.text) &&
        _isFilled(_accountHolderAddressController.text) &&
        _isFilled(_accountHolderNationalityController.text) &&
        _isFilled(_swiftCodeController.text) &&
        _isFilled(_bankCountryController.text) &&
        _isFilled(_branchAddressController.text);
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (!_canSubmit) {
      AppNotice.show(context, message: l10n.walletBankSettingsRequiredError);
      return;
    }

    ref.read(walletBankAccountAddingProvider.notifier).state = true;
    try {
      await ref
          .read(addWalletBankAccountUseCaseProvider)
          .call(
            WalletBankAccountDraft.overseas(
              bankName: _bankNameController.text.trim(),
              branchName: _branchNameController.text.trim(),
              branchNumber: _branchNumberController.text.trim(),
              accountNumber: _accountNumberController.text.trim(),
              accountHolder: _accountHolderController.text.trim(),
              accountHolderAddress: _accountHolderAddressController.text.trim(),
              accountHolderNationality: _accountHolderNationalityController.text
                  .trim(),
              swiftCode: _swiftCodeController.text.trim(),
              bankCountry: _bankCountryController.text.trim(),
              branchAddress: _branchAddressController.text.trim(),
            ),
          );
      if (!mounted) {
        return;
      }
      context.pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          l10n.walletBankSettingsAddFailure,
        ),
      );
    } finally {
      ref.read(walletBankAccountAddingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final isAdding = ref.watch(walletBankAccountAddingProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.walletBankSettingsOverseasAddTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(bottom: BorderSide(color: colors.border)),
        ),
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(false),
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: MemberProfileEditStepScaffold(
        title: l10n.walletBankSettingsOverseasAddTitle,
        description: l10n.walletBankSettingsOverseasAddDescription,
        primaryButtonLabel: l10n.walletBankSettingsAddAction,
        primaryButtonEnabled: !isAdding && _canSubmit,
        onPrimaryPressed: isAdding ? null : _submit,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MemberProfileTextField(
              label: l10n.memberProfileBankNameLabel,
              controller: _bankNameController,
              hintText: l10n.walletBankSettingsOverseasBankNameHint,
              isRequired: true,
            ),
            const SizedBox(height: 18),
            MemberProfileTextField(
              label: l10n.memberProfileBranchLabel,
              controller: _branchNameController,
              hintText: l10n.walletBankSettingsOverseasBranchNameHint,
              isRequired: true,
            ),
            const SizedBox(height: 18),
            MemberProfileTextField(
              label: l10n.walletBankSettingsBranchNumberLabel,
              controller: _branchNumberController,
              hintText: l10n.walletBankSettingsOverseasBranchNumberHint,
              keyboardType: TextInputType.number,
              isRequired: true,
            ),
            const SizedBox(height: 18),
            MemberProfileTextField(
              label: l10n.memberProfileAccountNumberLabel,
              controller: _accountNumberController,
              hintText: l10n.walletBankSettingsOverseasAccountNumberHint,
              keyboardType: TextInputType.number,
              isRequired: true,
            ),
            const SizedBox(height: 18),
            MemberProfileTextField(
              label: l10n.walletBankSettingsOverseasAccountHolderLabel,
              controller: _accountHolderController,
              hintText: l10n.walletBankSettingsOverseasAccountHolderHint,
              isRequired: true,
            ),
            const SizedBox(height: 18),
            MemberProfileTextField(
              label: l10n.walletBankSettingsOwnerAddressLabel,
              controller: _accountHolderAddressController,
              hintText: l10n.walletBankSettingsOwnerAddressHint,
              maxLines: 2,
              isRequired: true,
            ),
            const SizedBox(height: 18),
            MemberProfileTextField(
              label: l10n.walletBankSettingsOwnerNationalityLabel,
              controller: _accountHolderNationalityController,
              hintText: l10n.walletBankSettingsOwnerNationalityHint,
              isRequired: true,
            ),
            const SizedBox(height: 18),
            MemberProfileTextField(
              label: l10n.walletBankSettingsSwiftCodeLabel,
              controller: _swiftCodeController,
              hintText: l10n.walletBankSettingsSwiftCodeHint,
              isRequired: true,
            ),
            const SizedBox(height: 18),
            MemberProfileTextField(
              label: l10n.walletBankSettingsBankCountryLabel,
              controller: _bankCountryController,
              hintText: l10n.walletBankSettingsBankCountryHint,
              isRequired: true,
            ),
            const SizedBox(height: 18),
            MemberProfileTextField(
              label: l10n.walletBankSettingsBranchAddressLabel,
              controller: _branchAddressController,
              hintText: l10n.walletBankSettingsBranchAddressHint,
              maxLines: 2,
              isRequired: true,
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              decoration: BoxDecoration(
                color: colors.warningSubtle,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.warningBorder),
              ),
              child: Text(
                l10n.walletBankSettingsOverseasTip,
                style: appText.body.copyWith(
                  color: colors.warningForeground,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
