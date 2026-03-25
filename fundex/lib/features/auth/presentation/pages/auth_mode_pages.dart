import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import 'auth_visual_scaffold.dart';
import '../controllers/auth_controller.dart';
import '../providers/auth_providers.dart';
import '../support/code_send_cooldown.dart';
import '../support/intl_code_picker_field.dart';
import '../state/auth_state.dart';

enum _AuthAccountMode { mobile, email }

class MobileLoginMethodPage extends StatelessWidget {
  const MobileLoginMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AuthMethodLoginPage(mode: _AuthAccountMode.mobile);
  }
}

class EmailLoginMethodPage extends StatelessWidget {
  const EmailLoginMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AuthMethodLoginPage(mode: _AuthAccountMode.email);
  }
}

class MobileRegisterMethodPage extends StatelessWidget {
  const MobileRegisterMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AuthMethodRegisterPage(mode: _AuthAccountMode.mobile);
  }
}

class EmailRegisterMethodPage extends StatelessWidget {
  const EmailRegisterMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AuthMethodRegisterPage(mode: _AuthAccountMode.email);
  }
}

class _AuthMethodLoginPage extends ConsumerStatefulWidget {
  const _AuthMethodLoginPage({required this.mode});

  final _AuthAccountMode mode;

  @override
  ConsumerState<_AuthMethodLoginPage> createState() =>
      _AuthMethodLoginPageState();
}

class _AuthMethodLoginPageState extends ConsumerState<_AuthMethodLoginPage> {
  static final RegExp _mobileRegExp = RegExp(r'^[0-9+\-()\s]{6,20}$');

  late final TextEditingController _accountController;
  late final TextEditingController _codeController;
  late final CodeSendCooldown _sendCodeCooldown;
  String? _localValidationError;
  String _selectedIntlCode = AuthApiDefaults.defaultIntlCode;

  bool get _isEmailMode => widget.mode == _AuthAccountMode.email;

  bool _looksLikeEmail(String value) {
    final normalized = value.trim();
    return normalized.contains('@') && normalized.contains('.');
  }

  bool _looksLikeMobile(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty || normalized.contains('@')) {
      return false;
    }
    return _mobileRegExp.hasMatch(normalized);
  }

  bool get _isAccountFormatValid {
    final value = _accountController.text.trim();
    if (value.isEmpty) {
      return false;
    }
    return _isEmailMode ? _looksLikeEmail(value) : _looksLikeMobile(value);
  }

  String _invalidAccountMessage(BuildContext context) {
    final l10n = context.l10n;
    return _isEmailMode
        ? l10n.loginEmailAccountInvalid
        : l10n.loginMobileAccountInvalid;
  }

  String _resolveErrorMessage(BuildContext context, AuthErrorKey errorKey) {
    final l10n = context.l10n;
    return switch (errorKey) {
      AuthErrorKey.sendCodeFailed => l10n.loginErrorSendCodeFailed,
      AuthErrorKey.loginFailed => l10n.loginErrorInvalidCode,
    };
  }

  bool _ensureValidAccountForSelectedMode(BuildContext context) {
    if (_isAccountFormatValid) {
      if (_localValidationError != null) {
        setState(() {
          _localValidationError = null;
        });
      }
      return true;
    }

    setState(() {
      _localValidationError = _invalidAccountMessage(context);
    });
    return false;
  }

  void _onAccountChanged(String value, AuthController controller) {
    if (_localValidationError != null) {
      setState(() {
        _localValidationError = null;
      });
    } else {
      setState(() {});
    }
    controller.onAccountChanged(value);
  }

  void _onCodeChanged(String value, AuthController controller) {
    if (_localValidationError != null) {
      setState(() {
        _localValidationError = null;
      });
    }
    controller.onCodeChanged(value);
  }

  Future<void> _handleSendCode(AuthController controller) async {
    if (!_ensureValidAccountForSelectedMode(context)) {
      return;
    }
    final sent = await controller.sendCode(
      intlCode: _isEmailMode ? null : _selectedIntlCode,
    );
    if (sent) {
      _sendCodeCooldown.start();
    }
  }

  Future<void> _handleLogin(AuthController controller) async {
    if (!_ensureValidAccountForSelectedMode(context)) {
      return;
    }
    await controller.login(intlCode: _isEmailMode ? null : _selectedIntlCode);
  }

  String _sendCodeButtonLabel(String defaultLabel) {
    if (!_sendCodeCooldown.isActive) {
      return defaultLabel;
    }
    return '${_sendCodeCooldown.remainingSeconds}s';
  }

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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>();
    final effectiveErrorMessage =
        _localValidationError ??
        (state.errorKey != null
            ? _resolveErrorMessage(context, state.errorKey!)
            : null);
    final canSendCode = state.canSendCode && !_sendCodeCooldown.isActive;
    final pageKey = _isEmailMode
        ? const Key('login_email_page')
        : const Key('login_mobile_page');

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      final didLogin =
          next.session != null && previous?.session != next.session;
      if (didLogin && mounted) {
        ref.read(authSessionProvider.notifier).markAuthenticated();
        context.go('/home');
      }
    });

    return AuthVisualScaffold(
      pageKey: pageKey,
      title: _isEmailMode
          ? l10n.authEmailLoginTitle
          : l10n.authMobileLoginTitle,
      subtitle: l10n.authMethodFormSubtitle,
      footer: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                key: const Key('login_method_switch_button'),
                onPressed: () =>
                    context.go(_isEmailMode ? '/login/mobile' : '/login/email'),
                child: Text(
                  _isEmailMode
                      ? l10n.authEntryPhoneLogin
                      : l10n.authEntryEmailLogin,
                ),
              ),
              const SizedBox(width: UiTokens.spacing8),
              TextButton(
                key: const Key('login_method_forgot_button'),
                onPressed: () => context.push('/forgot-password'),
                child: Text(l10n.loginForgotPassword),
              ),
            ],
          ),
          // TextButton(
          //   key: const Key('login_method_register_button'),
          //   onPressed: () => context.push(
          //     _isEmailMode ? '/register/email' : '/register/mobile',
          //   ),
          //   child: Text(l10n.authEntryNonMemberRegisterNow),
          // ),
          TextButton(
            key: const Key('login_method_back_entry_button'),
            onPressed: () => context.go('/login'),
            child: Text(l10n.authBackToLoginEntry),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // _ModeBadge(
          //   icon: _isEmailMode
          //       ? Icons.alternate_email_rounded
          //       : Icons.phone_iphone_rounded,
          //   label: _isEmailMode ? l10n.authModeEmail : l10n.authModeMobile,
          // ),
          const SizedBox(height: UiTokens.spacing12),
          if (!_isEmailMode) ...<Widget>[
            IntlCodePickerField(
              key: const Key('login_intl_code_picker'),
              selectedIntlCode: _selectedIntlCode,
              onChanged: (String value) {
                setState(() {
                  _selectedIntlCode = value;
                });
              },
            ),
            const SizedBox(height: UiTokens.spacing12),
          ],
          (_isEmailMode
                  ? EmailTextField(
                      controller: _accountController,
                      inputKey: const Key('login_account_input'),
                      labelText: l10n.registerEmailAccountLabel,
                      hintText: l10n.registerEmailAccountLabel,
                      leadingIcon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (String value) =>
                          _onAccountChanged(value, controller),
                    )
                  : PhoneTextField(
                      controller: _accountController,
                      inputKey: const Key('login_account_input'),
                      labelText: l10n.registerMobileAccountLabel,
                      hintText: l10n.registerMobileAccountLabel,
                      leadingIcon: Icons.phone_iphone_rounded,
                      textInputAction: TextInputAction.next,
                      onChanged: (String value) =>
                          _onAccountChanged(value, controller),
                    ))
              as Widget,
          const SizedBox(height: UiTokens.spacing12),
          VerificationCodeField(
            key: const Key('login_code_field'),
            controller: _codeController,
            labelText: l10n.loginCodeLabel,
            hintText: l10n.loginCodeLabel,
            sendCodeLabel: _sendCodeButtonLabel(l10n.loginSendCode),
            inputKey: const Key('login_code_input'),
            sendButtonKey: const Key('login_send_code_button'),
            isSendingCode: state.isSendingCode,
            onChanged: (String value) => _onCodeChanged(value, controller),
            onSendCode: canSendCode ? () => _handleSendCode(controller) : null,
            buttonWidth: 132,
          ),
          if (effectiveErrorMessage != null) ...<Widget>[
            const SizedBox(height: UiTokens.spacing12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: hotelTheme?.discountChipBackgroundColor.withValues(
                  alpha: 0.12,
                ),
                borderRadius: BorderRadius.circular(UiTokens.radius16),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: UiTokens.spacing12,
                vertical: UiTokens.spacing12,
              ),
              child: Text(
                effectiveErrorMessage,
                style:
                    Theme.of(
                      context,
                    ).extension<AppAuthVisualTheme>()?.inlineErrorTextStyle ??
                    Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
          const SizedBox(height: UiTokens.spacing16),
          PrimaryCtaButton(
            key: const Key('login_submit_button'),
            label: l10n.loginSubmit,
            isLoading: state.isLoggingIn,
            horizontalPadding: 0,
            onPressed: state.canLogin ? () => _handleLogin(controller) : null,
          ),
        ],
      ),
    );
  }
}

class _AuthMethodRegisterPage extends ConsumerStatefulWidget {
  const _AuthMethodRegisterPage({required this.mode});

  final _AuthAccountMode mode;

  @override
  ConsumerState<_AuthMethodRegisterPage> createState() =>
      _AuthMethodRegisterPageState();
}

class _AuthMethodRegisterPageState
    extends ConsumerState<_AuthMethodRegisterPage> {
  static final RegExp _mobileRegExp = RegExp(r'^[0-9+\-()\s]{6,20}$');

  late final TextEditingController _accountController;
  late final TextEditingController _codeController;
  late final TextEditingController _contactController;
  late final CodeSendCooldown _sendCodeCooldown;
  bool _acceptPolicy = false;
  bool _isSubmitting = false;
  bool _isSendingCode = false;
  String _selectedIntlCode = AuthApiDefaults.defaultIntlCode;

  bool get _isEmailMode => widget.mode == _AuthAccountMode.email;

  bool _looksLikeEmail(String value) {
    final normalized = value.trim();
    return normalized.contains('@') && normalized.contains('.');
  }

  bool _looksLikeMobile(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty || normalized.contains('@')) {
      return false;
    }
    return _mobileRegExp.hasMatch(normalized);
  }

  String get _accountValue => _accountController.text.trim();

  bool get _isAccountFormatValid {
    return _isEmailMode
        ? _looksLikeEmail(_accountValue)
        : _looksLikeMobile(_accountValue);
  }

  bool get _canSendCode {
    return _isAccountFormatValid &&
        !_isSendingCode &&
        !_sendCodeCooldown.isActive;
  }

  bool get _canSubmit {
    final hasRequiredFields =
        _isAccountFormatValid && _codeController.text.trim().isNotEmpty;
    final hasRequiredContact =
        !_isEmailMode || _contactController.text.trim().isNotEmpty;
    return hasRequiredFields &&
        hasRequiredContact &&
        _acceptPolicy &&
        !_isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController();
    _codeController = TextEditingController();
    _contactController = TextEditingController();
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
    _contactController.dispose();
    super.dispose();
  }

  String _invalidAccountMessage(BuildContext context) {
    final l10n = context.l10n;
    return _isEmailMode
        ? l10n.registerEmailAccountInvalid
        : l10n.registerMobileAccountInvalid;
  }

  Future<bool> _ensureValidAccountInput() async {
    if (_isAccountFormatValid) {
      return true;
    }
    if (!mounted) {
      return false;
    }
    AppNotice.show(context, message: _invalidAccountMessage(context));
    return false;
  }

  Future<void> _showPolicySheet() {
    final l10n = context.l10n;
    return AppBottomSheet.showAdaptive<void>(
      context: context,
      builder: (BuildContext sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.registerPolicyTitle,
              style: Theme.of(sheetContext).textTheme.titleLarge,
            ),
            const SizedBox(height: UiTokens.spacing12),
            Text(
              l10n.registerPolicyDescription,
              style: Theme.of(sheetContext).textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
  }

  String _resolveErrorMessage(Object error, String fallback) {
    if (error is StateError) {
      return error.message.toString();
    }
    if (error is NetworkFailure) {
      return error.message;
    }
    return fallback;
  }

  String _sendCodeButtonLabel(String defaultLabel) {
    if (!_sendCodeCooldown.isActive) {
      return defaultLabel;
    }
    return '${_sendCodeCooldown.remainingSeconds}s';
  }

  Future<void> _sendCode() async {
    final l10n = context.l10n;
    if (!await _ensureValidAccountInput()) {
      return;
    }

    setState(() {
      _isSendingCode = true;
    });

    try {
      await ref
          .read(sendRegisterCodeUseCaseProvider)
          .call(account: _accountValue, intlCode: _selectedIntlCode);

      if (!mounted) {
        return;
      }
      _sendCodeCooldown.start();
      AppNotice.show(context, message: l10n.registerSendCodeSuccess);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: _resolveErrorMessage(error, l10n.registerSubmitFailed),
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
    if (!await _ensureValidAccountInput()) {
      return;
    }
    if (!mounted) {
      return;
    }

    if (_isEmailMode && _contactController.text.trim().isEmpty) {
      await AppDialogs.showAdaptiveAlert<void>(
        context: context,
        title: l10n.registerPolicyTitle,
        message: l10n.registerEmailMobileRequired,
        actions: <AppDialogAction<void>>[
          AppDialogAction<void>(label: l10n.commonOk, isDefaultAction: true),
        ],
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(registerAccountUseCaseProvider)
          .call(
            account: _accountValue,
            code: _codeController.text.trim(),
            intlCode: _selectedIntlCode,
            contact: _contactController.text.trim(),
          );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
      });
      await AppDialogs.showAdaptiveAlert<void>(
        context: context,
        title: l10n.registerPolicyTitle,
        message: _resolveErrorMessage(error, l10n.registerSubmitFailed),
        actions: <AppDialogAction<void>>[
          AppDialogAction<void>(label: l10n.commonOk, isDefaultAction: true),
        ],
      );
      return;
    }

    if (!mounted) {
      return;
    }

    await AppDialogs.showAdaptiveAlert<void>(
      context: context,
      title: l10n.registerSuccessTitle,
      message: l10n.registerSuccessMessage,
      actions: <AppDialogAction<void>>[
        AppDialogAction<void>(
          label: l10n.commonBackToLogin,
          isDefaultAction: true,
        ),
      ],
    );

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
      final trimmedContact = _contactController.text.trim();
      final seedPhone = _isEmailMode ? trimmedContact : _accountValue;
      final seedEmail = _isEmailMode
          ? _accountValue
          : (trimmedContact.contains('@') ? trimmedContact : null);
      final nextRoute = _isEmailMode ? '/login/email' : '/login/mobile';
      final route = Uri(
        path: '/member-profile/onboarding',
        queryParameters: <String, String>{
          'next': nextRoute,
          if (seedPhone.isNotEmpty) 'phone': seedPhone,
          if (seedEmail != null && seedEmail.isNotEmpty) 'email': seedEmail,
        },
      ).toString();
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final travelTheme = Theme.of(context).extension<AppFTKTheme>();
    final pageKey = _isEmailMode
        ? const Key('register_email_page')
        : const Key('register_mobile_page');

    return AuthVisualScaffold(
      pageKey: pageKey,
      title: _isEmailMode
          ? l10n.authEmailRegisterTitle
          : l10n.authMobileRegisterTitle,
      subtitle: l10n.authMethodFormSubtitle,
      footer: Column(
        children: <Widget>[
          // TextButton(
          //   key: const Key('register_method_switch_button'),
          //   onPressed: () => context.go(
          //     _isEmailMode ? '/register/mobile' : '/register/email',
          //   ),
          //   child: Text(
          //     _isEmailMode
          //         ? l10n.authEntryPhoneRegister
          //         : l10n.authEntryEmailRegister,
          //   ),
          // ),
          // TextButton(
          //   key: const Key('register_method_login_button'),
          //   onPressed: () =>
          //       context.go(_isEmailMode ? '/login/email' : '/login/mobile'),
          //   child: Text(l10n.commonBackToLogin),
          // ),
          TextButton(
            key: const Key('register_method_back_entry_button'),
            onPressed: () => context.pop(),
            child: Text(l10n.authBackToRegisterEntry),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // _ModeBadge(
          //   icon: _isEmailMode
          //       ? Icons.alternate_email_rounded
          //       : Icons.phone_iphone_rounded,
          //   label: _isEmailMode ? l10n.authModeEmail : l10n.authModeMobile,
          // ),
          const SizedBox(height: UiTokens.spacing12),
          if (!_isEmailMode) ...<Widget>[
            IntlCodePickerField(
              key: const Key('register_intl_code_picker'),
              selectedIntlCode: _selectedIntlCode,
              onChanged: (String value) {
                setState(() {
                  _selectedIntlCode = value;
                });
              },
            ),
            const SizedBox(height: UiTokens.spacing12),
          ],
          (_isEmailMode
                  ? EmailTextField(
                      controller: _accountController,
                      inputKey: const Key('register_account_input'),
                      labelText: l10n.registerEmailAccountLabel,
                      hintText: l10n.registerEmailAccountLabel,
                      leadingIcon: Icons.alternate_email_rounded,
                      trailing: Tooltip(
                        message: _sendCodeButtonLabel(l10n.registerSendCode),
                        child: AppNavigationIconButton(
                          key: const Key(
                            'register_account_send_code_button',
                          ),
                          icon: Icons.send_rounded,
                          size: 34,
                          borderRadius: 10,
                          backgroundColor: Theme.of(context).appColors.primary
                              .withValues(alpha: _canSendCode ? 0.12 : 0.06),
                          foregroundColor: _canSendCode
                              ? Theme.of(context).appColors.primary
                              : Theme.of(context).appColors.primary.withValues(
                                  alpha: 0.4,
                                ),
                          onTap: _canSendCode ? _sendCode : null,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    )
                  : PhoneTextField(
                      controller: _accountController,
                      inputKey: const Key('register_account_input'),
                      labelText: l10n.registerMobileAccountLabel,
                      hintText: l10n.registerMobileAccountLabel,
                      leadingIcon: Icons.phone_iphone_rounded,
                      onChanged: (_) => setState(() {}),
                    ))
              as Widget,
          const SizedBox(height: UiTokens.spacing12),
          VerificationCodeField(
            controller: _codeController,
            labelText: l10n.registerCodeLabel,
            hintText: l10n.registerCodeLabel,
            sendCodeLabel: _sendCodeButtonLabel(l10n.registerSendCode),
            inputKey: const Key('register_code_input'),
            sendButtonKey: const Key('register_send_code_button'),
            isSendingCode: _isSendingCode,
            onChanged: (_) => setState(() {}),
            onSendCode: _canSendCode ? _sendCode : null,
            buttonWidth: 132,
          ),
          const SizedBox(height: UiTokens.spacing12),
          // (_isEmailMode
          //         ? PhoneTextField(
          //             controller: _contactController,
          //             inputKey: const Key('register_contact_input'),
          //             labelText: l10n.registerContactLabel,
          //             hintText: l10n.registerContactHelperEmail,
          //             onChanged: (_) => setState(() {}),
          //           )
          //         : EmailTextField(
          //             controller: _contactController,
          //             inputKey: const Key('register_contact_input'),
          //             labelText: l10n.registerContactLabel,
          //             hintText: l10n.registerContactHelperMobile,
          //             leadingIcon: Icons.contact_mail_outlined,
          //             onChanged: (_) => setState(() {}),
          //           ))
          //     as Widget,
          // const SizedBox(height: UiTokens.spacing8),
          Container(
            decoration: BoxDecoration(
              color: travelTheme?.primaryButtonColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(UiTokens.radius16),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: UiTokens.spacing12,
              vertical: UiTokens.spacing12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Switch.adaptive(
                  value: _acceptPolicy,
                  activeTrackColor: travelTheme?.primaryButtonColor.withValues(
                    alpha: 0.35,
                  ),
                  activeThumbColor: travelTheme?.primaryButtonColor,
                  onChanged: (bool value) {
                    setState(() {
                      _acceptPolicy = value;
                    });
                  },
                ),
                const SizedBox(width: UiTokens.spacing8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () =>
                            setState(() => _acceptPolicy = !_acceptPolicy),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            l10n.registerAcceptPolicy,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                      const SizedBox(height: UiTokens.spacing4),
                      TextButton(
                        key: const Key('register_policy_button'),
                        onPressed: _showPolicySheet,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft,
                        ),
                        child: Text(l10n.registerPolicyButton),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: UiTokens.spacing16),
          PrimaryCtaButton(
            key: const Key('register_submit_button'),
            label: l10n.registerSubmit,
            isLoading: _isSubmitting,
            horizontalPadding: 0,
            onPressed: _canSubmit ? _submit : null,
          ),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _ModeBadge extends StatelessWidget {
  const _ModeBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hotelTheme = theme.extension<AppFTKTheme>()!;

    return Container(
      decoration: BoxDecoration(
        color: hotelTheme.primaryButtonColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(UiTokens.radius16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18, color: hotelTheme.primaryButtonColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: (theme.textTheme.labelLarge ?? const TextStyle()).copyWith(
              color: hotelTheme.primaryButtonColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
