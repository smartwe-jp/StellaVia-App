import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../member_profile/presentation/providers/member_profile_providers.dart';
import '../../../member_profile/presentation/support/member_profile_bank_account_owner_matcher.dart';
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
  late final TextEditingController _branchNumberController;
  late final TextEditingController _accountNumberController;
  late final TextEditingController _accountHolderController;
  String? _accountType = _accountTypeOrdinary;

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
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _branchNameController.dispose();
    _branchNumberController.dispose();
    _accountNumberController.dispose();
    _accountHolderController.dispose();
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

  Future<bool> _isAccountHolderMatchedToVerifiedName() async {
    final profile = await ref
        .read(memberProfileDetailsProvider.future)
        .catchError((Object _) => null);
    final authUser = await ref
        .read(currentAuthUserProvider.future)
        .catchError((Object _) => null);
    return isBankAccountOwnerNameMatchedToVerifiedName(
      accountHolderName: _accountHolderController.text,
      profile: profile,
      authUser: authUser,
    );
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (!_canSubmit) {
      AppNotice.show(context, message: l10n.walletBankSettingsRequiredError);
      return;
    }
    if (!await _isAccountHolderMatchedToVerifiedName()) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: l10n.walletBankSettingsAccountHolderMismatchError,
      );
      return;
    }

    ref.read(walletBankAccountAddingProvider.notifier).state = true;
    try {
      await ref
          .read(addWalletBankAccountUseCaseProvider)
          .call(
            WalletBankAccountDraft.domestic(
              bankName: _bankNameController.text.trim(),
              branchName: _branchNameController.text.trim(),
              branchNumber: _branchNumberController.text.trim(),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MemberProfileBankAccountFormSection(
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
              branchNumberLabel: l10n.walletBankSettingsBranchNumberLabel,
              branchNumberController: _branchNumberController,
              branchNumberHintText: l10n.walletBankSettingsBranchNumberHint,
              accountNumberLabel: l10n.memberProfileAccountNumberLabel,
              accountNumberController: _accountNumberController,
              accountNumberHintText: l10n.memberProfileAccountNumberHint,
              accountHolderLabel: l10n.memberProfileAccountHolderLabel,
              accountHolderController: _accountHolderController,
              accountHolderHintText: l10n.memberProfileAccountHolderHint,
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
                l10n.walletBankSettingsDomesticTip,
                style: theme.appTextTheme.body.copyWith(
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

const String _accountTypeOrdinary = 'ordinary';
const String _accountTypeChecking = 'checking';
