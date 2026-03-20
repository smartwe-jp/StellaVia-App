import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../domain/entities/wallet_bank_account_draft.dart';
import '../providers/wallet_providers.dart';

class WalletBankAccountAddPage extends ConsumerStatefulWidget {
  const WalletBankAccountAddPage({super.key});

  @override
  ConsumerState<WalletBankAccountAddPage> createState() =>
      _WalletBankAccountAddPageState();
}

class _WalletBankAccountAddPageState
    extends ConsumerState<WalletBankAccountAddPage> {
  late final TextEditingController _bankNameController;
  late final TextEditingController _branchNameController;
  late final TextEditingController _accountNumberController;
  late final TextEditingController _accountHolderController;
  String? _accountType = _accountTypeOrdinary;

  @override
  void initState() {
    super.initState();
    _bankNameController = TextEditingController();
    _branchNameController = TextEditingController();
    _accountNumberController = TextEditingController();
    _accountHolderController = TextEditingController();
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _branchNameController.dispose();
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  bool _isFilled(String value) => value.trim().isNotEmpty;

  bool get _canSubmit {
    return _isFilled(_bankNameController.text) &&
        _isFilled(_branchNameController.text) &&
        _isFilled(_accountNumberController.text) &&
        _isFilled(_accountHolderController.text) &&
        _isFilled(_accountType ?? '');
  }

  List<DropdownMenuItem<String>> _accountTypeItems(BuildContext context) {
    final l10n = context.l10n;
    return const <String>[_accountTypeOrdinary, _accountTypeChecking]
        .map((String value) {
          final label = value == _accountTypeOrdinary
              ? l10n.accountTypeOrdinary
              : l10n.accountTypeChecking;
          return DropdownMenuItem<String>(value: value, child: Text(label));
        })
        .toList(growable: false);
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
            WalletBankAccountDraft(
              bankName: _bankNameController.text.trim(),
              branchName: _branchNameController.text.trim(),
              accountType: _accountType ?? _accountTypeOrdinary,
              accountNumber: _accountNumberController.text.trim(),
              accountHolder: _accountHolderController.text.trim(),
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
    final isAdding = ref.watch(walletBankAccountAddingProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.walletBankSettingsAddSheetTitle,
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
        title: l10n.walletBankSettingsAddSheetTitle,
        description: l10n.walletBankSettingsAddSheetDescription,
        primaryButtonLabel: l10n.walletBankSettingsAddAction,
        primaryButtonEnabled: !isAdding && _canSubmit,
        onPrimaryPressed: isAdding ? null : _submit,
        child: MemberProfileBankAccountFormSection(
          bankNameLabel: l10n.memberProfileBankNameLabel,
          bankNameController: _bankNameController,
          bankNameHintText: l10n.memberProfileBankNameHint,
          branchNameLabel: l10n.memberProfileBranchLabel,
          branchNameController: _branchNameController,
          branchNameHintText: l10n.memberProfileBranchHint,
          accountTypeLabel: l10n.memberProfileAccountTypeLabel,
          accountType: _accountType,
          accountTypeItems: _accountTypeItems(context),
          onAccountTypeChanged: (String? value) {
            setState(() {
              _accountType = value;
            });
          },
          accountNumberLabel: l10n.memberProfileAccountNumberLabel,
          accountNumberController: _accountNumberController,
          accountNumberHintText: l10n.memberProfileAccountNumberHint,
          accountHolderLabel: l10n.memberProfileAccountHolderLabel,
          accountHolderController: _accountHolderController,
          accountHolderHintText: l10n.memberProfileAccountHolderHint,
        ),
      ),
    );
  }
}

const String _accountTypeOrdinary = 'ordinary';
const String _accountTypeChecking = 'checking';
