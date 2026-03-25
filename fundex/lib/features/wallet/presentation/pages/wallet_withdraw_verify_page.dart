import 'dart:math' as math;

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/support/code_send_cooldown.dart';
import '../providers/wallet_providers.dart';
import '../support/wallet_withdraw_confirm_models.dart';

class WalletWithdrawVerifyPage extends ConsumerStatefulWidget {
  const WalletWithdrawVerifyPage({
    super.key,
    required this.seed,
  });

  final WalletWithdrawConfirmSeed seed;

  @override
  ConsumerState<WalletWithdrawVerifyPage> createState() =>
      _WalletWithdrawVerifyPageState();
}

class _WalletWithdrawVerifyPageState
    extends ConsumerState<WalletWithdrawVerifyPage> {
  late final TextEditingController _codeController;
  late final FocusNode _codeFocusNode;
  late final CodeSendCooldown _sendCodeCooldown;

  bool _isSendingCode = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController()
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    _codeFocusNode = FocusNode()
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    _sendCodeCooldown = CodeSendCooldown(
      onChanged: () {
        if (mounted) {
          setState(() {});
        }
      },
    )..start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _codeFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    _sendCodeCooldown.dispose();
    super.dispose();
  }

  String _resolvePhone(AuthUser? user) {
    final mobile = user?.mobile?.trim() ?? '';
    if (mobile.isNotEmpty) {
      return mobile;
    }
    return user?.phone?.trim() ?? '';
  }

  String _resolveIntlCode(AuthUser? user) {
    final intlCode = user?.intlTelCode?.trim() ?? '';
    if (intlCode.isNotEmpty) {
      return intlCode;
    }
    return '81';
  }

  String _maskPhone(String phone) {
    final trimmed = phone.trim();
    if (trimmed.length <= 4) {
      return trimmed;
    }
    final visibleDigits = math.min(4, trimmed.length);
    final maskedCount = trimmed.length - visibleDigits;
    return '${'•' * maskedCount}${trimmed.substring(trimmed.length - visibleDigits)}';
  }

  Future<void> _resendCode() async {
    if (_isSendingCode || _sendCodeCooldown.isActive) {
      return;
    }
    setState(() {
      _isSendingCode = true;
    });
    try {
      await ref.read(sendWalletWithdrawApplyCodeUseCaseProvider).call();
      if (!mounted) {
        return;
      }
      _sendCodeCooldown.start();
      AppNotice.show(context, message: context.l10n.walletWithdrawCodeSent);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          context.l10n.loginErrorSendCodeFailed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSendingCode = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }
    final code = _codeController.text.trim();
    if (code.length < 6) {
      AppNotice.show(context, message: context.l10n.walletWithdrawCodeRequired);
      return;
    }
    setState(() {
      _isSubmitting = true;
    });
    try {
      await ref
          .read(submitWalletWithdrawApplyUseCaseProvider)
          .call(widget.seed.draft.copyWith(code: code));
      ref.invalidate(walletWithdrawingListProvider);
      ref.invalidate(walletWithdrawHistoryProvider);
      TextInput.finishAutofillContext();
      if (!mounted) {
        return;
      }
      AppNotice.show(context, message: context.l10n.walletWithdrawSubmitSuccess);
      context.pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          context.l10n.walletWithdrawSubmitFailure,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currency = NumberFormat.currency(
      locale: locale,
      symbol: '¥',
      decimalDigits: 0,
    );
    final currentUser = ref.watch(currentAuthUserProvider).asData?.value;
    final phone = _resolvePhone(currentUser);
    final intlCode = _resolveIntlCode(currentUser);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppNavigationBar(
        title: l10n.walletWithdrawVerifyTitle,
        height: 52,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    l10n.walletWithdrawCodeSentTargetLabel,
                    style: appText.sectionTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    phone.isEmpty
                        ? l10n.settingsPhoneUnavailable
                        : '+$intlCode ${_maskPhone(phone)}',
                    style: appText.cardTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),
                  _WithdrawOtpCodeField(
                    controller: _codeController,
                    focusNode: _codeFocusNode,
                    enabled: !_isSubmitting,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _sendCodeCooldown.isActive
                        ? l10n.walletWithdrawCountdownLabel(
                            _sendCodeCooldown.remainingSeconds,
                          )
                        : l10n.walletWithdrawResendReady,
                    style: appText.body.copyWith(color: colors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: (_isSendingCode || _sendCodeCooldown.isActive)
                        ? null
                        : _resendCode,
                    child: Text(l10n.loginSendCode),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.walletWithdrawVerifyAmountHint(
                      currency.format(widget.seed.draft.amount),
                    ),
                    style: appText.bodySemi.copyWith(
                      color: colors.textPrimary,
                      height: 1.65,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  PrimaryCtaButton(
                    label: l10n.walletWithdrawVerifySubmitAction,
                    fullWidth: true,
                    horizontalPadding: 0,
                    isLoading: _isSubmitting,
                    onPressed:
                        _codeController.text.trim().length < 6 || _isSubmitting
                        ? null
                        : _submit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WithdrawOtpCodeField extends StatelessWidget {
  const _WithdrawOtpCodeField({
    required this.controller,
    required this.focusNode,
    required this.enabled,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final code = controller.text.trim();
    final isFocused = focusNode.hasFocus;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? focusNode.requestFocus : null,
      child: SizedBox(
        height: 56,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Opacity(
                opacity: 0,
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  enabled: enabled,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  autofillHints: const <String>[AutofillHints.oneTimeCode],
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  maxLength: 6,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    color: Colors.transparent,
                    fontSize: 1,
                    height: 1,
                  ),
                  cursorColor: Colors.transparent,
                  showCursor: false,
                ),
              ),
            ),
            IgnorePointer(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  const spacing = 8.0;
                  final boxWidth = (constraints.maxWidth - spacing * 5) / 6;
                  return Row(
                    children: List<Widget>.generate(6, (int index) {
                      final hasValue = index < code.length;
                      final isActive =
                          enabled &&
                          (index == code.length || (code.length == 6 && hasValue));
                      return Container(
                        width: boxWidth,
                        height: 56,
                        margin: EdgeInsets.only(
                          right: index == 5 ? 0 : spacing,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: hasValue || (isFocused && isActive)
                                ? colors.primary
                                : colors.border,
                            width: hasValue || (isFocused && isActive) ? 1.8 : 1.2,
                          ),
                        ),
                        child: Text(
                          hasValue ? code[index] : '',
                          style: appText.pageTitle.copyWith(
                            fontSize: 24,
                            color: colors.textPrimary,
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
