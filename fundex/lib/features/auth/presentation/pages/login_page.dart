import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/features/auth/presentation/support/intl_code_picker_field.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../controllers/auth_controller.dart';
import '../providers/auth_providers.dart';
import '../support/code_send_cooldown.dart';
import '../state/auth_state.dart';

enum _LoginChannel { mobile, email }

const String _loginBrandLockupAssetPath =
    'assets/images/stellavia.logoAndText.light.png';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.openRegisterOnEnter = false});

  final bool openRegisterOnEnter;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  static final RegExp _mobileRegExp = RegExp(r'^[0-9+\-()\s]{6,20}$');

  late final TextEditingController _accountController;
  late final TextEditingController _codeController;
  _LoginChannel _loginChannel = _LoginChannel.email;
  String? _localValidationError;
  late final CodeSendCooldown _sendCodeCooldown;
  String _selectedIntlCode = AuthApiDefaults.defaultIntlCode;
  bool _didOpenRegisterOnEnter = false;

  bool get _isEmailMode => _loginChannel == _LoginChannel.email;

  String _resolveErrorMessage(BuildContext context, AuthErrorKey errorKey) {
    final l10n = context.l10n;
    return switch (errorKey) {
      AuthErrorKey.sendCodeFailed => l10n.loginErrorSendCodeFailed,
      AuthErrorKey.loginFailed => l10n.loginErrorInvalidCode,
    };
  }

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

  void _switchLoginChannel(_LoginChannel channel, AuthController controller) {
    if (_loginChannel == channel) {
      return;
    }

    setState(() {
      _loginChannel = channel;
      _localValidationError = null;
      _accountController.clear();
      _codeController.clear();
    });
    controller.onAccountChanged('');
    controller.onCodeChanged('');
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

  void _continueWithoutLogin() {
    context.go('/home');
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
    _prefillLastSignedOutAccount();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _didOpenRegisterOnEnter || !widget.openRegisterOnEnter) {
        return;
      }
      _didOpenRegisterOnEnter = true;
      context.push('/register');
    });
  }

  Future<void> _prefillLastSignedOutAccount() async {
    final account = await ref
        .read(authLocalDataSourceProvider)
        .readLastSignedOutAccount();
    if (!mounted || account == null || account.trim().isEmpty) {
      return;
    }
    final normalized = account.trim();
    final nextChannel = _looksLikeEmail(normalized)
        ? _LoginChannel.email
        : _LoginChannel.mobile;
    setState(() {
      _loginChannel = nextChannel;
      _accountController.text = normalized;
      _localValidationError = null;
    });
    ref.read(authControllerProvider.notifier).onAccountChanged(normalized);
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
    final theme = Theme.of(context);
    final hotelTheme = theme.extension<AppFTKTheme>();
    final titleStyle = (theme.textTheme.titleSmall ?? const TextStyle())
        .copyWith(fontWeight: FontWeight.bold);
    final effectiveErrorMessage =
        _localValidationError ??
        (state.errorKey != null
            ? _resolveErrorMessage(context, state.errorKey!)
            : null);
    final canSendCode = state.canSendCode && !_sendCodeCooldown.isActive;

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      final didLogin =
          next.session != null && previous?.session != next.session;
      if (didLogin && mounted) {
        ref.read(authSessionProvider.notifier).markAuthenticated();
        context.go('/home');
      }
    });

    return Scaffold(
      key: const Key('login_page'),
      body: DecoratedBox(
        decoration: BoxDecoration(color: theme.colorScheme.surface),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              _LoginHeroHeader(
                subtitle: l10n.loginTitle,
                onClose: _continueWithoutLogin,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SurfacePanelCard(
                        title: l10n.loginModeTitle,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: _LoginChannelChip(
                                key: const Key('login_mode_email_button'),
                                label: l10n.authModeEmail,
                                icon: Icons.alternate_email_rounded,
                                selected: _loginChannel == _LoginChannel.email,
                                onTap: () => _switchLoginChannel(
                                  _LoginChannel.email,
                                  controller,
                                ),
                              ),
                            ),
                            const SizedBox(width: UiTokens.spacing8),
                            Expanded(
                              child: _LoginChannelChip(
                                key: const Key('login_mode_mobile_button'),
                                label: l10n.authModeMobile,
                                icon: Icons.phone_iphone_rounded,
                                selected: _loginChannel == _LoginChannel.mobile,
                                onTap: () => _switchLoginChannel(
                                  _LoginChannel.mobile,
                                  controller,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                  trailing: Tooltip(
                                    message: _sendCodeButtonLabel(
                                      l10n.loginSendCode,
                                    ),
                                    child: AppNavigationIconButton(
                                      key: const Key(
                                        'login_account_send_code_button',
                                      ),
                                      icon: Icons.send_rounded,
                                      size: 34,
                                      borderRadius: 10,
                                      backgroundColor: theme.appColors.primary
                                          .withValues(
                                            alpha: canSendCode ? 0.12 : 0.06,
                                          ),
                                      foregroundColor: canSendCode
                                          ? theme.appColors.primary
                                          : theme.appColors.primary.withValues(
                                              alpha: 0.4,
                                            ),
                                      onTap: canSendCode
                                          ? () => _handleSendCode(controller)
                                          : null,
                                    ),
                                  ),
                                  onChanged: (String value) =>
                                      _onAccountChanged(value, controller),
                                )
                              : PhoneTextField(
                                  controller: _accountController,
                                  inputKey: const Key('login_account_input'),
                                  labelText: l10n.registerMobileAccountLabel,
                                  hintText: l10n.registerMobileAccountLabel,
                                  leadingIcon: Icons.phone_iphone_rounded,
                                  trailing: Tooltip(
                                    message: _sendCodeButtonLabel(
                                      l10n.loginSendCode,
                                    ),
                                    child: AppNavigationIconButton(
                                      key: const Key(
                                        'login_account_send_code_button',
                                      ),
                                      icon: Icons.send_rounded,
                                      size: 34,
                                      borderRadius: 10,
                                      backgroundColor: theme.appColors.primary
                                          .withValues(
                                            alpha: canSendCode ? 0.12 : 0.06,
                                          ),
                                      foregroundColor: canSendCode
                                          ? theme.appColors.primary
                                          : theme.appColors.primary.withValues(
                                              alpha: 0.4,
                                            ),
                                      onTap: canSendCode
                                          ? () => _handleSendCode(controller)
                                          : null,
                                    ),
                                  ),
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
                        onChanged: (String value) =>
                            _onCodeChanged(value, controller),
                        onSendCode: canSendCode
                            ? () => _handleSendCode(controller)
                            : null,
                        buttonWidth: 132,
                      ),
                      const SizedBox(height: UiTokens.spacing8),
                      if (effectiveErrorMessage != null) ...<Widget>[
                        const SizedBox(height: UiTokens.spacing4),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: hotelTheme?.discountChipBackgroundColor
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(
                              UiTokens.radius16,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: UiTokens.spacing12,
                            vertical: UiTokens.spacing12,
                          ),
                          child: Text(
                            effectiveErrorMessage,
                            style:
                                theme
                                    .extension<AppAuthVisualTheme>()
                                    ?.inlineErrorTextStyle ??
                                theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                      const SizedBox(height: UiTokens.spacing12),
                      PrimaryCtaButton(
                        key: const Key('login_submit_button'),
                        label: l10n.loginSubmit,
                        isLoading: state.isLoggingIn,
                        horizontalPadding: 0,
                        onPressed: state.canLogin
                            ? () => _handleLogin(controller)
                            : null,
                      ),
                      const SizedBox(height: UiTokens.spacing4),
                      Center(
                        child: TextButton(
                          key: const Key('to_register_button'),
                          onPressed: () => context.push('/register'),
                          child: Text(l10n.loginCreateAccount),
                        ),
                      ),
                      const SizedBox(height: UiTokens.spacing4),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          key: const Key('continue_as_guest_button'),
                          onPressed: _continueWithoutLogin,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                UiTokens.radius20,
                              ),
                            ),
                          ),
                          child: Text(
                            l10n.loginBrowseAsGuest,
                            style: titleStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginHeroHeader extends StatelessWidget {
  const _LoginHeroHeader({
    required this.subtitle,
    required this.onClose,
  });

  final String subtitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final heroGradientColors = isDark
        ? <Color>[
            Color.alphaBlend(
              colors.brandPrimaryDark.withValues(alpha: 0.34),
              colors.surface,
            ),
            Color.alphaBlend(
              colors.brandPrimary.withValues(alpha: 0.24),
              colors.surfaceAlt,
            ),
            Color.alphaBlend(
              colors.brandPrimaryBright.withValues(alpha: 0.18),
              colors.surface,
            ),
          ]
        : <Color>[colors.heroStart, colors.heroMiddle, colors.heroEnd];
    final heroForegroundColor = colors.onDark;

    return SizedBox(
      width: double.infinity,
      height: 220,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: heroGradientColors,
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 26, 24, 34),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: heroForegroundColor.withValues(alpha: 0.12),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    _loginBrandLockupAssetPath,
                    width: 132,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: heroForegroundColor.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: const Key('login_close_button'),
                onTap: onClose,
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: heroForegroundColor.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Tooltip(
                    message: context.l10n.commonClose,
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: heroForegroundColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginChannelChip extends StatelessWidget {
  const _LoginChannelChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final travelTheme = theme.extension<AppFTKTheme>()!;
    final radius = BorderRadius.circular(16);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: selected
            ? travelTheme.primaryButtonColor.withValues(alpha: 0.14)
            : theme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: radius,
        border: Border.all(
          color: selected
              ? travelTheme.primaryButtonColor.withValues(alpha: 0.45)
              : travelTheme.cardBorderColor.withValues(alpha: 0.95),
          width: selected ? 1.2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  size: 18,
                  color: selected
                      ? travelTheme.primaryButtonColor
                      : travelTheme.categoryIdleIconColor,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: (theme.textTheme.labelLarge ?? const TextStyle())
                        .copyWith(
                          color: selected
                              ? travelTheme.primaryButtonColor
                              : theme.textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
