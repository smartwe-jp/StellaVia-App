import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/auth_providers.dart';
import '../support/code_send_cooldown.dart';
import 'auth_visual_scaffold.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  late final TextEditingController _accountController;
  late final TextEditingController _codeController;
  bool _isSubmitting = false;
  bool _isSendingCode = false;
  late final CodeSendCooldown _sendCodeCooldown;

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController();
    _codeController = TextEditingController();
    _sendCodeCooldown = CodeSendCooldown(
      onChanged: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _sendCodeCooldown.dispose();
    _accountController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  bool get _canSendCode {
    return _accountController.text.trim().isNotEmpty &&
        !_isSendingCode &&
        !_sendCodeCooldown.isActive;
  }

  bool get _canSubmit {
    return _accountController.text.trim().isNotEmpty &&
        _codeController.text.trim().isNotEmpty &&
        !_isSubmitting;
  }

  String _sendCodeButtonLabel(String defaultLabel) {
    if (!_sendCodeCooldown.isActive) {
      return defaultLabel;
    }
    return '${_sendCodeCooldown.remainingSeconds}s';
  }

  Future<void> _sendCode() async {
    setState(() {
      _isSendingCode = true;
    });

    try {
      await ref
          .read(sendLoginCodeUseCaseProvider)
          .call(account: _accountController.text.trim());

      if (!mounted) {
        return;
      }
      _sendCodeCooldown.start();
      AppNotice.show(
        context,
        message: context.l10n.forgotPasswordSendCodeSuccess,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message:
            authErrorMessage(error) ?? context.l10n.loginErrorSendCodeFailed,
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
    final l10n = context.l10n;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(loginWithCodeUseCaseProvider)
          .call(
            account: _accountController.text.trim(),
            code: _codeController.text.trim(),
          );
      ref.read(authSessionProvider.notifier).markAuthenticated();
      if (mounted) {
        context.go('/home');
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      await AppDialogs.showAdaptiveAlert<void>(
        context: context,
        title: l10n.forgotPasswordTitle,
        message: authErrorMessage(error) ?? l10n.forgotPasswordRecoverFailed,
        actions: <AppDialogAction<void>>[
          AppDialogAction<void>(label: l10n.commonOk, isDefaultAction: true),
        ],
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
    final l10n = context.l10n;
    final travelTheme = Theme.of(context).extension<AppFTKTheme>();
    return AuthVisualScaffold(
      pageKey: const Key('forgot_password_page'),
      title: l10n.forgotPasswordTitle,
      subtitle: l10n.forgotPasswordSubtitle,
      footer: Center(
        child: TextButton(
          key: const Key('forgot_back_login_button'),
          onPressed: () => context.go('/login'),
          child: Text(l10n.commonBackToLogin),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SurfacePanelCard(
            title: l10n.forgotPasswordTitle,
            subtitle: l10n.forgotPasswordSubtitle,
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: travelTheme?.primaryButtonColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.key_rounded,
                size: 20,
                color: travelTheme?.primaryButtonColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                EmailTextField(
                  controller: _accountController,
                  inputKey: const Key('forgot_account_input'),
                  labelText: l10n.forgotPasswordAccountLabel,
                  hintText: l10n.forgotPasswordAccountLabel,
                  leadingIcon: Icons.person_outline_rounded,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: UiTokens.spacing12),
                VerificationCodeField(
                  controller: _codeController,
                  labelText: l10n.forgotPasswordCodeLabel,
                  hintText: l10n.forgotPasswordCodeLabel,
                  sendCodeLabel: _sendCodeButtonLabel(
                    l10n.forgotPasswordSendCode,
                  ),
                  inputKey: const Key('forgot_code_input'),
                  sendButtonKey: const Key('forgot_send_code_button'),
                  isSendingCode: _isSendingCode,
                  onChanged: (_) => setState(() {}),
                  onSendCode: _canSendCode ? _sendCode : null,
                  buttonWidth: 136,
                ),
              ],
            ),
          ),
          const SizedBox(height: UiTokens.spacing12),
          // SurfacePanelCard(
          //   title: l10n.loginFootnote,
          //   subtitle: l10n.forgotPasswordSendCodeSuccess,
          //   padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       ListItemCard(
          //         title: l10n.forgotPasswordTitle,
          //         location: l10n.forgotPasswordAccountLabel,
          //         subtitle: l10n.forgotPasswordCodeLabel,
          //         priceText: 'OTP',
          //         ratingText: '1/2',
          //         showChevron: false,
          //         trailing: Icon(
          //           Icons.verified_outlined,
          //           color: travelTheme?.primaryButtonColor,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: UiTokens.spacing16),
          PrimaryCtaButton(
            key: const Key('forgot_submit_button'),
            label: l10n.forgotPasswordSubmit,
            isLoading: _isSubmitting,
            horizontalPadding: 0,
            onPressed: _canSubmit ? _submit : null,
          ),
        ],
      ),
    );
  }
}
