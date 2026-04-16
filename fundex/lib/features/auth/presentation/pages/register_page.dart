import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../settings/presentation/providers/settings_content_providers.dart';
import '../providers/auth_providers.dart';
import '../support/code_send_cooldown.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late final TextEditingController _accountController;
  late final TextEditingController _codeController;
  bool _acceptPolicy = false;
  bool _acceptElectronicDelivery = false;
  bool _acceptAntiSocial = false;
  bool _acceptPersonalInformation = false;
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

  bool _looksLikeEmail(String value) {
    final normalized = value.trim();
    return normalized.contains('@') && normalized.contains('.');
  }

  String get _accountValue => _accountController.text.trim();

  bool get _isAccountFormatValid => _looksLikeEmail(_accountValue);

  bool get _canSendCode {
    return _isAccountFormatValid &&
        !_isSendingCode &&
        !_sendCodeCooldown.isActive;
  }

  bool get _canSubmit {
    final hasRequiredFields =
        _isAccountFormatValid && _codeController.text.trim().isNotEmpty;
    return hasRequiredFields &&
        _acceptPolicy &&
        _acceptElectronicDelivery &&
        _acceptAntiSocial &&
        _acceptPersonalInformation &&
        !_isSubmitting;
  }

  Future<bool> _ensureValidAccountInput() async {
    if (_isAccountFormatValid) {
      return true;
    }
    if (!mounted) {
      return false;
    }
    AppNotice.show(context, message: context.l10n.registerEmailAccountInvalid);
    return false;
  }

  Future<void> _showPolicySheet({required String title, required String? url}) {
    final l10n = context.l10n;
    final normalizedUrl = url?.trim() ?? '';
    if (normalizedUrl.isEmpty) {
      AppNotice.show(context, message: l10n.pdfViewerInvalidUrlNotice);
      return Future<void>.value();
    }
    return openAppPdfViewer(context, url: normalizedUrl, title: title);
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
          .call(
            account: _accountValue,
            intlCode: AuthApiDefaults.defaultIntlCode,
          );

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

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(registerAccountUseCaseProvider)
          .call(
            account: _accountValue,
            code: _codeController.text.trim(),
            intlCode: AuthApiDefaults.defaultIntlCode,
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

    if (!mounted) {
      return;
    }
    setState(() {
      _isSubmitting = false;
    });
    await ref
        .read(authLocalDataSourceProvider)
        .saveLastSignedOutAccount(_accountValue);
    if (!mounted) {
      return;
    }
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final brandGold = theme.appColors.highlightGold;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final operatingCompanyContent = ref
        .watch(settingsOperatingCompanyContentProvider(localeTag))
        .asData
        ?.value;
    final travelTheme = theme.extension<AppFTKTheme>();
    final navBorderColor =
        travelTheme?.cardBorderColor.withValues(alpha: 0.9) ??
        theme.dividerColor;

    return Scaffold(
      key: const Key('register_page'),
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          key: const Key('register_back_button'),
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          l10n.registerTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: navBorderColor),
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(color: theme.colorScheme.surface),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.registerQuickTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: UiTokens.spacing4),
                Text(
                  l10n.registerQuickSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.74,
                    ),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: UiTokens.spacing20),
                EmailTextField(
                  controller: _accountController,
                  inputKey: const Key('register_account_input'),
                  labelText: l10n.registerEmailAccountLabel,
                  hintText: l10n.registerEmailAccountLabel,
                  leadingIcon: Icons.alternate_email_rounded,
                  trailing: Tooltip(
                    message: _sendCodeButtonLabel(l10n.registerSendCode),
                    child: AppNavigationIconButton(
                      key: const Key('register_account_send_code_button'),
                      icon: Icons.send_rounded,
                      size: 34,
                      borderRadius: 10,
                      backgroundColor: brandGold.withValues(
                        alpha: _canSendCode ? 1 : 0.42,
                      ),
                      foregroundColor: _canSendCode
                          ? theme.appColors.onDark
                          : theme.appColors.onDark.withValues(alpha: 0.4),
                      onTap: _canSendCode ? _sendCode : null,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: UiTokens.spacing12),
                VerificationCodeField(
                  key: const Key('register_code_field'),
                  controller: _codeController,
                  labelText: l10n.registerCodeLabel,
                  hintText: l10n.registerCodeLabel,
                  sendCodeLabel: _sendCodeButtonLabel(l10n.registerSendCode),
                  inputKey: const Key('register_code_input'),
                  sendButtonKey: const Key('register_send_code_button'),
                  isSendingCode: _isSendingCode,
                  sendButtonBackgroundColor: brandGold,
                  sendButtonForegroundColor: theme.appColors.onDark,
                  sendButtonFilled: true,
                  onChanged: (_) => setState(() {}),
                  onSendCode: _canSendCode ? _sendCode : null,
                  buttonWidth: 132,
                ),
                const SizedBox(height: UiTokens.spacing12),
                _RegisterPolicyRow(
                  checked: _acceptPolicy,
                  text: l10n.registerAcceptPolicy,
                  actionLabel: l10n.registerPolicyButton,
                  onTap: () => setState(() => _acceptPolicy = !_acceptPolicy),
                  onActionTap: () => _showPolicySheet(
                    title: l10n.registerPolicyTitle,
                    url: operatingCompanyContent?.termsConditionsUrl,
                  ),
                ),
                const SizedBox(height: UiTokens.spacing12),
                _RegisterPolicyRow(
                  checked: _acceptElectronicDelivery,
                  text: l10n.registerElectronicDeliveryDocumentTitle,
                  actionLabel: l10n.registerPolicyButton,
                  onTap: () => setState(
                    () =>
                        _acceptElectronicDelivery = !_acceptElectronicDelivery,
                  ),
                  onActionTap: () => _showPolicySheet(
                    title: l10n.registerElectronicDeliveryDocumentTitle,
                    url: operatingCompanyContent?.electronicInformationUrl,
                  ),
                ),
                const SizedBox(height: UiTokens.spacing12),
                _RegisterPolicyRow(
                  checked: _acceptAntiSocial,
                  text: l10n.registerAntiSocialDocumentTitle,
                  actionLabel: l10n.registerPolicyButton,
                  onTap: () =>
                      setState(() => _acceptAntiSocial = !_acceptAntiSocial),
                  onActionTap: () => _showPolicySheet(
                    title: l10n.registerAntiSocialDocumentTitle,
                    url: operatingCompanyContent?.antiSocialRuleUrl,
                  ),
                ),
                const SizedBox(height: UiTokens.spacing12),
                _RegisterPolicyRow(
                  checked: _acceptPersonalInformation,
                  text: l10n.registerPersonalInformationDocumentTitle,
                  actionLabel: l10n.registerPolicyButton,
                  onTap: () => setState(
                    () => _acceptPersonalInformation =
                        !_acceptPersonalInformation,
                  ),
                  onActionTap: () => _showPolicySheet(
                    title: l10n.registerPersonalInformationDocumentTitle,
                    url: operatingCompanyContent?.personalInformationUrl,
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
                const SizedBox(height: UiTokens.spacing12),
                Center(
                  child: TextButton(
                    key: const Key('register_back_login_button'),
                    onPressed: () => context.go('/login'),
                    child: Text(l10n.registerBackToLogin),
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

class _RegisterPolicyRow extends StatelessWidget {
  const _RegisterPolicyRow({
    required this.checked,
    required this.text,
    required this.actionLabel,
    required this.onTap,
    required this.onActionTap,
  });

  final bool checked;
  final String text;
  final String actionLabel;
  final VoidCallback onTap;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final borderColor = 
    (theme.extension<AppFTKTheme>()?.cardBorderColor ?? theme.dividerColor)
        .withValues(alpha: 0.9);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UiTokens.radius12),
            border: Border.all(color: borderColor),
            color: theme.colorScheme.surface,
          ),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: checked ? accentColor : borderColor,
                    width: 1.5,
                  ),
                  color: checked ? accentColor : Colors.transparent,
                ),
                child: checked
                    ? Icon(Icons.check, size: 14, color: theme.appColors.onDark)
                    : null,
              ),
              const SizedBox(width: UiTokens.spacing8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(text, style: theme.textTheme.bodySmall),
                    const SizedBox(height: UiTokens.spacing4),
                    TextButton(
                      key: const Key('register_policy_button'),
                      onPressed: onActionTap,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(actionLabel),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
